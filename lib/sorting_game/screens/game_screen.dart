// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tool_type.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../widgets/array_display_widget.dart'; // Create next
import '../widgets/grid_widget.dart'; // Create next
import '../widgets/tools_menu_widget.dart'; // Create next
import '../widgets/pause_menu_widget.dart'; // Create next
import '../widgets/algorithm_name_pill_widget.dart'; // Create next
import '../widgets/machine_popup.dart'; // Create next
import '../widgets/list_popup.dart'; // Create next

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer or Selector for more granular rebuilds if performance becomes an issue
    final gameProvider = Provider.of<GameProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false, // Disables back button/gesture
      child: Scaffold(
        // Avoid Scaffold background if using a full background image/color in Stack
        backgroundColor: kBackgroundColor, // Use constant
        body: SafeArea( // Ensure content is within safe areas (notch, etc.)
          child: Stack(
            children: [
              // 1. Background (replace Container with Image.asset later)
              Container(
                color: kBackgroundColor, // Placeholder color
                // child: Image.asset('assets/images/game_background.png', fit: BoxFit.cover), // Example
              ),

              // 2. Main Game Content Area
              Column(
                children: [
                  // Top Bar Area (Score, Array)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          // Score Display (Example)
                          Consumer<GameProvider>(
                            builder: (context, provider, child) {
                              return Text(
                                  'Score: ${provider.score} / ${provider.totalSteps}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                              );
                            }
                          ),
                        // Placeholder for potential other info
                        const SizedBox(width: 50), // Space for Pause button overlap
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing
                  // Array Display
                  Consumer<GameProvider>(
                      builder: (context, provider, child) =>
                          ArrayDisplayWidget(numbers: provider.currentArray),
                  ),
                  const SizedBox(height: 20), // Spacing

                  // Game Grid (Takes remaining space)
                  const Expanded(
                    child: GridWidget(),
                  ),
                  const SizedBox(height: kToolsMenuHandleWidth * 1.5), // Space at bottom if menu closed
                ],
              ),

              // 3. Tools Menu (Animated Position)
              const ToolsMenuWidget(),

              // 4. Pause Button (Top Right)
              Positioned(
                top: 10, // Adjust as needed within SafeArea
                right: 10,
                child: IconButton(
                  icon: Icon(
                      gameProvider.isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.deepPurple.shade800, // Example color
                      size: 35.0),
                  onPressed: gameProvider.togglePause,
                ),
              ),

              // 5. Algorithm Name Pill (Animated)
              const AlgorithmNamePillWidget(),

              // --- Overlays ---

              // 6. Loading Indicator
              if (gameProvider.isLoading)
                const Center(child: CircularProgressIndicator()),

              // 7. Dimming Overlay (when popups are active or game is paused)
              if (gameProvider.showMachinePopup || gameProvider.showListPopup || gameProvider.isPaused)
                GestureDetector(
                  onTap: () {
                      // Close popups when tapping dimmed area (if game not paused)
                      if (!gameProvider.isPaused) {
                          // Call the dedicated closing methods
                          if (gameProvider.showMachinePopup) gameProvider.closeMachineConfig();
                          if (gameProvider.showListPopup) gameProvider.closeListConfig();
                      }
                  },
                  child: Container(
                    color: kPopupOverlayColor,
                  ),
                ),

              // 8. Machine Configuration Popup
              if (gameProvider.showMachinePopup)
                const Center(child: MachinePopup()), // Wrap in Center or Positioned

              // 9. List Transfer Popup
              if (gameProvider.showListPopup)
                const Center(child: ListPopup()), // Wrap in Center or Positioned

              // 10. Pause Menu
              if (gameProvider.isPaused && !gameProvider.isLoading)
                const Center(child: PauseMenuWidget()),

              // 11. Dragged Item Visual (Follows finger/cursor)
              Consumer<GameProvider>(
                  builder: (context, provider, child) {
                      if (provider.draggedItem != null && provider.dragPosition != null) {
                        // Calculate cell size to render dragged item appropriately
                        // This is tricky - need grid dimensions available here.
                        // Simplification: Render fixed size placeholder for now.
                        final double draggedItemSize = screenSize.width / (kGridColumns + 2); // Estimate

                        return Positioned(
                            left: provider.dragPosition!.dx - draggedItemSize / 2, // Center on cursor
                            top: provider.dragPosition!.dy - draggedItemSize / 2, // Center on cursor
                            child: IgnorePointer( // Prevent dragged item from interfering with drop targets
                              child: Opacity( // Make it slightly transparent maybe
                                  opacity: 0.7,
                                  // Use GameItemWidget directly? Or a simpler representation?
                                  // For now, simple placeholder
                                  child: Container(
                                      width: draggedItemSize,
                                      height: draggedItemSize,
                                      color: kItemPlaceholderColor.withOpacity(0.8),
                                      child: Icon(_getIconForTool(provider.draggedItem!.type), color: Colors.white),
                                  ),
                              ),
                            ),
                        );
                      } else {
                        return const SizedBox.shrink(); // Nothing being dragged
                      }
                  }
              ),
            ],
          ),
        ),
      )
    );
  }
    // Helper to get icon for tool type (used in dragged item visual and elsewhere)
    IconData _getIconForTool(ToolType type) {
        switch (type) {
            case ToolType.conveyor: return Icons.linear_scale; // Example
            case ToolType.machine: return Icons.build_circle; // Example
            case ToolType.basket: return Icons.shopping_basket; // Example
            case ToolType.swap: return Icons.swap_horiz; // Example
            case ToolType.keySlot: return Icons.vpn_key; // Example
            case ToolType.listSlot: return Icons.list_alt; // Example
            case ToolType.comparisonOperator: return Icons.compare_arrows; // Example
        }
    }
}