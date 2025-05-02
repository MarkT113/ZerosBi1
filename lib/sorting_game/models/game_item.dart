// lib/models/game_item.dart
import 'package:flutter/foundation.dart';
import 'tool_type.dart';

// Base class for any item that can be placed on the grid or in the menu
@immutable
abstract class GameItem {
  final String id; // Unique ID for each instance
  final ToolType type;

  // Optional: position if placed on grid (could also be managed solely by GridCellState)
  // final int? row;
  // final int? column;

  GameItem({required this.type}) : id = UniqueKey().toString(); // Simple unique ID

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Abstract method or specific properties can be added later
  // e.g., Widget buildWidget();
}

// --- Specific Item Implementations ---

// Example: Machine Item
class MachineItem extends GameItem {
  final ComparisonOperator? selectedOperator;

  MachineItem({this.selectedOperator}) : super(type: ToolType.machine);

  MachineItem copyWith({ComparisonOperator? selectedOperator}) {
    return MachineItem(selectedOperator: selectedOperator ?? this.selectedOperator);
  }
   // Note: Equality should probably check selectedOperator too if mutable state is managed here
   // But with Provider, we often rebuild the state object, so immutable is better.
}

// Example: Basket Item
class BasketItem extends GameItem {
   final bool isOutputBin; // Determines behavior
   final int? heldValue; // Value from array or machine output

   BasketItem({this.isOutputBin = false, this.heldValue}) : super(type: ToolType.basket);

   BasketItem copyWith({bool? isOutputBin, int? heldValue, bool removeHeldValue = false}) {
     return BasketItem(
       isOutputBin: isOutputBin ?? this.isOutputBin,
       heldValue: removeHeldValue ? null : (heldValue ?? this.heldValue),
     );
   }
}

// Add other item classes similarly:
class ConveyorItem extends GameItem {
  ConveyorItem() : super(type: ToolType.conveyor);
}

class SwapItem extends GameItem {
  SwapItem() : super(type: ToolType.swap);
}

class KeySlotItem extends GameItem {
  KeySlotItem() : super(type: ToolType.keySlot);
  // Potentially add a 'heldKeyValue' property later
}

class ListSlotItem extends GameItem {
  ListSlotItem() : super(type: ToolType.listSlot);
  // Potentially add a 'heldList' property later
}

// This might not be placed directly on the grid, but represents the tool
class ComparisonOperatorItem extends GameItem {
  final ComparisonOperator operatorType;
  ComparisonOperatorItem({required this.operatorType}) : super(type: ToolType.comparisonOperator);
}