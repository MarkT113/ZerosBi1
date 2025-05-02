// lib/condition_catcher_game/widgets/condition_display_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/condition_catcher_provider.dart';

class ConditionDisplayWidget extends StatelessWidget {
  const ConditionDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final conditionText = context
        .select((ConditionCatcherProvider p) => p.currentCondition.displayText);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30), // Pill shape
          border: Border.all(color: Colors.blueGrey, width: 1.5),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)]),
      child: Text(
        conditionText,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}
