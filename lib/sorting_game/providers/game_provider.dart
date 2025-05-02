// lib/providers/game_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // For ListEquality

import '../models/grid_cell_state.dart';
import '../models/tool_type.dart';
import '../models/game_item.dart';
import '../models/sorting_step.dart';
import '../utils/constants.dart';
import '../utils/bubble_sort_logic.dart'; // We'll create this next

class GameProvider with ChangeNotifier {
  // --- Private State ---
  bool _isLoading = true;
  List<List<GridCellState>> _gridState = [];
  List<int> _initialArray = [];
  List<int> _currentArray = [];
  List<SortingStep> _correctSteps = [];
  int _currentStepIndex = 0;
  int _score = 0;
  String _algorithmName = "Bubble Sort"; // Start with Bubble Sort

  ToolType? _selectedToolFromMenu; // Tool selected in menu for click-placement
  GameItem? _draggedItem; // Item currently being dragged
  Offset? _dragPosition; // Position of the dragged item for visual feedback

  // UI Interaction State
  GridCellState? _tappedCellForContextMenu; // Cell whose item is tapped for context menu (delete/action)
  bool _showMachinePopup = false;
  GridCellState? _configuringMachineCell; // Which machine's popup is open
  bool _showListPopup = false;
  GridCellState? _configuringListCell; // Which list tool's popup is open

  bool _isPaused = false;
  bool _toolsMenuOpen = false;
  bool _showAlgorithmPill = false;

  Timer? _pillTimer;

  // --- Getters ---
  bool get isLoading => _isLoading;
  List<List<GridCellState>> get gridState => _gridState;
  List<int> get currentArray => List.unmodifiable(_currentArray); // Prevent direct mutation
  int get score => _score;
  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => _correctSteps.length;
  String get algorithmName => _algorithmName;
  bool get isPaused => _isPaused;
  bool get toolsMenuOpen => _toolsMenuOpen;
  bool get showAlgorithmPill => _showAlgorithmPill;
  ToolType? get selectedToolFromMenu => _selectedToolFromMenu;
  GameItem? get draggedItem => _draggedItem;
  Offset? get dragPosition => _dragPosition; // For showing item during drag
  GridCellState? get tappedCellForContextMenu => _tappedCellForContextMenu; // To show X/Action buttons
  bool get showMachinePopup => _showMachinePopup;
  GridCellState? get configuringMachineCell => _configuringMachineCell;
  bool get showListPopup => _showListPopup;
  GridCellState? get configuringListCell => _configuringListCell;

  GameProvider() {
    // Initialize game on creation
    initGame();
  }

  @override
  void dispose() {
    _pillTimer?.cancel();
    super.dispose();
  }

  // --- Initialization ---
  void initGame() {
    _isLoading = true;
    _toolsMenuOpen = false; // Close menu on init/restart
    _tappedCellForContextMenu = null; // Hide context menus
    _configuringMachineCell = null;
    _showMachinePopup = false;
    _configuringListCell = null;
    _showListPopup = false;
    notifyListeners(); // Notify early for loading state

    // 1. Generate Random Array
    _initialArray = _generateRandomList(kInitialArraySize, kMaxRandomNumber);
    _currentArray = List.from(_initialArray);

    // 2. Initialize Grid
    _gridState = List.generate(
      kGridRows,
      (row) => List.generate(
        kGridColumns,
        (col) => GridCellState(row: row, column: col),
      ),
    );

    // 3. Generate Correct Sorting Steps (Bubble Sort specific for now)
    _correctSteps = generateBubbleSortSteps(_initialArray);
    _currentStepIndex = 0;
    _score = 0;

    // 4. Reset other states
    _isPaused = false;
    _selectedToolFromMenu = null;
    _draggedItem = null;
    _dragPosition = null;

    _isLoading = false;

    // 5. Show Algorithm Pill
    _showAlgorithmPill = true;
    _pillTimer?.cancel(); // Cancel previous timer if any
    _pillTimer = Timer(kAlgorithmPillDuration, () {
      _showAlgorithmPill = false;
      if (hasListeners) { // Check if provider is still mounted
          notifyListeners();
      }
    });

    notifyListeners(); // Notify UI about the new game state
  }

  List<int> _generateRandomList(int size, int maxVal) {
    final random = Random();
    return List.generate(size, (_) => random.nextInt(maxVal));
  }

  // --- Game Flow ---
  void restartGame() {
    initGame();
  }

  void togglePause() {
    if (!_isLoading) {
      _isPaused = !_isPaused;
      // Close any popups when pausing
      if (_isPaused) {
          _hideContextMenus();
          closeMachineConfig();
          closeListConfig();
      }
      notifyListeners();
    }
  }

