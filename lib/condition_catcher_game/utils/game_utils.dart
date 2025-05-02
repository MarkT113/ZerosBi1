// lib/condition_catcher_game/utils/game_utils.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/falling_object.dart';
import '../models/game_condition.dart';

class GameUtils {
  static final _random = Random();
  static const List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal
  ];
  static const List<String> _availableShapes = ['circle', 'square', 'triangle'];
  static const List<IconData> _availableIcons = [
    Icons.star,
    Icons.favorite,
    Icons.lightbulb,
    Icons.cloud,
    Icons.wb_sunny
  ];
  static const String _availableLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // --- Object Generation ---
  static FallingObject generateRandomObject(
      double screenWidth, double speed, double size) {
    final objectType =
        ObjectType.values[_random.nextInt(ObjectType.values.length)];
    dynamic value;
    Color color = _availableColors[_random.nextInt(_availableColors.length)];

    switch (objectType) {
      case ObjectType.shape:
        value = _availableShapes[_random.nextInt(_availableShapes.length)];
        break;
      case ObjectType.number:
        value = _random.nextInt(10); // Numbers 0-9
        break;
      case ObjectType.letter:
        value = _availableLetters[_random.nextInt(_availableLetters.length)];
        break;
      case ObjectType.icon:
        value = _availableIcons[_random.nextInt(_availableIcons.length)];
        // Ensure icons have contrast with background? For now, random color.
        break;
    }

    // Start above the screen at a random horizontal position
    double startX = _random.nextDouble() * (screenWidth - size);
    Offset startPosition = Offset(startX, -size); // Start just above screen

    return FallingObject(
      id: UniqueKey().toString(), // Simple unique ID
      objectType: objectType,
      value: value,
      color: color,
      position: startPosition,
      speed: speed,
      size: size,
    );
  }

  // --- Condition Generation ---
  static GameCondition generateRandomCondition() {
    int conditionType =
        _random.nextInt(6); // Increase range as more conditions are added

    switch (conditionType) {
      case 0: // Color condition
        Color targetColor =
            _availableColors[_random.nextInt(_availableColors.length)];
        String colorName = _colorToString(targetColor);
        return GameCondition(
          displayText: 'Color is $colorName',
          checkFunction: (obj) => obj.color == targetColor,
        );
      case 1: // Shape condition
        String targetShape =
            _availableShapes[_random.nextInt(_availableShapes.length)];
        return GameCondition(
          displayText: 'Shape is $targetShape',
          checkFunction: (obj) =>
              obj.objectType == ObjectType.shape && obj.value == targetShape,
        );
      case 2: // Number property condition (e.g., > 5)
        int threshold = _random.nextInt(7) + 2; // 2-8
        bool greaterThan = _random.nextBool();
        String op = greaterThan ? '>' : '<';
        return GameCondition(
          displayText: 'Number is $op $threshold',
          checkFunction: (obj) =>
              obj.objectType == ObjectType.number &&
              (greaterThan ? obj.value > threshold : obj.value < threshold),
        );
      case 3: // Number parity condition (even/odd)
        bool isEven = _random.nextBool();
        String parity = isEven ? 'Even' : 'Odd';
        return GameCondition(
          displayText: 'Number is $parity',
          checkFunction: (obj) =>
              obj.objectType == ObjectType.number &&
              (isEven ? obj.value % 2 == 0 : obj.value % 2 != 0),
        );
      case 4: // Letter condition (specific letter)
        String targetLetter =
            _availableLetters[_random.nextInt(_availableLetters.length)];
        return GameCondition(
          displayText: 'Letter is $targetLetter',
          checkFunction: (obj) =>
              obj.objectType == ObjectType.letter && obj.value == targetLetter,
        );
      case 5: // Object Type condition
        ObjectType targetType =
            ObjectType.values[_random.nextInt(ObjectType.values.length)];
        String typeName =
            targetType.toString().split('.').last; // Get 'shape', 'number' etc.
        return GameCondition(
          displayText: 'Type is $typeName',
          checkFunction: (obj) => obj.objectType == targetType,
        );
      default: // Fallback - Color condition
        Color targetColor =
            _availableColors[_random.nextInt(_availableColors.length)];
        String colorName = _colorToString(targetColor);
        return GameCondition(
          displayText: 'Color is $colorName',
          checkFunction: (obj) => obj.color == targetColor,
        );
    }
  }

  static String _colorToString(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.teal) return 'Teal';
    return 'Unknown Color';
  }
}
