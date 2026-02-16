part of 'room_bloc.dart';

abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomActive extends RoomState {
  final RoomModel room;
  final bool isViewerMode;

  RoomActive({required this.room, this.isViewerMode = false});
}

class RoomError extends RoomState {
  final String message;
  RoomError(this.message);
}