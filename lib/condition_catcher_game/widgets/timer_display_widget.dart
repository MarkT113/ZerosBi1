// lib/condition_catcher_game/widgets/timer_display_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/condition_catcher_provider.dart';

class TimerDisplayWidget extends StatelessWidget {
  const TimerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final time =
        context.select((ConditionCatcherProvider p) => p.timeRemaining);
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Text(
      "$minutes:$seconds",
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }
}
