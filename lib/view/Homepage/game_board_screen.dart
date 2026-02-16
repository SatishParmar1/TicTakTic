import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/room_model.dart';
import 'room_bloc.dart';

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> with TickerProviderStateMixin {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  bool _showChat = false;

  // Quick emoji list
  static const List<String> _emojis = [
    '😀', '😂', '🤣', '😎', '🔥', '👏',
    '💪', '🎉', '😤', '🤔', '😢', '👀',
    '❤️', '💀', '🏆', '🤝', 'GG', '😏',
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is RoomInitial) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is! RoomActive) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final room = state.room;
        final isViewerMode = state.isViewerMode;
        final myUid = FirebaseAuth.instance.currentUser?.uid ?? "";
        final mySymbol = room.getMySymbol(myUid);
        final isMyTurn = room.isMyTurn(myUid);
        final winner = room.getWinner();
        final isDraw = room.isDraw();
        final gameOver = winner != null || isDraw;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F0C29),
                  const Color(0xFF302B63),
                  const Color(0xFF24243E),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar
                  _buildTopBar(context, room, isViewerMode),

                  Expanded(
                    child: _showChat
                        ? _buildChatPanel(context, room, myUid)
                        : _buildGameView(
                            context, room, isViewerMode, myUid, mySymbol,
                            isMyTurn, winner, isDraw, gameOver),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── TOP BAR ──
  Widget _buildTopBar(BuildContext context, RoomModel room, bool isViewerMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showLeaveDialog(context),
          ),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isViewerMode ? "SPECTATING" : "TIC-TAC-TOE",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "${room.playerCount} players  •  ${room.viewerCount} viewers  •  ${room.roomType == "rotation" ? "Rotation" : "Fixed"}",
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          // Chat toggle
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  _showChat ? Icons.gamepad : Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => _showChat = !_showChat),
              ),
              if (!_showChat && room.chat.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── GAME VIEW ──
  Widget _buildGameView(
    BuildContext context,
    RoomModel room,
    bool isViewerMode,
    String myUid,
    String? mySymbol,
    bool isMyTurn,
    String? winner,
    bool isDraw,
    bool gameOver,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Score board
          _buildScoreBoard(room),

          const SizedBox(height: 12),

          // Status card
          _buildStatusCard(room, isViewerMode, mySymbol, isMyTurn, winner, isDraw, myUid),

          const SizedBox(height: 16),

          // Board
          _buildGameBoard(context, room, isViewerMode, mySymbol, isMyTurn, winner, isDraw),

          const SizedBox(height: 16),

          // Room key + share buttons
          _buildShareSection(context, room),

          const SizedBox(height: 12),

          // Action buttons (rematch / leave)
          _buildActionButtons(context, room, isViewerMode, winner, isDraw, gameOver, myUid),

          const SizedBox(height: 16),

          // Quick emoji bar
          _buildQuickEmojiBar(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── SCORE BOARD ──
  Widget _buildScoreBoard(RoomModel room) {
    final xScore = room.score["X"] ?? 0;
    final oScore = room.score["O"] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _scoreItem("X", xScore, Colors.cyan),
          Container(width: 1, height: 30, color: Colors.white24),
          Text("SCORE", style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 2)),
          Container(width: 1, height: 30, color: Colors.white24),
          _scoreItem("O", oScore, Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _scoreItem(String symbol, int score, Color color) {
    return Column(
      children: [
        Text(symbol, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
        Text("$score", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── STATUS CARD ──
  Widget _buildStatusCard(
    RoomModel room,
    bool isViewerMode,
    String? mySymbol,
    bool isMyTurn,
    String? winner,
    bool isDraw,
    String myUid,
  ) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (room.status == "waiting") {
      statusText = "Waiting for opponent...";
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
    } else if (winner != null) {
      if (isViewerMode) {
        final winnerSymbol = room.players[winner] ?? "?";
        statusText = "Player $winnerSymbol Wins!";
        statusColor = Colors.amber;
        statusIcon = Icons.emoji_events;
      } else if (winner == myUid) {
        statusText = "You Won!";
        statusColor = Colors.greenAccent;
        statusIcon = Icons.emoji_events;
      } else {
        statusText = "You Lost";
        statusColor = Colors.redAccent;
        statusIcon = Icons.sentiment_dissatisfied;
      }
    } else if (isDraw) {
      statusText = "It's a Draw!";
      statusColor = Colors.grey;
      statusIcon = Icons.handshake;
    } else if (isViewerMode) {
      final turnSymbol = room.players[room.turn] ?? "?";
      statusText = "Player $turnSymbol's Turn";
      statusColor = Colors.white70;
      statusIcon = Icons.visibility;
    } else if (isMyTurn) {
      statusText = "Your Turn ($mySymbol)";
      statusColor = Colors.greenAccent;
      statusIcon = Icons.play_arrow;
    } else {
      statusText = "Opponent's Turn";
      statusColor = Colors.orange;
      statusIcon = Icons.pause;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withAlpha(100), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 10),
          Text(
            statusText,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (isViewerMode) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.withAlpha(80),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text("VIEWER", style: TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ],
        ],
      ),
    );
  }

  // ── GAME BOARD ──
  Widget _buildGameBoard(
    BuildContext context,
    RoomModel room,
    bool isViewerMode,
    String? mySymbol,
    bool isMyTurn,
    String? winner,
    bool isDraw,
  ) {
    final canPlay = !isViewerMode &&
        isMyTurn &&
        winner == null &&
        !isDraw &&
        room.status == "playing";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final value = room.board[index];
              // Highlight winning cells
              final winCells = _getWinningCells(room.board);
              final isWinCell = winCells.contains(index);

              return GestureDetector(
                onTap: () {
                  if (canPlay && value.isEmpty) {
                    context.read<RoomBloc>().add(MakeMove(index));
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isWinCell
                        ? Colors.greenAccent.withAlpha(50)
                        : Colors.white.withAlpha(value.isEmpty ? 10 : 25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isWinCell
                          ? Colors.greenAccent.withAlpha(150)
                          : Colors.white.withAlpha(40),
                      width: isWinCell ? 2.5 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: value == "X" ? Colors.cyan : Colors.pinkAccent,
                        shadows: value.isNotEmpty
                            ? [Shadow(color: (value == "X" ? Colors.cyan : Colors.pinkAccent).withAlpha(120), blurRadius: 15)]
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<int> _getWinningCells(List<String> board) {
    const patterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var p in patterns) {
      if (board[p[0]] != "" && board[p[0]] == board[p[1]] && board[p[1]] == board[p[2]]) {
        return p;
      }
    }
    return [];
  }

  // ── SHARE SECTION ──
  Widget _buildShareSection(BuildContext context, RoomModel room) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Room ID row
          Row(
            children: [
              const Icon(Icons.key, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  room.roomId,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54, size: 18),
                onPressed: () => _copyRoomKey(context, room.roomId),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Two share buttons - Player & Viewer
          Row(
            children: [
              Expanded(
                child: _shareButton(
                  icon: Icons.sports_esports,
                  label: "Invite Player",
                  color: Colors.cyan,
                  onTap: () => Share.share(
                    'Join my Tic-Tac-Toe game as a player!\nRoom Key: ${room.roomId}\nJoin and play!',
                    subject: 'Tic-Tac-Toe - Play with me!',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _shareButton(
                  icon: Icons.visibility,
                  label: "Invite Viewer",
                  color: Colors.purple,
                  onTap: () => Share.share(
                    'Watch my Tic-Tac-Toe game live!\nRoom Key: ${room.roomId}\nJoin as a spectator!',
                    subject: 'Tic-Tac-Toe - Watch Live!',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── ACTION BUTTONS ──
  Widget _buildActionButtons(
    BuildContext context,
    RoomModel room,
    bool isViewerMode,
    String? winner,
    bool isDraw,
    bool gameOver,
    String myUid,
  ) {
    if (isViewerMode) {
      return OutlinedButton.icon(
        onPressed: () => _showLeaveDialog(context),
        icon: const Icon(Icons.exit_to_app),
        label: const Text("Leave"),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white38),
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    if (!gameOver) {
      return OutlinedButton.icon(
        onPressed: () => _showLeaveDialog(context),
        icon: const Icon(Icons.exit_to_app),
        label: const Text("Leave"),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white38),
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    // Game over — show rematch voting
    final myVoted = room.rematchVotes[myUid] == true;
    final votedCount = room.rematchVotes.values.where((v) => v).length;

    return Column(
      children: [
        // Rematch status
        if (votedCount > 0 && !room.allPlayersVotedRematch)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "$votedCount/2 players voted for rematch",
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: myVoted
                    ? null
                    : () => context.read<RoomBloc>().add(VoteRematch()),
                icon: Icon(myVoted ? Icons.check : Icons.refresh),
                label: Text(myVoted ? "Voted!" : "Play Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myVoted ? Colors.green.withAlpha(100) : Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.green.withAlpha(60),
                  disabledForegroundColor: Colors.white60,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showLeaveDialog(context),
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Leave"),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white38),
                  foregroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── QUICK EMOJI BAR ──
  Widget _buildQuickEmojiBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Text("Quick React", style: TextStyle(color: Colors.white38, fontSize: 11)),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _emojis.map((emoji) {
              return InkWell(
                onTap: () => context.read<RoomBloc>().add(SendChatMessage(emoji)),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── CHAT PANEL ──
  Widget _buildChatPanel(BuildContext context, RoomModel room, String myUid) {
    // Auto-scroll to bottom on new messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Column(
      children: [
        // Messages
        Expanded(
          child: room.chat.isEmpty
              ? Center(
                  child: Text(
                    "No messages yet.\nSend an emoji or type a message!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: room.chat.length,
                  itemBuilder: (context, index) {
                    final msg = room.chat[index];
                    final isMe = msg.uid == myUid;
                    final isPlayer = room.players.containsKey(msg.uid);
                    final symbol = room.players[msg.uid];

                    String senderLabel;
                    if (isMe) {
                      senderLabel = "You";
                    } else if (isPlayer && symbol != null) {
                      senderLabel = "Player $symbol";
                    } else {
                      senderLabel = "Viewer";
                    }

                    // Check if it's just an emoji (short text with emoji chars)
                    final isEmoji = msg.text.length <= 4;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: EdgeInsets.symmetric(
                          horizontal: isEmoji ? 8 : 12,
                          vertical: isEmoji ? 4 : 8,
                        ),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.cyan.withAlpha(40)
                              : Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMe ? Colors.cyan.withAlpha(60) : Colors.white.withAlpha(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              senderLabel,
                              style: TextStyle(
                                color: isMe ? Colors.cyan : Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isEmoji ? 28 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Quick emoji row inside chat
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _emojis.map((emoji) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => context.read<RoomBloc>().add(SendChatMessage(emoji)),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Text input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withAlpha(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (text) => _sendTextMessage(context, text),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.cyan, size: 20),
                  onPressed: () => _sendTextMessage(context, _chatController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendTextMessage(BuildContext context, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    context.read<RoomBloc>().add(SendChatMessage(trimmed));
    _chatController.clear();
  }

  void _copyRoomKey(BuildContext context, String roomId) {
    Clipboard.setData(ClipboardData(text: roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Room key copied!"), duration: Duration(seconds: 2)),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Leave Game?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to leave?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RoomBloc>().add(LeaveRoom());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Leave", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
