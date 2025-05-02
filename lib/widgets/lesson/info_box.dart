import 'package:flutter/material.dart';

enum InfoBoxType {
  tip,
  note,
  fact,
}

class InfoBox extends StatelessWidget {
  final InfoBoxType type;
  final String content;

  const InfoBox({
    super.key,
    required this.type,
    required this.content,
  });

  Color get _backgroundColor {
    switch (type) {
      case InfoBoxType.tip:
        return Colors.blue.shade50;
      case InfoBoxType.note:
        return Colors.amber.shade50;
      case InfoBoxType.fact:
        return Colors.green.shade50;
    }
  }

  Color get _borderColor {
    switch (type) {
      case InfoBoxType.tip:
        return Colors.blue.shade200;
      case InfoBoxType.note:
        return Colors.amber.shade200;
      case InfoBoxType.fact:
        return Colors.green.shade200;
    }
  }

  IconData get _icon {
    switch (type) {
      case InfoBoxType.tip:
        return Icons.lightbulb_outline;
      case InfoBoxType.note:
        return Icons.note_alt_outlined;
      case InfoBoxType.fact:
        return Icons.auto_awesome_outlined;
    }
  }

  String get _title {
    switch (type) {
      case InfoBoxType.tip:
        return 'Tip';
      case InfoBoxType.note:
        return 'Note';
      case InfoBoxType.fact:
        return 'Fact';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _borderColor),
              const SizedBox(width: 8),
              Text(
                _title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _borderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
} 