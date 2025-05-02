// lib/condition_catcher_game/widgets/falling_object_widget.dart
import 'package:flutter/material.dart';
import '../models/falling_object.dart';

class FallingObjectWidget extends StatelessWidget {
  final FallingObject object;
  final VoidCallback onTap;

  const FallingObjectWidget({
    super.key,
    required this.object,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: object.size,
        height: object.size,
        decoration: BoxDecoration(
            color: object.color,
            // Use shape for BoxShape if type is shape, otherwise circle/square
            shape: object.objectType == ObjectType.shape &&
                    object.value == 'circle'
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: object.objectType != ObjectType.shape ||
                    object.value != 'circle'
                ? BorderRadius.circular(
                    object.size * 0.1) // Slight rounding for non-circles
                : null,
            border: Border.all(color: Colors.black54, width: 1.0)),
        child: Center(
          child: _buildObjectContent(),
        ),
      ),
    );
  }

  Widget _buildObjectContent() {
    final style = TextStyle(
      fontSize: object.size * 0.5,
      fontWeight: FontWeight.bold,
      color: object.color.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white, // Contrast text color
    );
    switch (object.objectType) {
      case ObjectType.shape:
        // Shape is determined by BoxDecoration shape/borderRadius, maybe add icon for triangle?
        if (object.value == 'triangle') {
          return Icon(Icons.change_history,
              size: object.size * 0.7, color: style.color);
        }
        return Container(); // Circle/Square shape handled by decoration
      case ObjectType.number:
        return Text(object.value.toString(), style: style);
      case ObjectType.letter:
        return Text(object.value.toString(), style: style);
      case ObjectType.icon:
        return Icon(object.value as IconData,
            size: object.size * 0.7, color: style.color);
    }
  }
}
