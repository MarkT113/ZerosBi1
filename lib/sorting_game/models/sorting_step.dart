// lib/models/sorting_step.dart
import 'package:flutter/foundation.dart';

// Define the types of actions the user needs to perform correctly
enum StepActionType {
  swap, // Represents swapping elements in the main array
  transfer, // Represents transferring from the 'List' tool to the main array
  // Add other types if needed (e.g., compare, though you said comparisons don't score)
}

// Base class for a step in the sorting algorithm solution
@immutable
abstract class SortingStep {
  final StepActionType actionType;
  const SortingStep({required this.actionType});

   @override
   bool operator ==(Object other); // Force implementation

   @override
   int get hashCode; // Force implementation
}

// Specific step: Swap elements at two indices in the main array
class SwapStep extends SortingStep {
  final int index1;
  final int index2;

  // Ensure indices are always stored in a consistent order (e.g., smaller first)
  // To make comparison easier regardless of which order the user performs it.
  SwapStep({required int index1, required int index2})
      : index1 = (index1 < index2) ? index1 : index2,
        index2 = (index1 < index2) ? index2 : index1,
        super(actionType: StepActionType.swap);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwapStep &&
          runtimeType == other.runtimeType &&
          actionType == other.actionType &&
          index1 == other.index1 &&
          index2 == other.index2;

  @override
  int get hashCode => actionType.hashCode ^ index1.hashCode ^ index2.hashCode;

  @override
  String toString() {
    return 'SwapStep(index1: $index1, index2: $index2)';
  }
}

// Specific step: Transfer elements from the 'List' tool to the main array
class TransferStep extends SortingStep {
  final int startIndex; // Starting index in the main array where the transfer occurs
  final List<int> transferredValues; // The values transferred (for verification)

  const TransferStep({required this.startIndex, required this.transferredValues})
      : super(actionType: StepActionType.transfer);

   @override
   bool operator ==(Object other) =>
       identical(this, other) ||
       other is TransferStep &&
           runtimeType == other.runtimeType &&
           actionType == other.actionType &&
           startIndex == other.startIndex &&
           listEquals(transferredValues, other.transferredValues); // Use listEquals

   @override
   int get hashCode =>
       actionType.hashCode ^ startIndex.hashCode ^ Object.hashAll(transferredValues);

   @override
   String toString() {
     return 'TransferStep(startIndex: $startIndex, values: $transferredValues)';
   }
}