  void quitGame() {
    // In a real app, this might involve Navigator.pop(context)
    // For now, we can just reset or signal UI element
    print("Quit Game Action Triggered");
    restartGame(); // Or navigate away
  }

  // --- UI Interaction ---
  void toggleToolsMenu() {
    _toolsMenuOpen = !_toolsMenuOpen;
    _hideContextMenus(); // Hide context menus when opening/closing tools
    notifyListeners();
  }

  void selectToolForPlacement(ToolType? toolType) {
      _selectedToolFromMenu = toolType;
      _hideContextMenus(); // Clear context menu when selecting a tool
      print("Selected tool from menu: $toolType");
      notifyListeners();
  }

  void updateDragPosition(Offset? position) {
      _dragPosition = position;
      notifyListeners(); // To update dragged item visuals
  }

  void startDrag(GameItem item) {
      _draggedItem = item;
      _hideContextMenus();
      _selectedToolFromMenu = null; // Clear click-placement selection
      notifyListeners();
  }

  void endDrag() {
      _draggedItem = null;
      _dragPosition = null;
      notifyListeners();
  }

  // Called when an item is successfully dropped onto a cell
  void handleDrop(int row, int col, GameItem droppedItem) {
    print("Dropped ${droppedItem.type} onto ($row, $col)");
    _placeItem(row, col, _createGameItemInstance(droppedItem.type)); // Place a new instance
    _draggedItem = null; // Clear dragged item state
    _dragPosition = null;
    notifyListeners();
  }

  // Called when a grid cell is tapped
  void handleCellTap(int row, int col) {
    if (_isPaused || _isLoading) return;
    _hideContextMenus(); // Hide any previous context menu

    final currentCell = _gridState[row][col];

    if (_selectedToolFromMenu != null) {
      // --- Click-to-Place Logic ---
      print("Placing ${_selectedToolFromMenu!} onto ($row, $col)");
      _placeItem(row, col, _createGameItemInstance(_selectedToolFromMenu!));
      _selectedToolFromMenu = null; // Consume the selection
    } else if (!currentCell.isEmpty) {
       // --- Tap on Existing Item Logic ---
       print("Tapped item at ($row, $col): ${currentCell.gameItem!.type}");
       _tappedCellForContextMenu = currentCell; // Show context menu (X / Action)
    } else {
        // Tapped empty cell without a tool selected - do nothing or maybe deselect?
        _selectedToolFromMenu = null; // Deselect tool if empty cell tapped
    }
    notifyListeners();
  }

   // Hides the little X and Action buttons
   void _hideContextMenus() {
       if (_tappedCellForContextMenu != null) {
           _tappedCellForContextMenu = null;
           notifyListeners(); // Notify UI to hide buttons
       }
   }

  // Called when the 'X' button on an item is clicked
  void requestItemRemoval(int row, int col) {
    if (_gridState[row][col].gameItem != null) {
       print("Removing item at ($row, $col)");
       _gridState[row][col] = _gridState[row][col].copyWith(removeGameItem: true);
       _hideContextMenus(); // Hide menu after action
       notifyListeners();
       // TODO: Add 'poof' animation trigger here later
    }
  }


  // --- Item Placement & Creation ---
  void _placeItem(int row, int col, GameItem newItem) {
    // Replace whatever is in the cell with the new item
    _gridState[row][col] = _gridState[row][col].copyWith(gameItem: newItem);
    _hideContextMenus(); // Ensure context menus are hidden after placement
    notifyListeners();
    // TODO: Potentially check connections or trigger game logic updates here
  }

  // Creates a new instance of a GameItem based on ToolType
  // Important for ensuring items on the grid are unique instances
  GameItem _createGameItemInstance(ToolType type) {
      switch (type) {
          case ToolType.conveyor: return ConveyorItem();
          case ToolType.machine: return MachineItem();
          case ToolType.basket: return BasketItem(); // Default to input bin
          case ToolType.swap: return SwapItem();
          case ToolType.keySlot: return KeySlotItem();
          case ToolType.listSlot: return ListSlotItem();
          case ToolType.comparisonOperator:
              // This case shouldn't happen for direct placement from menu
              // Operators are placed via the machine popup
              print("Warning: Attempted to create ComparisonOperator instance directly");
              // Return a placeholder or handle error appropriately
              return ConveyorItem(); // Fallback? Or throw error?
      }
  }


  // --- Tool Specific Actions ---

  // --- Machine ---
  void requestMachineConfig(int row, int col) {
      // ... (unchanged)
        if (_gridState[row][col].gameItem is MachineItem) {
          _configuringMachineCell = _gridState[row][col];
          _showMachinePopup = true;
          _hideContextMenus();
          notifyListeners();
      }
  }

