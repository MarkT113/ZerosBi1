// lib/widgets/pause_menu_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart'; // For styling

class PauseMenuWidget extends StatelessWidget {
  const PauseMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Material( // Use Material for proper text styling and InkWell effects
        color: Colors.transparent, // Let background dimming show through
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: kPopupBackgroundColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black54)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Size column to content
              children: [
                const Text(
                  "Paused",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 30),
                _buildMenuButton(
                    text: "Continue",
                    icon: Icons.play_arrow,
                    onPressed: gameProvider.togglePause // Continue unpauses
                ),
                const SizedBox(height: 15),
                _buildMenuButton(
                    text: "Restart",
                    icon: Icons.refresh,
                    onPressed: gameProvider.restartGame
                ),
                const SizedBox(height: 15),
                 _buildMenuButton(
                    text: "Quit",
                    icon: Icons.exit_to_app,
                    onPressed: () {
                       // Pop screen AND potentially trigger provider cleanup/reset
                       gameProvider.quitGame(); // Provider handles internal reset
                       if (Navigator.canPop(context)) {
                         Navigator.pop(context); // Exit the game screen
                       }
                    }
                 ),
              ],
            ),
          ),
        ),
    );
  }

   Widget _buildMenuButton({required String text, required IconData icon, required VoidCallback onPressed}) {
      return ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(text),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 45), // Ensure buttons have good size
              textStyle: const TextStyle(fontSize: 16),
              // backgroundColor: Colors.blueGrey, // Example color
              // foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
      );
   }
}