part of 'room_bloc.dart';

abstract class RoomEvent {}

class CreateRoom extends RoomEvent {
  final String roomType; // 'fixed' or 'rotation'
  CreateRoom({this.roomType = "fixed"});
}

class JoinRoom extends RoomEvent {
  final String roomId;
  JoinRoom(this.roomId);
}

class JoinAsViewer extends RoomEvent {
  final String roomId;
  JoinAsViewer(this.roomId);
}

class UpdateRoom extends RoomEvent {
  final RoomModel room;
  UpdateRoom(this.room);
}

class MakeMove extends RoomEvent {
  final int index;
  MakeMove(this.index);
}

class VoteRematch extends RoomEvent {}

class SendChatMessage extends RoomEvent {
  final String text;
  SendChatMessage(this.text);
}

class LeaveRoom extends RoomEvent {}