  void selectMachineOperator(ComparisonOperator operator) { // Keep this non-nullable
      if (_configuringMachineCell != null && _configuringMachineCell!.gameItem is MachineItem) {
          // ... (logic as before) ...
           final currentMachine = _configuringMachineCell!.gameItem as MachineItem;
           final updatedMachine = currentMachine.copyWith(selectedOperator: operator);
           _gridState[_configuringMachineCell!.row][_configuringMachineCell!.column] =
               _configuringMachineCell!.copyWith(gameItem: updatedMachine);
           print("Set operator for machine at (${_configuringMachineCell!.row}, ${_configuringMachineCell!.column}) to $operator");
           closeMachineConfig(); // Use the dedicated close method internally too
      }
  }

  // Make this public (or rename _closeMachineConfig to this)
  void closeMachineConfig() {
      if (_showMachinePopup) {
        _showMachinePopup = false;
        _configuringMachineCell = null;
        notifyListeners();
      }
  }

  // --- List Slot ---
  void requestListConfig(int row, int col) {
     // ... (unchanged)
       if (_gridState[row][col].gameItem is ListSlotItem) {
          _configuringListCell = _gridState[row][col];
          _showListPopup = true;
          _hideContextMenus();
          notifyListeners();
      }
  }

  void executeListTransfer(int startIndex) { // Keep this non-nullable
      // Check for the explicit "close" signal if you used one, otherwise proceed
      if (startIndex < 0) { // Example: using negative index as signal to close
          closeListConfig();
          return;
      }

      if (_configuringListCell != null && _configuringListCell!.gameItem is ListSlotItem) {
          // ... (rest of the execution logic as before) ...
           List<int> listToTransfer = [11, 22, 33]; // Placeholder!
           if (startIndex >= 0 && startIndex + listToTransfer.length <= _currentArray.length) {
               // ... (validation, step check, array update) ...
                _checkAndRecordAction(TransferStep(startIndex: startIndex, transferredValues: listToTransfer));
                _currentArray.setRange(startIndex, startIndex + listToTransfer.length, listToTransfer);
                closeListConfig(); // Use the dedicated close method internally too
                notifyListeners();
           } else {
                print("Error: Invalid start index for list transfer.");
                closeListConfig();
           }
      }
  }

   // Make this public (or rename _closeListConfig to this)
   void closeListConfig() {
       if (_showListPopup) {
         _showListPopup = false;
         _configuringListCell = null;
         notifyListeners();
       }
   }

  // ... (rest of the provider code) ...

   // --- Swap ---
   // This needs to be triggered potentially by placing the swap tool
   // or maybe running a 'simulation' step.
   // For Bubble sort, the core action IS the swap.
   // Let's assume for now the user interaction that *results* in a swap
   // calls this method with the indices they effectively swapped.
   void recordSwapAction(int index1, int index2) {
        if (_isPaused || _isLoading) return;

        print("User action resulted in swap attempt: $index1 <-> $index2");
        final action = SwapStep(index1: index1, index2: index2);

        // 1. Check if correct
        _checkAndRecordAction(action);

        // 2. Update visual array (perform the swap visually)
        if (index1 >= 0 && index1 < _currentArray.length &&
            index2 >= 0 && index2 < _currentArray.length) {
            final temp = _currentArray[index1];
            _currentArray[index1] = _currentArray[index2];
            _currentArray[index2] = temp;
            notifyListeners(); // Update the array display
        }
   }


  // --- Scoring Logic ---
  void _checkAndRecordAction(SortingStep userAction) {
      if (_currentStepIndex < _correctSteps.length) {
          final correctStep = _correctSteps[_currentStepIndex];
          print("Checking Action: User=$userAction vs Correct=$correctStep");

          if (userAction == correctStep) {
              print("Correct Step!");
              _currentStepIndex++;
              // Calculate score - simple correct steps count for now
              _score = _currentStepIndex;
              // TODO: Implement percentage calculation later if needed
              // (Score: floor( (_currentStepIndex / _correctSteps.length) * 100 ) )

              // TODO: Add positive feedback (sound, animation)

              // Check for game completion
              if (_currentStepIndex == _correctSteps.length) {
                  print("Congratulations! Algorithm complete!");
                  // TODO: Show completion message/screen
                  _isPaused = true; // Pause game on completion?
              }
          } else {
              print("Incorrect Step!");
              // TODO: Add negative feedback (sound, animation)
              // Maybe reset the step? Or allow incorrect moves? Depends on game design.
              // Current implementation: Incorrect step doesn't advance index.
          }
          notifyListeners(); // Update score display etc.
      } else {
          print("Attempted action after algorithm completion.");
      }
  }

}