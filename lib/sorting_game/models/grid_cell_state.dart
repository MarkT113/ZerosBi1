// lib/models/grid_cell_state.dart
import 'package:flutter/foundation.dart';
import 'game_item.dart'; // We'll create this next

@immutable // Good practice for state models used with Provider
class GridCellState {
  final int row;
  final int column;
  final GameItem? gameItem; // Null if empty

  const GridCellState({
    required this.row,
    required this.column,
    this.gameItem,
  });

  // Helper to create a copy with updated item
  GridCellState copyWith({
    GameItem? gameItem, // Use ValueGetter to allow setting null explicitly
    bool removeGameItem = false,
  }) {
    return GridCellState(
      row: row,
      column: column,
      gameItem: removeGameItem ? null : (gameItem ?? this.gameItem),
    );
  }

  bool get isEmpty => gameItem == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridCellState &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column &&
          gameItem == other.gameItem;

  @override
  int get hashCode => row.hashCode ^ column.hashCode ^ gameItem.hashCode;
}