// lib/widgets/tools_menu_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_item.dart';
import '../models/tool_type.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'game_item_widget.dart'; // Uses GameItemWidget for tools

class ToolsMenuWidget extends StatelessWidget {
  const ToolsMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isOpen = gameProvider.toolsMenuOpen;

    // Define the tools available in the menu
    // Exclude comparison operators - they are chosen via machine popup
    final List<ToolType> menuTools = [
      ToolType.conveyor,
      ToolType.machine,
      ToolType.basket,
      ToolType.swap,
      ToolType.keySlot,
      ToolType.listSlot,
    ];

    // Calculate position based on open/closed state
    final double rightPosition = isOpen ? 0 : -(kToolsMenuWidth); // Slide in from right

    return AnimatedPositioned(
      duration: kDefaultAnimDuration,
      curve: Curves.easeInOut,
      right: rightPosition,
      top: 0,
      bottom: 0, // Span full height
      child: Row(
        // Use Row to place handle next to menu content
        crossAxisAlignment: CrossAxisAlignment.center, // Center handle vertically
        children: [
          // 1. Menu Handle (Clickable Area to Toggle)
          GestureDetector(
            onTap: gameProvider.toggleToolsMenu,
            child: Container(
              width: kToolsMenuHandleWidth,
              height: kToolsMenuHandleWidth * 2.5, // Make handle taller
              decoration: BoxDecoration(
                color: kToolsMenuColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Colors.black38, offset: Offset(-1, 1))
                ],
              ),
              child: Icon(
                isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
                size: kToolsMenuHandleWidth * 0.6,
              ),
            ),
          ),
          // 2. Menu Content Area
          Container(
            width: kToolsMenuWidth,
            height: double.infinity, // Fill available height
            decoration: BoxDecoration(
                color: kToolsMenuColor.withOpacity(0.95), // Slightly transparent?
                boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black45)
                ],
            ),
            child: SingleChildScrollView( // Allow scrolling if many tools
               padding: const EdgeInsets.symmetric(vertical: 20.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start, // Align tools to top
                 children: menuTools.map((toolType) {
                    // Create a dummy GameItem just for menu representation & dragging
                    final menuItem = _createDummyItem(toolType);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0), // Spacing between tools
                      child: GameItemWidget(
                        item: menuItem,
                        size: kToolsMenuWidth * 0.6, // Adjust size of items in menu
                        isDraggable: true, // Items in menu are draggable
                      ),
                    );
                 }).toList(),
               ),
            ),
          ),
        ],
      ),
    );
  }

   // Helper to create non-functional GameItem instances for the menu
   GameItem _createDummyItem(ToolType type) {
     switch (type) {
       case ToolType.conveyor: return ConveyorItem();
       case ToolType.machine: return MachineItem();
       case ToolType.basket: return BasketItem();
       case ToolType.swap: return SwapItem();
       case ToolType.keySlot: return KeySlotItem();
       case ToolType.listSlot: return ListSlotItem();
       default: throw Exception("Unsupported tool type in menu: $type"); // Should not happen
     }
   }
}