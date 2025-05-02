// lib/widgets/grid_cell_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grid_cell_state.dart';
import '../models/game_item.dart';
import '../models/tool_type.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'game_item_widget.dart'; // Create next

class GridCellWidget extends StatefulWidget {
  final GridCellState cellState;
  final double cellSize;

  const GridCellWidget({
    super.key,
    required this.cellState,
    required this.cellSize,
  });

  @override
  State<GridCellWidget> createState() => _GridCellWidgetState();
}

class _GridCellWidgetState extends State<GridCellWidget> {
  bool _isHovering = false; // Track if a draggable is hovering over

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false); // Don't need to listen for all changes here
    final bool isPotentialTarget = context.select((GameProvider gp) => gp.draggedItem != null); // Only highlight if dragging
    final bool showContextMenu = context.select((GameProvider gp) =>
        gp.tappedCellForContextMenu?.row == widget.cellState.row &&
        gp.tappedCellForContextMenu?.column == widget.cellState.column);


    return GestureDetector(
       onTap: () {
           if (!gameProvider.isPaused) { // Prevent interaction when paused
              gameProvider.handleCellTap(widget.cellState.row, widget.cellState.column);
           }
       },
       child: DragTarget<GameItem>(
         builder: (context, candidateData, rejectedData) {
           return Container(
             width: widget.cellSize,
             height: widget.cellSize,
             decoration: BoxDecoration(
               color: _isHovering ? kDragTargetHighlightColor : kGridCellColor, // Highlight on hover
               border: Border.all( // Optional: Subtle border for debugging grid
                 color: Colors.grey.withOpacity(0.1),
                 width: 0.5,
               ),
             ),
             // Use stack to potentially overlay context buttons even if cell is empty (though unlikely needed)
             child: Stack(
                 clipBehavior: Clip.none, // Allow buttons to overflow slightly
                 alignment: Alignment.center,
                 children: [
                    // Display the game item if it exists
                    if (widget.cellState.gameItem != null)
                      GameItemWidget(
                         item: widget.cellState.gameItem!,
                         size: widget.cellSize * 0.85, // Slightly smaller than cell
                         showContextButtons: showContextMenu, // Pass down flag
                      ),

                    // Show pale green dots when dragging *starts* (simplification)
                    // More complex: show only if item *can* be placed here.
                    if (isPotentialTarget && widget.cellState.isEmpty)
                      Center(
                        child: Container(
                          width: widget.cellSize * 0.15,
                          height: widget.cellSize * 0.15,
                          decoration: BoxDecoration(
                            color: kDragTargetHighlightColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                 ]
             ),
           );
         },
         onWillAcceptWithDetails: (details) {
           // Check if the drop is allowed (e.g., not dropping operator directly)
           if (details.data.type == ToolType.comparisonOperator) {
               return false; // Operators only go in machine popup
           }
           setState(() { _isHovering = true; });
           return true; // Accept the drop visually
         },
         onAcceptWithDetails: (details) {
           if (!gameProvider.isPaused) {
              gameProvider.handleDrop(widget.cellState.row, widget.cellState.column, details.data);
              setState(() { _isHovering = false; });
           }
         },
         onLeave: (data) {
           setState(() { _isHovering = false; });
         },
       ),
    );
  }
}