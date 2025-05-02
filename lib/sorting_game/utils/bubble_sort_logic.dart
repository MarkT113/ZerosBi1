// lib/utils/bubble_sort_logic.dart
import '../models/sorting_step.dart';

// Performs bubble sort and returns the list of required swap steps.
List<SortingStep> generateBubbleSortSteps(List<int> initialList) {
  List<int> arr = List.from(initialList); // Make a mutable copy
  List<SortingStep> steps = [];
  int n = arr.length;
  bool swapped;

  print("Generating Bubble Sort Steps for: $arr");

  for (int i = 0; i < n - 1; i++) {
    swapped = false;
    for (int j = 0; j < n - i - 1; j++) {
      // The core comparison (doesn't count as a step per user rules)
      if (arr[j] > arr[j + 1]) {
        // Record the swap step *before* performing it on the temp array
        steps.add(SwapStep(index1: j, index2: j + 1));

        // Perform the swap on the temporary array to continue the algorithm correctly
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;

        print("Step ${steps.length}: Swap indices $j and ${j + 1} -> Array becomes $arr");
      }
    }
    // If no two elements were swapped by inner loop, then break
    if (swapped == false) break;
  }

  print("Generated ${steps.length} steps.");
  return steps;
}