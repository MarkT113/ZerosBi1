// lib/widgets/array_display_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Need provider for drag actions
import '../providers/game_provider.dart'; // Need provider
import '../models/array_element_data.dart'; // Create this model next

class ArrayDisplayWidget extends StatelessWidget {
  final List<int> numbers;

  const ArrayDisplayWidget({super.key, required this.numbers});

  @override
  Widget build(BuildContext context) {
    // Calculate available width for the boxes, considering padding
    final double availableWidth = MediaQuery.of(context).size.width - 16.0; // Subtract horizontal padding (8.0 * 2)
    final int numItems = numbers.isNotEmpty ? numbers.length : 1; // Avoid division by zero

    // Calculate ideal box size based on width, add spacing between boxes
    const double spacing = 8.0;
    double boxSize = (availableWidth - (spacing * (numItems - 1))) / numItems;

    // Add constraints - e.g., max size, min size
    boxSize = boxSize.clamp(35.0, 60.0); // Clamp size to be reasonable

    final double totalWidth = (boxSize * numItems) + (spacing * (numItems - 1));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: boxSize + 10, // Add vertical padding
      width: double.infinity, // Take full width
      child: Center( // Center the Row itself
        child: SizedBox(
          width: totalWidth, // Constrain row width if needed, helps centering
          child: Row(
             mainAxisAlignment: MainAxisAlignment.center, // Distribute space if boxes are smaller than availableWidth
             // mainAxisAlignment: MainAxisAlignment.start, // Or align left
              children: List.generate(numbers.length, (index) {
                final number = numbers[index];
                final elementData = ArrayElementData(value: number, originalIndex: index);

                // Create the visual box widget
                 final boxWidget = Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      border: Border.all(color: Colors.brown[600]!, width: 2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                 );

                // Make the box draggable
                return Padding(
                  // Add spacing between items using Padding instead of Margin inside Draggable
                  padding: EdgeInsets.only(left: index == 0 ? 0 : spacing),
                  child: Draggable<ArrayElementData>(
                    data: elementData,
                    feedback: Material( // Wrap feedback in Material for text style
                      child: Opacity(opacity: 0.7, child: boxWidget),
                      color: Colors.transparent,
                    ),
                    childWhenDragging: Opacity( // How original spot looks
                        opacity: 0.3,
                        child: boxWidget,
                    ),
                    onDragStarted: () {
                      // Optionally notify provider if needed
                      // Provider.of<GameProvider>(context, listen: false).startArrayElementDrag(elementData);
                    },
                    onDragEnd: (details) {
                      // Optionally notify provider
                      // Provider.of<GameProvider>(context, listen: false).endArrayElementDrag();
                    },
                    child: boxWidget, // The actual box
                  ),
                );
              }),
            ),
        ),
      ),
    );
  }
}