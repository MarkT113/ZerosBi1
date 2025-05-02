// lib/condition_catcher_game/widgets/countdown_overlay_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/condition_catcher_provider.dart';

class CountdownOverlayWidget extends StatelessWidget {
  const CountdownOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final countdownValue =
        context.select((ConditionCatcherProvider p) => p.countdownValue);

    return Container(
      color: Colors.black.withOpacity(0.6), // Dim background
      child: Center(
        child: Text(
          countdownValue > 0 ? countdownValue.toString() : "Go!",
          style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    blurRadius: 10.0,
                    color: Colors.black54,
                    offset: Offset(0, 0))
              ]),
        ),
      ),
    );
  }
}
