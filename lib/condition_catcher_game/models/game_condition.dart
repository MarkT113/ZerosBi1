// lib/condition_catcher_game/models/game_condition.dart
import 'falling_object.dart';

class GameCondition {
  final String displayText;
  final bool Function(FallingObject obj) checkFunction;

  const GameCondition({required this.displayText, required this.checkFunction});
}
