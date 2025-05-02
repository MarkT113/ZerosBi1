// lib/condition_catcher_game/screens/condition_catcher_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/condition_catcher_provider.dart'; // Uses GamePlayState
import '../widgets/falling_object_widget.dart';
import '../widgets/condition_display_widget.dart';
import '../widgets/timer_display_widget.dart';
import '../widgets/score_display_widget.dart';
import '../widgets/difficulty_selector_widget.dart';
import '../widgets/game_over_overlay_widget.dart';
// Import the new countdown widget (we'll create it below)
import '../widgets/countdown_overlay_widget.dart';

class ConditionCatcherScreen extends StatelessWidget {
  const ConditionCatcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConditionCatcherProvider(),
      child: const _ConditionCatcherGameView(),
    );
  }
}

class _ConditionCatcherGameView extends StatefulWidget {
  const _ConditionCatcherGameView();
  @override
  State<_ConditionCatcherGameView> createState() =>
      _ConditionCatcherGameViewState();
}

class _ConditionCatcherGameViewState extends State<_ConditionCatcherGameView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider =
          Provider.of<ConditionCatcherProvider>(context, listen: false);
      final screenSize = MediaQuery.of(context).size;
      // Prepare game, don't start automatically
      provider.prepareGame(screenSize.width, screenSize.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConditionCatcherProvider>();
    final screenSize = MediaQuery.of(context).size;

    return PopScope(
      // Use PopScope for more control over back navigation
      canPop: !provider.isPlaying &&
          !provider.isCountingDown, // Allow back only if not playing/counting
      onPopInvoked: (didPop) {
        if (!didPop) {
          // If pop was prevented (e.g., during game), maybe show pause menu?
          if (provider.isPlaying) provider.togglePause();
        } else {
          // If pop succeeded (e.g. from initial/gameover), ensure cleanup
          provider
              .quitGame(); // Ensure timers are stopped if user force-quits somehow
        }
      },
      child: Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        body: SafeArea(
          child: Stack(
            children: [
              // --- Game Elements Layer (only visible when playing) ---
              if (provider.isPlaying || provider.isPaused)
                ...provider.fallingObjects.where((obj) => obj.isVisible).map(
                      (obj) => Positioned(
                        key: ValueKey(obj.id),
                        left: obj.position.dx,
                        top: obj.position.dy,
                        child: FallingObjectWidget(
                          object: obj,
                          // Only allow taps if actually playing (not paused)
                          onTap: provider.isPlaying
                              ? () => provider.handleObjectTap(obj.id)
                              : () {},
                        ),
                      ),
                    ),

              // --- UI Overlay Layer ---

              // Show Difficulty Selector ONLY in initial state
              if (provider.isInitial)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Select Difficulty",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 20),
                      const DifficultySelectorWidget(),
                    ],
                  ),
                ),

              // Show these UI elements ONLY if counting down, playing, or paused
              if (provider.isCountingDown ||
                  provider.isPlaying ||
                  provider.isPaused) ...[
                // Condition Display
                const Align(
                  alignment: Alignment(0.0, -0.9),
                  child: ConditionDisplayWidget(),
                ),
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TimerDisplayWidget(),
                      const ScoreDisplayWidget(),
                      // Pause Button (show only when playing or paused)
                      IconButton(
                        icon: Icon(
                            provider.isPaused ? Icons.play_arrow : Icons.pause),
                        iconSize: 30,
                        color: Colors.black54,
                        onPressed: provider
                            .togglePause, // Toggle handles state check internally
                      ),
                    ],
                  ),
                ),
              ],

              // --- Game State Overlays ---

              // Countdown Overlay
              if (provider.isCountingDown) const CountdownOverlayWidget(),

              // Pause Overlay (with Quit option)
              if (provider.isPaused)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Paused",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Resume"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 45)),
                        onPressed: provider.togglePause,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text("Restart"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 45)),
                        onPressed:
                            provider.resetGame, // Reset goes to initial state
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton.icon(
                        // Quit Button
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text("Quit"),
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(150, 45),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white)),
                        onPressed: () {
                          provider.quitGame(); // Clean up provider state
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context); // Exit screen
                          }
                        },
                      ),
                    ],
                  )),
                ),

              // Game Over Overlay
              if (provider.isGameOver)
                GameOverOverlayWidget(
                  score: provider.score,
                  onRestart: provider.resetGame, // Reset goes to initial state
                  onQuit: () {
                    provider.quitGame(); // Clean up provider state
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context); // Exit screen
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
