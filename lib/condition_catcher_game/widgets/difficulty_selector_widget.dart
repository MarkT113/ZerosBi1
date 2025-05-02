// lib/condition_catcher_game/widgets/difficulty_selector_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/difficulty_level.dart';
import '../providers/condition_catcher_provider.dart';

class DifficultySelectorWidget extends StatelessWidget {
  const DifficultySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        context.read<ConditionCatcherProvider>(); // Read only needed
    final currentDifficulty =
        context.select((ConditionCatcherProvider p) => p.difficulty);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: DifficultyLevel.values.map((level) {
        bool isSelected = level == currentDifficulty;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: OutlinedButton(
            onPressed: () => provider.setDifficulty(level),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: isSelected
                  ? Colors.blueGrey.shade200
                  : Colors.white.withOpacity(0.7),
              side: BorderSide(
                  color: isSelected
                      ? Colors.blueGrey.shade600
                      : Colors.blueGrey.shade300,
                  width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              level.name[0].toUpperCase(), // E, M, H
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black54),
            ),
          ),
        );
      }).toList(),
    );
  }
}
