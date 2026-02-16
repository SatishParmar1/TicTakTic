class ChatMessage {
  final String uid;
  final String text;
  final int timestamp;

  ChatMessage({required this.uid, required this.text, required this.timestamp});

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      uid: map['uid']?.toString() ?? "",
      text: map['text']?.toString() ?? "",
      timestamp: (map['timestamp'] is int) ? map['timestamp'] : 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'text': text,
        'timestamp': timestamp,
      };
}

class RoomModel {
  final String roomId;
  final List<String> board;
  final String turn;
  final String status; // 'waiting', 'playing', 'draw', or winner_uid
  final Map<String, String> players; // uid -> symbol ('X' or 'O') — max 2
  final List<String> viewers; // uids of viewers
  final List<ChatMessage> chat; // live chat messages
  final Map<String, bool> rematchVotes; // uid -> true if voted rematch
  final Map<String, int> score; // symbol -> win count e.g. {"X": 2, "O": 1}
  final String roomType; // 'fixed' = same 2 players, 'rotation' = random from all

  RoomModel({
    required this.roomId,
    required this.board,
    required this.turn,
    required this.status,
    required this.players,
    this.viewers = const [],
    this.chat = const [],
    this.rematchVotes = const {},
    this.score = const {"X": 0, "O": 0},
    this.roomType = "fixed",
  });

  factory RoomModel.fromMap(String roomId, Map<dynamic, dynamic> map) {
    // Board
    final boardRaw = map['board'];
    final board = <String>[];
    if (boardRaw is List) {
      for (var item in boardRaw) {
        board.add(item?.toString() ?? "");
      }
    } else {
      board.addAll(List.filled(9, ""));
    }

    // Players
    final playersRaw = map['players'];
    final players = <String, String>{};
    if (playersRaw is Map) {
      playersRaw.forEach((k, v) => players[k.toString()] = v.toString());
    }

    // Viewers
    final viewersRaw = map['viewers'];
    final viewers = <String>[];
    if (viewersRaw is Map) {
      viewersRaw.forEach((k, v) => viewers.add(k.toString()));
    } else if (viewersRaw is List) {
      for (var v in viewersRaw) {
        if (v != null) viewers.add(v.toString());
      }
    }

    // Chat
    final chatRaw = map['chat'];
    final chat = <ChatMessage>[];
    if (chatRaw is Map) {
      final sorted = chatRaw.entries.toList()
        ..sort((a, b) {
          final aTs = (a.value is Map) ? (a.value['timestamp'] ?? 0) : 0;
          final bTs = (b.value is Map) ? (b.value['timestamp'] ?? 0) : 0;
          return (aTs as int).compareTo(bTs as int);
        });
      for (var entry in sorted) {
        if (entry.value is Map) {
          chat.add(ChatMessage.fromMap(entry.value));
        }
      }
    }

    // Rematch votes
    final rematchRaw = map['rematchVotes'];
    final rematchVotes = <String, bool>{};
    if (rematchRaw is Map) {
      rematchRaw.forEach((k, v) => rematchVotes[k.toString()] = v == true);
    }

    // Score
    final scoreRaw = map['score'];
    final score = <String, int>{"X": 0, "O": 0};
    if (scoreRaw is Map) {
      scoreRaw.forEach((k, v) {
        score[k.toString()] = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
      });
    }

    return RoomModel(
      roomId: roomId,
      board: board,
      turn: map['turn']?.toString() ?? "",
      status: map['status']?.toString() ?? "waiting",
      players: players,
      viewers: viewers,
      chat: chat,
      rematchVotes: rematchVotes,
      score: score,
      roomType: map['roomType']?.toString() ?? "fixed",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'board': board,
      'turn': turn,
      'status': status,
      'players': players,
    };
  }

  String? getWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != "" &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        String winnerSymbol = board[pattern[0]];
        final entry = players.entries.where((e) => e.value == winnerSymbol);
        if (entry.isNotEmpty) return entry.first.key;
        return null;
      }
    }
    return null;
  }

  bool isDraw() {
    return !board.contains("") && getWinner() == null;
  }

  String? getMySymbol(String myUid) => players[myUid];

  bool isMyTurn(String myUid) => turn == myUid;

  bool isViewer(String myUid) =>
      !players.containsKey(myUid) && viewers.contains(myUid);

  bool isPlayer(String myUid) => players.containsKey(myUid);

  int get playerCount => players.length;
  int get viewerCount => viewers.length;
  int get totalCount => playerCount + viewerCount;

  bool get isGameOver {
    return getWinner() != null || isDraw();
  }

  bool get allPlayersVotedRematch {
    if (players.length < 2) return false;
    for (var uid in players.keys) {
      if (rematchVotes[uid] != true) return false;
    }
    return true;
  }
}
