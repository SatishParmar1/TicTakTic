import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/room_model.dart';
import '../../repository/firebase_service.dart';
part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<RoomModel>? _roomSubscription;
  String? _currentRoomId;
  bool _isViewerMode = false;

  RoomBloc() : super(RoomInitial()) {
    on<CreateRoom>(_onCreateRoom);
    on<JoinRoom>(_onJoinRoom);
    on<JoinAsViewer>(_onJoinAsViewer);
    on<UpdateRoom>(_onUpdateRoom);
    on<MakeMove>(_onMakeMove);
    on<VoteRematch>(_onVoteRematch);
    on<SendChatMessage>(_onSendChatMessage);
    on<LeaveRoom>(_onLeaveRoom);
  }

  Future<void> _onCreateRoom(CreateRoom event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final room = await _firebaseService.createRoom(roomType: event.roomType);
      _currentRoomId = room.roomId;
      _isViewerMode = false;
      _listenToRoom(room.roomId);
      emit(RoomActive(room: room, isViewerMode: false));
    } catch (e) {
      emit(RoomError("Failed to create room: $e"));
    }
  }

  Future<void> _onJoinRoom(JoinRoom event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final room = await _firebaseService.joinRoom(event.roomId);
      _currentRoomId = room.roomId;
      _isViewerMode = false;
      _listenToRoom(room.roomId);
      emit(RoomActive(room: room, isViewerMode: false));
    } catch (e) {
      emit(RoomError("$e"));
      debugPrint(e.toString());
    }
  }

  Future<void> _onJoinAsViewer(JoinAsViewer event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final room = await _firebaseService.joinAsViewer(event.roomId);
      _currentRoomId = room.roomId;
      _isViewerMode = true;
      _listenToRoom(room.roomId);
      emit(RoomActive(room: room, isViewerMode: true));
    } catch (e) {
      emit(RoomError("Failed to join as viewer: $e"));
    }
  }

  void _listenToRoom(String roomId) {
    _roomSubscription?.cancel();
    _roomSubscription = _firebaseService.listenToRoom(roomId).listen(
      (room) => add(UpdateRoom(room)),
      onError: (error) {
        add(UpdateRoom(RoomModel(
          roomId: roomId,
          board: List.filled(9, ""),
          turn: "",
          status: "error",
          players: {},
        )));
      },
    );
  }

  void _onUpdateRoom(UpdateRoom event, Emitter<RoomState> emit) {
    // Dynamically detect role — after rotation, a viewer may become a player
    final myUid = _firebaseService.currentUserId;
    if (myUid != null) {
      _isViewerMode = !event.room.players.containsKey(myUid);
    }
    emit(RoomActive(room: event.room, isViewerMode: _isViewerMode));
  }

  Future<void> _onMakeMove(MakeMove event, Emitter<RoomState> emit) async {
    if (_currentRoomId == null || state is! RoomActive || _isViewerMode) return;

    try {
      final currentRoom = (state as RoomActive).room;
      final myUid = _firebaseService.currentUserId;
      final mySymbol = currentRoom.players[myUid];

      if (mySymbol == null) return;
      await _firebaseService.makeMove(_currentRoomId!, event.index, mySymbol);
    } catch (e) {
      debugPrint("Move error: $e");
    }
  }

  Future<void> _onVoteRematch(VoteRematch event, Emitter<RoomState> emit) async {
    if (_currentRoomId == null) return;
    try {
      await _firebaseService.voteRematch(_currentRoomId!);
    } catch (e) {
      debugPrint("Rematch vote error: $e");
    }
  }

  Future<void> _onSendChatMessage(SendChatMessage event, Emitter<RoomState> emit) async {
    if (_currentRoomId == null) return;
    try {
      await _firebaseService.sendMessage(_currentRoomId!, event.text);
    } catch (e) {
      debugPrint("Chat error: $e");
    }
  }

  Future<void> _onLeaveRoom(LeaveRoom event, Emitter<RoomState> emit) async {
    if (_currentRoomId == null) return;
    try {
      await _firebaseService.leaveRoom(_currentRoomId!);
      _roomSubscription?.cancel();
      _currentRoomId = null;
      _isViewerMode = false;
      emit(RoomInitial());
    } catch (e) {
      emit(RoomError("Failed to leave room: $e"));
    }
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    if (_currentRoomId != null) {
      _firebaseService.leaveRoom(_currentRoomId!);
    }
    return super.close();
  }
}