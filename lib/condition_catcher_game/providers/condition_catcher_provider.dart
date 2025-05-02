// lib/condition_catcher_game/providers/condition_catcher_provider.dart
import 'dart:async';
import 'dart:math'; // For Random and Rect
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/difficulty_level.dart';
import '../models/falling_object.dart';
import '../models/game_condition.dart';
import '../utils/game_utils.dart';
import '../utils/game_config.dart'; // Uses kGameDuration

// --- Add GameState Enum ---
enum GamePlayState { initial, countdown, playing, paused, gameOver }
// ---

class ConditionCatcherProvider with ChangeNotifier implements TickerProvider {
  final _random = Random();

  // --- Game State ---
  int _score = 0;
  Duration _timeRemaining = kGameDuration; // Initialize with constant
  GameCondition _currentCondition = GameUtils.generateRandomCondition();
  List<FallingObject> _fallingObjects = [];
  DifficultyLevel _difficulty = DifficultyLevel.medium;
  GameConfig _config = GameConfig(DifficultyLevel.medium);
  // Use GamePlayState enum
  GamePlayState _gameState = GamePlayState.initial;
  int _countdownValue = 3; // Start countdown from 3

  // --- Timers & Ticker ---
  Timer? _gameTimer;
  Timer? _spawnTimer;
  Timer? _countdownTimer; // Timer for countdown
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;

  // Screen dimensions needed for spawning and bounds checking
  double _screenWidth = 0;
  double _screenHeight = 0;

  // --- Getters ---
  int get score => _score;
  Duration get timeRemaining => _timeRemaining;
  GameCondition get currentCondition => _currentCondition;
  List<FallingObject> get fallingObjects => List.unmodifiable(_fallingObjects);
  DifficultyLevel get difficulty => _difficulty;
  GamePlayState get gameState => _gameState; // Expose game state
  int get countdownValue => _countdownValue; // Expose countdown value
  // Convenience getters for UI logic
  bool get isPlaying => _gameState == GamePlayState.playing;
  bool get isPaused => _gameState == GamePlayState.paused;
  bool get isGameOver => _gameState == GamePlayState.gameOver;
  bool get isInitial => _gameState == GamePlayState.initial;
  bool get isCountingDown => _gameState == GamePlayState.countdown;

