// lib/condition_catcher_game/widgets/score_display_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/condition_catcher_provider.dart';

class ScoreDisplayWidget extends StatelessWidget {
  const ScoreDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.select((ConditionCatcherProvider p) => p.score);
    return Text(
      "Score: $score",
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
    );
  }
}
