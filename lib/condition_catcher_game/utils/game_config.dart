// lib/condition_catcher_game/utils/game_config.dart
import '../models/difficulty_level.dart';

const Duration kGameDuration = Duration(seconds: 90);

class GameConfig {
  final DifficultyLevel difficulty;

  GameConfig(this.difficulty);

  // --- Game Duration is now constant ---
  Duration get gameDuration => kGameDuration;

  double get objectSpeed {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 1.8; // Adjusted speeds slightly
      case DifficultyLevel.medium:
        return 3.0;
      case DifficultyLevel.hard:
        return 4.5;
    }
  }

  Duration get objectSpawnInterval {
    // Time between *attempts* to spawn a batch
    switch (difficulty) {
      case DifficultyLevel.easy:
        return const Duration(milliseconds: 1100);
      case DifficultyLevel.medium:
        return const Duration(milliseconds: 750);
      case DifficultyLevel.hard:
        return const Duration(milliseconds: 500);
    }
  }

  double get objectSize {
    return 50.0;
  }

  // --- Max objects to *try* spawning in one interval ---
  int get maxSimultaneousSpawns {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 1;
      case DifficultyLevel.medium:
        return 2;
      case DifficultyLevel.hard:
        return 3;
    }
  }
}