  // --- TickerProvider Implementation ---
  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker?.dispose();
    _ticker = Ticker(onTick);
    return _ticker!;
  }

  // --- Game Lifecycle ---

  // Called once from screen initState
  void prepareGame(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;
    // Ensure ticker is ready but not started
    _ticker ??= createTicker(gameLoop);
    resetGame(); // Ensure clean state
  }

  void setDifficulty(DifficultyLevel level) {
    // Can only set difficulty in initial state
    if (_gameState != GamePlayState.initial) return;

    _difficulty = level;
    _config = GameConfig(level);
    _timeRemaining = _config.gameDuration; // Update time display if needed

    // --- Start Countdown ---
    _gameState = GamePlayState.countdown;
    _countdownValue = 3;
    notifyListeners(); // Show countdown

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue--;
      if (_countdownValue <= 0) {
        timer.cancel();
        _startActualGame(); // Start game after countdown
      }
      notifyListeners(); // Update countdown display
    });

    print("Difficulty set to: $_difficulty. Starting countdown...");
  }

  // Called after countdown finishes
  void _startActualGame() {
    print("Starting Actual Game!");
    _gameState = GamePlayState.playing;
    _score = 0;
    // _timeRemaining is already set by config
    _fallingObjects.clear();
    _currentCondition = GameUtils.generateRandomCondition();
    _lastTick = Duration.zero;

    // Start Countdown Timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Only countdown if playing
      if (_gameState == GamePlayState.playing) {
        if (_timeRemaining > Duration.zero) {
          _timeRemaining -= const Duration(seconds: 1);
        } else {
          _gameOver();
        }
        notifyListeners();
      }
    });

    // Start Spawning Objects
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(_config.objectSpawnInterval, (_) {
      // Only spawn if playing
      if (_gameState == GamePlayState.playing) {
        _spawnObjectBatch(); // Call the batch spawning method
      }
    });

    // Start Game Loop Ticker
    _ticker?.start();

    notifyListeners();
  }

  void _gameOver() {
    print("Game Over! Final Score: $_score");
    _gameState = GamePlayState.gameOver;
    _ticker?.stop();
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();
    notifyListeners();
  }

  void resetGame() {
    // Stop everything if running
    _ticker?.stop();
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();

    // Reset state variables
    _gameState = GamePlayState.initial; // Go back to initial state
    _score = 0;
    _timeRemaining =
        _config.gameDuration; // Reset time based on current difficulty
    _fallingObjects.clear();
    _countdownValue = 3; // Reset countdown
    _lastTick = Duration.zero;

    print("Game Reset.");
    notifyListeners();
  }

  void quitGame() {
    _ticker?.stop();
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();
    _gameState =
        GamePlayState.initial; // Or could have a 'quit' state if needed
    _fallingObjects.clear();
    _score = 0;
    // Don't notify here, let the screen handle popping/navigation
    print("Game Quit action triggered.");
  }

  void togglePause() {
    // Can only pause/resume if actively playing
    if (_gameState == GamePlayState.playing) {
      _gameState = GamePlayState.paused;
      _ticker?.stop();
      notifyListeners();
      print("Game Paused.");
    } else if (_gameState == GamePlayState.paused) {
      _gameState = GamePlayState.playing;
      _lastTick = Duration.zero; // Reset last tick time on resume
      _ticker?.start();
      notifyListeners();
      print("Game Resumed.");
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // --- Game Loop & Object Management ---
  void gameLoop(Duration elapsed) {
    // Only run loop if playing
    if (_gameState != GamePlayState.playing) {
      _lastTick = Duration.zero; // Reset tick reference if not playing
      return;
    }

    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }
    final double dt = (elapsed.inMicroseconds - _lastTick.inMicroseconds) /
        Duration.microsecondsPerSecond;
    _lastTick = elapsed;

    if (dt <= 0) return; // Avoid issues with minimal time deltas

    final List<FallingObject> objectsToRemove = [];

    for (var obj in _fallingObjects) {
      if (obj.isVisible) {
        obj.position =
            obj.position.translate(0, obj.speed * 60 * dt); // Update position

        if (obj.position.dy > _screenHeight) {
          // Use stored screen height
          objectsToRemove.add(obj);
        }
      } else {
        objectsToRemove.add(obj); // Remove objects marked invisible (after tap)
      }
    }

    if (objectsToRemove.isNotEmpty) {
      _fallingObjects.removeWhere((obj) => objectsToRemove.contains(obj));
    }

    notifyListeners();
  }

  // --- Modified Spawning Logic ---
  void _spawnObjectBatch() {
    int maxSpawns = _config.maxSimultaneousSpawns;
    // Use the class member _random instance
    int numToSpawn = _random.nextInt(maxSpawns) + 1; // <--- Use _random here
    List<FallingObject> spawnedInBatch = [];
    double objectSize = _config.objectSize;
    double spacing = objectSize * 0.2;

    for (int i = 0; i < numToSpawn; i++) {
      bool positionFound = false;
      int attempts = 0;
      while (!positionFound && attempts < 10) {
        attempts++;
        // GameUtils still uses its own internal _random, which is fine
        final newObject = GameUtils.generateRandomObject(
            _screenWidth, _config.objectSpeed, objectSize);
        // ... rest of overlap check and adding logic ...
        final newRect = Rect.fromLTWH(newObject.position.dx,
            newObject.position.dy, objectSize, objectSize);
        bool overlaps = false;
        for (var existing in spawnedInBatch) {
          final existingRect = Rect.fromLTWH(existing.position.dx,
              existing.position.dy, objectSize, objectSize);
          if (newRect.inflate(spacing).overlaps(existingRect)) {
            overlaps = true;
            break;
          }
        }
        if (!overlaps) {
          spawnedInBatch.add(newObject);
          _fallingObjects.add(newObject);
          positionFound = true;
        }
      }
    }

    if (spawnedInBatch.isNotEmpty) {
      notifyListeners();
    }
  }

  void handleObjectTap(String objectId) {
    // Only handle taps if playing
    if (_gameState != GamePlayState.playing) return;

    final index = _fallingObjects.indexWhere((obj) => obj.id == objectId);
    if (index != -1) {
      final tappedObject = _fallingObjects[index];
      if (tappedObject.isTapped) return;
      tappedObject.isTapped = true;

      bool isCorrect = _currentCondition.checkFunction(tappedObject);
      if (isCorrect) {
        _score++;
      } else {
        _score--;
      }
      tappedObject.isVisible = false; // Mark for removal
      print("Object tapped. Correct: $isCorrect, Score: $_score");
      notifyListeners();
    }
  }
}
