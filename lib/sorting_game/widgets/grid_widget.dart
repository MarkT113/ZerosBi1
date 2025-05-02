// lib/widgets/grid_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'grid_cell_widget.dart'; // Create next

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get constraints and calculate cell size
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;

        // Calculate cell size based on width first, maintaining square aspect ratio
        double cellSize = maxWidth / kGridColumns;

        // Check if calculated rows fit within height
        final double totalGridHeight = cellSize * kGridRows;
        if (totalGridHeight > maxHeight) {
          // If grid height exceeds available space, recalculate based on height
          cellSize = maxHeight / kGridRows;
        }

        // Center the grid if it doesn't fill the whole space
        final double horizontalPadding = (maxWidth - (cellSize * kGridColumns)) / 2;
        final double verticalPadding = (maxHeight - (cellSize * kGridRows)) / 2;


        // Consumer needed here to access gridState
        return Consumer<GameProvider>(
           builder: (context, gameProvider, child) {
              final gridState = gameProvider.gridState;
              if (gridState.isEmpty) {
                 return const Center(child: Text("Initializing Grid...")); // Or SizedBox.shrink()
              }

              return Padding(
                // Add padding to center the grid visually
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding > 0 ? horizontalPadding : 0,
                    vertical: verticalPadding > 0 ? verticalPadding : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center rows vertically
                  children: List.generate(kGridRows, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center cells horizontally
                      children: List.generate(kGridColumns, (col) {
                        return GridCellWidget(
                          cellState: gridState[row][col],
                          cellSize: cellSize,
                        );
                      }),
                    );
                  }),
                ),
              );
           }
        );
      },
    );
  }
}