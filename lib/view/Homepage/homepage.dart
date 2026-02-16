import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactic/view/Homepage/room_bloc.dart';
import 'package:tictactic/view/Homepage/game_board_screen.dart';

class GameHomePage extends StatelessWidget {
  const GameHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: BlocConsumer<RoomBloc, RoomState>(
          listener: (context, state) {
            if (state is RoomError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
            if (state is RoomActive) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<RoomBloc>(),
                    child: const GameBoardScreen(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withAlpha(30)),
                    ),
                    child: const Icon(Icons.grid_3x3, size: 56, color: Colors.cyan),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "TIC-TAC-TOE",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Real-Time Multiplayer",
                    style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(120), letterSpacing: 2),
                  ),
                  const SizedBox(height: 50),

                  if (state is RoomLoading)
                    const CircularProgressIndicator(color: Colors.cyan)
                  else
                    _buildActionButtons(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          // Create game
          _menuButton(
            icon: Icons.add_circle_outline,
            label: "CREATE NEW GAME",
            color: Colors.cyan,
            filled: true,
            onTap: () => _showCreateRoomDialog(context),
          ),
          const SizedBox(height: 16),

          // Join as player
          _menuButton(
            icon: Icons.sports_esports,
            label: "JOIN AS PLAYER",
            color: Colors.greenAccent,
            filled: false,
            onTap: () => _showJoinDialog(context, asViewer: false),
          ),
          const SizedBox(height: 16),

          // Join as viewer
          _menuButton(
            icon: Icons.visibility,
            label: "JOIN AS VIEWER",
            color: Colors.purpleAccent,
            filled: false,
            onTap: () => _showJoinDialog(context, asViewer: true),
          ),
        ],
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 1.5),
                foregroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Choose Room Type", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _roomTypeOption(
              context: context,
              dialogContext: dialogContext,
              icon: Icons.people,
              title: "Fixed 2 Players",
              description: "Same 2 players play every round.\nViewers can only watch.",
              color: Colors.cyan,
              roomType: "fixed",
            ),
            const SizedBox(height: 12),
            _roomTypeOption(
              context: context,
              dialogContext: dialogContext,
              icon: Icons.shuffle,
              title: "Random Rotation",
              description: "After each match, 2 random\nparticipants become players.",
              color: Colors.amber,
              roomType: "rotation",
            ),
          ],
        ),
      ),
    );
  }

  Widget _roomTypeOption({
    required BuildContext context,
    required BuildContext dialogContext,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String roomType,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(dialogContext);
        context.read<RoomBloc>().add(CreateRoom(roomType: roomType));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color.withAlpha(120), size: 16),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context, {required bool asViewer}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text(
          asViewer ? "Watch a Game" : "Join a Game",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Paste room key here",
            hintStyle: TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withAlpha(15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final key = controller.text.trim();
              if (key.isNotEmpty) {
                if (asViewer) {
                  context.read<RoomBloc>().add(JoinAsViewer(key));
                } else {
                  context.read<RoomBloc>().add(JoinRoom(key));
                }
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: asViewer ? Colors.purple : Colors.green,
            ),
            child: Text(
              asViewer ? "Watch" : "Join",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}