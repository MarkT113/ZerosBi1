// lib/widgets/algorithm_name_pill_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class AlgorithmNamePillWidget extends StatelessWidget {
  const AlgorithmNamePillWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>(); // Watch for changes
    final showPill = gameProvider.showAlgorithmPill;
    final algorithmName = gameProvider.algorithmName;
    final screenWidth = MediaQuery.of(context).size.width;

    // Animate position from top (off-screen) to visible position
    return AnimatedPositioned(
      duration: kDefaultAnimDuration,
      curve: Curves.easeOutCubic, // Nice curve for appearance
      top: showPill ? 20.0 : -60.0, // Animate from above screen
      left: screenWidth * 0.1, // Centered horizontally (adjust positioning)
      right: screenWidth * 0.1,
      child: IgnorePointer( // Pill is just visual, not interactive
        child: AnimatedOpacity( // Fade out as well (optional)
            duration: kDefaultAnimDuration,
            opacity: showPill ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: kAlgorithmPillColor,
                borderRadius: BorderRadius.circular(30.0), // Pill shape
                boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black26)
                ],
              ),
              child: Text(
                algorithmName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
        ),
      ),
    );
  }
}