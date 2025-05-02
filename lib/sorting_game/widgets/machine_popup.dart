// lib/widgets/machine_popup.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/tool_type.dart'; // For ComparisonOperator enum
import '../utils/constants.dart';

class MachinePopup extends StatelessWidget {
  const MachinePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    // Get the list of operators
    final operators = ComparisonOperator.values;

    return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
             width: MediaQuery.of(context).size.width * 0.7, // Adjust size
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: kPopupBackgroundColor,
               borderRadius: BorderRadius.circular(15),
               boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black38)],
             ),
             child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Text(
                      "Select Comparison",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 20),
                   // Display operators (use Wrap for responsiveness)
                   Wrap(
                      spacing: 15.0, // Horizontal space
                      runSpacing: 15.0, // Vertical space
                      alignment: WrapAlignment.center,
                      children: operators.map((op) {
                         return ElevatedButton(
                            onPressed: () {
                               gameProvider.selectMachineOperator(op);
                            },
                            // Use text representation for now
                            child: Text(
                               _operatorToString(op),
                               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                // minimumSize: Size(60, 40),
                            ),
                         );
                      }).toList(),
                   ),
                   const SizedBox(height: 10), // Add some padding at bottom
                ],
             ),
          ),
        ),
    );
  }

   // Helper to get text for operator
   String _operatorToString(ComparisonOperator op) {
     switch (op) {
       case ComparisonOperator.greater: return ">";
       case ComparisonOperator.less: return "<";
       case ComparisonOperator.greaterEqual: return ">=";
       case ComparisonOperator.lessEqual: return "<=";
       case ComparisonOperator.equal: return "==";
       case ComparisonOperator.notEqual: return "!=";
     }
   }
}