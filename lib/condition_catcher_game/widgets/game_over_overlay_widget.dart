// lib/condition_catcher_game/widgets/game_over_overlay_widget.dart
import 'package:flutter/material.dart';

class GameOverOverlayWidget extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const GameOverOverlayWidget({
    super.key,
    required this.score,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Game Over!",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Final Score: $score",
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.amber,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Restart"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(150, 45)),
              onPressed: onRestart,
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Quit"),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(150, 45),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white)),
              onPressed: onQuit,
            ),
          ],
        ),
      ),
    );
  }
}
