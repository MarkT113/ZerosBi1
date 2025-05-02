// lib/widgets/list_popup.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class ListPopup extends StatefulWidget {
  const ListPopup({super.key});

  @override
  State<ListPopup> createState() => _ListPopupState();
}

class _ListPopupState extends State<ListPopup> {
  final TextEditingController _indexController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For validation
  int? _selectedStartIndex;

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    // Calculate max valid start index (needs list length from provider)
    // TODO: Get list length from the ListSlotItem being configured later.
    // Using currentArray length for now as an upper bound guess.
    final arrayLength = context.select((GameProvider gp) => gp.currentArray.length);
    // final listSlotItemLength = 3; // Placeholder length of list in ListSlot
    // final maxIndex = arrayLength - listSlotItemLength; // Calculate actual max index
    final maxIndex = arrayLength - 1; // Simplified max index for now

    return Material(
        color: Colors.transparent,
        child: Center(
           child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                 color: kPopupBackgroundColor,
                 borderRadius: BorderRadius.circular(15),
                 boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black38)],
              ),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          "Transfer to Array",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text("Select start index in main array:"),
                      const SizedBox(height: 10),
                      // --- Placeholder for iOS scroll wheel ---
                      // Using a simple text field for now
                      TextFormField(
                         controller: _indexController,
                         keyboardType: TextInputType.number,
                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                         decoration: InputDecoration(
                            labelText: "Start Index (0 to $maxIndex)",
                            border: const OutlineInputBorder(),
                            hintText: "e.g., 0",
                         ),
                         validator: (value) {
                            if (value == null || value.isEmpty) {
                               return 'Please enter an index';
                            }
                            final index = int.tryParse(value);
                            if (index == null) {
                               return 'Invalid number';
                            }
                            // TODO: Add validation based on list length in ListSlot
                            if (index < 0 || index > maxIndex) {
                               return 'Index out of range (0-$maxIndex)';
                            }
                            _selectedStartIndex = index; // Store valid index
                            return null;
                         },
                      ),
                      // --- End Placeholder ---
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                         icon: const Icon(Icons.send),
                         label: const Text("Execute Transfer"),
                         style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 45),
                            textStyle: const TextStyle(fontSize: 16),
                         ),
                         onPressed: () {
                           if (_formKey.currentState!.validate()) {
                              // Validation passed, _selectedStartIndex is set
                              if (_selectedStartIndex != null) {
                                 gameProvider.executeListTransfer(_selectedStartIndex!);
                              }
                           }
                         },
                      ),
                       const SizedBox(height: 10),
                    ],
                  ),
              ),
           ),
        ),
    );
  }
}