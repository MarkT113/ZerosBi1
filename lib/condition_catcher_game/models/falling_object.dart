// lib/condition_catcher_game/models/falling_object.dart
import 'package:flutter/material.dart';

enum ObjectType { shape, number, letter, icon }

class FallingObject {
  final String id;
  final ObjectType objectType;
  final dynamic value; // e.g., 'circle', 5, 'A', Icons.star
  final Color color;
  Offset position; // Current position (top-left)
  final double speed;
  final double size;
  bool isVisible; // Flag for removal animation or logic
  bool isTapped; // Flag to prevent multi-tapping while disappearing

  FallingObject({
    required this.id,
    required this.objectType,
    required this.value,
    required this.color,
    required this.position,
    required this.speed,
    required this.size,
    this.isVisible = true,
    this.isTapped = false,
  });

  // Example properties check helper
  String get shape => (objectType == ObjectType.shape) ? value as String : '';
  int get number => (objectType == ObjectType.number) ? value as int : -1;
  String get letter => (objectType == ObjectType.letter) ? value as String : '';
  IconData get icon =>
      (objectType == ObjectType.icon) ? value as IconData : Icons.error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FallingObject &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
