// lib/widgets/game_item_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_item.dart';
import '../models/tool_type.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';


class GameItemWidget extends StatelessWidget {
  final GameItem item;
  final double size;
  final bool isDraggable; // Can this instance be dragged? (e.g., from menu, from grid)
  final bool showContextButtons; // Should delete/action buttons be shown?

  const GameItemWidget({
    super.key,
    required this.item,
    required this.size,
    this.isDraggable = true, // Default to true, set false for non-draggable copies (like in popups?)
    this.showContextButtons = false,
  });

  // Helper to get a representative icon (replace with actual images later)
  IconData _getIconForTool(ToolType type) {
    switch (type) {
      case ToolType.conveyor: return Icons.linear_scale;
      case ToolType.machine: return Icons.build_circle_outlined; // Use outlined version
      case ToolType.basket: return Icons.shopping_basket_outlined;
      case ToolType.swap: return Icons.swap_horiz;
      case ToolType.keySlot: return Icons.vpn_key_outlined;
      case ToolType.listSlot: return Icons.list_alt_outlined;
      case ToolType.comparisonOperator:
        // Specific icons for operators if needed when displayed
        if (item is ComparisonOperatorItem) {
           switch((item as ComparisonOperatorItem).operatorType) {
               case ComparisonOperator.greater: return Icons.chevron_right; // Placeholder icons
               case ComparisonOperator.less: return Icons.chevron_left;
               case ComparisonOperator.greaterEqual: return Icons.maximize; // Placeholder
               case ComparisonOperator.lessEqual: return Icons.minimize; // Placeholder
               case ComparisonOperator.equal: return Icons.drag_handle; // Placeholder
               case ComparisonOperator.notEqual: return Icons.code_off; // Placeholder
           }
        }
        return Icons.compare_arrows; // Default
    }
  }

  // Helper to get placeholder color
  Color _getColorForTool(ToolType type) {
     switch (type) {
      case ToolType.conveyor: return Colors.grey;
      case ToolType.machine: return Colors.blueGrey;
      case ToolType.basket: return Colors.orange.shade300;
      case ToolType.swap: return Colors.purple.shade300;
      case ToolType.keySlot: return Colors.yellow.shade600;
      case ToolType.listSlot: return Colors.green.shade300;
      case ToolType.comparisonOperator: return Colors.red.shade300;
    }
  }


  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    Widget content = Container(
       width: size,
       height: size,
       decoration: BoxDecoration(
           color: _getColorForTool(item.type),
           borderRadius: BorderRadius.circular(size * 0.1), // Slightly rounded corners
           border: Border.all(color: Colors.black54, width: 1.0),
           boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(1, 2), // changes position of shadow
                ),
            ],
       ),
       child: Icon(
           _getIconForTool(item.type),
           color: Colors.white,
           size: size * 0.6, // Adjust icon size
       ),
    );

    // Wrap content in Draggable if needed
    Widget draggableContent = isDraggable
        ? Draggable<GameItem>(
            data: item, // The data being dragged
            feedback: content, // How it looks while dragging
            childWhenDragging: Container( // How the original spot looks
               width: size,
               height: size,
               decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2), // Faded out
                  borderRadius: BorderRadius.circular(size * 0.1),
               ),
            ),
            onDragStarted: () {
                gameProvider.startDrag(item);
            },
            onDragEnd: (details) {
               // Note: onDragEnd is called regardless of whether it was dropped
               // on a target or cancelled. Drop logic is in DragTarget.
               gameProvider.endDrag();
            },
            onDraggableCanceled: (velocity, offset) {
                // Also need to end drag if cancelled
                gameProvider.endDrag();
            },
             onDragUpdate: (details) {
                // Update provider with global position for visual feedback rendering
                gameProvider.updateDragPosition(details.globalPosition);
             },
            child: content, // The widget visible before dragging starts
          )
        : content; // Just the content if not draggable


     // Wrap draggable content in Stack to potentially add buttons
     return Stack(
         clipBehavior: Clip.none, // Allow buttons to overflow
         alignment: Alignment.center,
         children: [
             draggableContent,

             // --- Context Buttons (Delete/Action) ---
             if (showContextButtons) ...[
                 // Delete Button (Top Right)
                 Positioned(
                    top: -size * 0.15, // Position above the item
                    right: -size * 0.15,
                    child: GestureDetector(
                       onTap: () {
                           // Find cell state from provider (needed row/col)
                           // This is slightly inefficient - ideally GameItemWidget is created
                           // within GridCellWidget which already knows row/col.
                           // For now, rely on tappedCellForContextMenu in provider.
                           final tappedCell = gameProvider.tappedCellForContextMenu;
                           if (tappedCell != null) {
                               gameProvider.requestItemRemoval(tappedCell.row, tappedCell.column);
                           }
                       },
                       child: Container(
                           padding: const EdgeInsets.all(2),
                           decoration: const BoxDecoration(
                               color: kDeleteButtonColor,
                               shape: BoxShape.circle,
                               boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)]
                           ),
                           child: Icon(
                               Icons.close,
                               size: size * 0.3, // Adjust button size
                               color: kDeleteIconColor,
                           ),
                       ),
                    ),
                 ),

                 // Action Button (Top Left - only for specific tools)
                 if (item.type == ToolType.machine || item.type == ToolType.listSlot)
                    Positioned(
                        top: -size * 0.15,
                        left: -size * 0.15,
                        child: GestureDetector(
                            onTap: () {
                                final tappedCell = gameProvider.tappedCellForContextMenu;
                                if (tappedCell != null) {
                                    if (item.type == ToolType.machine) {
                                        gameProvider.requestMachineConfig(tappedCell.row, tappedCell.column);
                                    } else if (item.type == ToolType.listSlot) {
                                        gameProvider.requestListConfig(tappedCell.row, tappedCell.column);
                                    }
                                }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    color: kActionButtonColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)]
                                ),
                                child: Icon(
                                   // Use different icons based on tool
                                   item.type == ToolType.machine ? Icons.settings_ethernet : Icons.checklist, // Example icons
                                   size: size * 0.3,
                                   color: kActionIconColor,
                                ),
                            ),
                        ),
                    ),
             ],
         ],
     );
  }
}