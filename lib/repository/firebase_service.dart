import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/room_model.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<String> _ensureAuthenticated() async {
    if (_auth.currentUser != null) return _auth.currentUser!.uid;
    debugPrint("FirebaseService: Signing in anonymously...");
    final credential = await _auth.signInAnonymously();
    final uid = credential.user?.uid;
    if (uid == null) throw Exception("Authentication failed");
    debugPrint("FirebaseService: Signed in as $uid");
    return uid;
  }

  // ──────────── CREATE ROOM ────────────
  Future<RoomModel> createRoom({String roomType = "fixed"}) async {
    final uid = await _ensureAuthenticated();
    final newRoomRef = _db.ref("rooms").push();
    final roomId = newRoomRef.key!;

    final roomData = {
      "board": List.filled(9, ""),
      "turn": uid,
      "status": "waiting",
      "players": {uid: "X"},
      "score": {"X": 0, "O": 0},
      "roomType": roomType,
    };

    await newRoomRef.set(roomData);
    await _setupOnDisconnect(roomId, uid, isPlayer: true);
    return RoomModel.fromMap(roomId, roomData);
  }

  // ──────────── JOIN AS PLAYER ────────────
  Future<RoomModel> joinRoom(String roomId) async {
    final uid = await _ensureAuthenticated();
    final roomRef = _db.ref("rooms/$roomId");
    final snapshot = await roomRef.get();

    if (!snapshot.exists) throw Exception("Room not found");
    final data = snapshot.value;
    if (data == null) throw Exception("Room data is null");

    final roomData = Map<String, dynamic>.from(data as Map);
    final playersRaw = roomData['players'];
    final players = <String, String>{};
    if (playersRaw is Map) {
      playersRaw.forEach((k, v) => players[k.toString()] = v.toString());
    }

    if (players.containsKey(uid)) {
      return RoomModel.fromMap(roomId, roomData);
    }

    if (players.length >= 2) {
      throw Exception("Room is full. Join as a viewer instead!");
    }

    players[uid] = "O";
    await roomRef.update({"players": players, "status": "playing"});
    await _setupOnDisconnect(roomId, uid, isPlayer: true);

    final updated = await roomRef.get();
    return RoomModel.fromMap(roomId, Map<String, dynamic>.from(updated.value as Map));
  }

  // ──────────── JOIN AS VIEWER ────────────
  Future<RoomModel> joinAsViewer(String roomId) async {
    final uid = await _ensureAuthenticated();
    final roomRef = _db.ref("rooms/$roomId");
    final snapshot = await roomRef.get();

    if (!snapshot.exists) throw Exception("Room not found");

    // Add to viewers map   viewers/{uid}: true
    await roomRef.child("viewers/$uid").set(true);
    await _setupOnDisconnect(roomId, uid, isPlayer: false);

    final updated = await roomRef.get();
    return RoomModel.fromMap(roomId, Map<String, dynamic>.from(updated.value as Map));
  }

  // ──────────── MAKE MOVE ────────────
  Future<void> makeMove(String roomId, int index, String symbol) async {
    final uid = await _ensureAuthenticated();
    final roomRef = _db.ref("rooms/$roomId");
    final snapshot = await roomRef.get();

    if (!snapshot.exists) throw Exception("Room not found");
    final roomData = Map<String, dynamic>.from(snapshot.value as Map);

    final boardRaw = roomData['board'];
    final board = <String>[];
    if (boardRaw is List) {
      for (var item in boardRaw) {
        board.add(item?.toString() ?? "");
      }
    }

    final playersRaw = roomData['players'];
    final players = <String, String>{};
    if (playersRaw is Map) {
      playersRaw.forEach((k, v) => players[k.toString()] = v.toString());
    }

    if (board[index] != "") throw Exception("Cell already occupied");
    if (roomData['turn'] != uid) throw Exception("Not your turn");

    board[index] = symbol;

    final tempRoom = RoomModel(
      roomId: roomId,
      board: board,
      turn: uid,
      status: "playing",
      players: players,
    );

    String? winner = tempRoom.getWinner();
    bool draw = tempRoom.isDraw();

    String newStatus = "playing";
    final updates = <String, dynamic>{
      "board": board,
    };

    if (winner != null) {
      newStatus = winner;
      // Increment winner's score
      final winnerSymbol = players[winner] ?? "X";
      final scoreRaw = roomData['score'];
      final score = <String, int>{"X": 0, "O": 0};
      if (scoreRaw is Map) {
        scoreRaw.forEach((k, v) {
          score[k.toString()] = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
        });
      }
      score[winnerSymbol] = (score[winnerSymbol] ?? 0) + 1;
      updates["score"] = score;
    } else if (draw) {
      newStatus = "draw";
    }

    String nextTurn = players.keys.firstWhere(
      (key) => key != uid,
      orElse: () => uid,
    );

    updates["turn"] = nextTurn;
    updates["status"] = newStatus;

    await roomRef.update(updates);
  }

  // ──────────── LISTEN ────────────
  Stream<RoomModel> listenToRoom(String roomId) {
    return _db.ref("rooms/$roomId").onValue.map((event) {
      if (event.snapshot.value == null) throw Exception("Room deleted");
      return RoomModel.fromMap(
        roomId,
        Map<String, dynamic>.from(event.snapshot.value as Map),
      );
    });
  }

  // ──────────── VOTE REMATCH ────────────
  Future<void> voteRematch(String roomId) async {
    final uid = await _ensureAuthenticated();
    await _db.ref("rooms/$roomId/rematchVotes/$uid").set(true);

    // Check if both players voted
    final snapshot = await _db.ref("rooms/$roomId").get();
    if (!snapshot.exists) return;
    final roomData = Map<String, dynamic>.from(snapshot.value as Map);
    final room = RoomModel.fromMap(roomId, roomData);

    if (room.allPlayersVotedRematch) {
      if (room.roomType == "rotation") {
        // ROTATION MODE: Randomly pick 2 from all participants
        final allUids = <String>[...room.players.keys, ...room.viewers];
        allUids.shuffle(Random());

        final newPlayers = <String, String>{};
        final newViewers = <String, bool>{};

        if (allUids.length >= 2) {
          newPlayers[allUids[0]] = "X";
          newPlayers[allUids[1]] = "O";
          for (int i = 2; i < allUids.length; i++) {
            newViewers[allUids[i]] = true;
          }
        } else if (allUids.length == 1) {
          newPlayers[allUids[0]] = "X";
        }

        final firstTurn = newPlayers.entries
            .firstWhere((e) => e.value == "X", orElse: () => newPlayers.entries.first)
            .key;

        await _db.ref("rooms/$roomId").update({
          "board": List.filled(9, ""),
          "turn": firstTurn,
          "status": newPlayers.length >= 2 ? "playing" : "waiting",
          "players": newPlayers,
          "viewers": newViewers.isEmpty ? null : newViewers,
          "rematchVotes": null,
        });
      } else {
        // FIXED MODE: Keep same 2 players
        String firstPlayer = room.players.entries
            .firstWhere((e) => e.value == "X", orElse: () => room.players.entries.first)
            .key;

        await _db.ref("rooms/$roomId").update({
          "board": List.filled(9, ""),
          "turn": firstPlayer,
          "status": "playing",
          "rematchVotes": null,
        });
      }
    }
  }

  // ──────────── SEND CHAT MESSAGE ────────────
  Future<void> sendMessage(String roomId, String text) async {
    final uid = await _ensureAuthenticated();
    final chatRef = _db.ref("rooms/$roomId/chat").push();
    await chatRef.set({
      "uid": uid,
      "text": text,
      "timestamp": ServerValue.timestamp,
    });

    // Keep only last 50 messages to save bandwidth
    final snap = await _db.ref("rooms/$roomId/chat").get();
    if (snap.exists && snap.value is Map) {
      final msgs = (snap.value as Map).keys.toList();
      if (msgs.length > 50) {
        final toDelete = msgs.sublist(0, msgs.length - 50);
        final updates = <String, dynamic>{};
        for (var key in toDelete) {
          updates[key.toString()] = null;
        }
        await _db.ref("rooms/$roomId/chat").update(updates);
      }
    }
  }

  // ──────────── ON DISCONNECT ────────────
  Future<void> _setupOnDisconnect(String roomId, String uid, {required bool isPlayer}) async {
    if (isPlayer) {
      await _db.ref("rooms/$roomId/players/$uid").onDisconnect().remove();
    } else {
      await _db.ref("rooms/$roomId/viewers/$uid").onDisconnect().remove();
    }
  }

  Future<void> cancelDisconnect(String roomId, String uid) async {
    await _db.ref("rooms/$roomId/players/$uid").onDisconnect().cancel();
    await _db.ref("rooms/$roomId/viewers/$uid").onDisconnect().cancel();
  }

  Future<void> deleteRoom(String roomId) async {
    await _db.ref("rooms/$roomId").remove();
  }

  // ──────────── LEAVE ROOM ────────────
  Future<void> leaveRoom(String roomId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final roomRef = _db.ref("rooms/$roomId");
    final snapshot = await roomRef.get();
    if (!snapshot.exists) return;

    final roomData = Map<String, dynamic>.from(snapshot.value as Map);
    final playersRaw = roomData['players'];
    final players = <String, dynamic>{};
    if (playersRaw is Map) {
      playersRaw.forEach((k, v) => players[k.toString()] = v);
    }

    // Remove from viewers if viewer
    await roomRef.child("viewers/$uid").remove();

    if (players.containsKey(uid)) {
      players.remove(uid);
      if (players.isEmpty) {
        await deleteRoom(roomId);
      } else {
        await roomRef.update({
          "players": players,
          "status": "waiting",
        });
      }
    }

    await cancelDisconnect(roomId, uid);
  }
}
