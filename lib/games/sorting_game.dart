import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Game (Flutter)',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SortingGameScreen(),
    );
  }
}

class SortingGameScreen extends StatefulWidget {
  const SortingGameScreen({super.key});

  @override
  State<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen> {
  static const int gridColumns = 6;
  static const int gridRows = 8;
  List<int> initialNumbers = [5, 10, 1, 3, 12, 97, 0];
  final Map<Offset, String> gridOccupants = {}; // Track tool at each grid cell
  final List<Tool> tools = [
    Tool(label: 'M', color: Colors.grey),
    Tool(label: 'B', color: Colors.green),
    Tool(label: 'S', color: Colors.orange),
    Tool(label: 'K', color: Colors.purple),
    Tool(label: 'L', color: Colors.brown),
  ];
  final List<String> operators = ['>', '<', '>=', '<=', '=', '!='];
  String? _draggedToolData;
  Offset _dragPosition = Offset.zero;

  void _handleToolDrop(Offset gridPosition, String toolLabel) {
    setState(() {
      if (!gridOccupants.containsKey(gridPosition)) {
        gridOccupants[gridPosition] = toolLabel;
      }
    });
    debugPrint('Dropped $toolLabel at $gridPosition');
  }

  Widget _buildDraggableTool(Tool tool, double size) {
    return Draggable<String>(
      data: tool.label,
      feedback: _buildTool(tool.label, tool.color, size),
      childWhenDragging: SizedBox(width: size, height: size),
      child: _buildTool(tool.label, tool.color, size),
      onDragStarted: () {
        setState(() {
          _draggedToolData = tool.label;
        });
      },
      onDragUpdate: (details) {
        setState(() {
          _dragPosition = details.globalPosition;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _draggedToolData = null;
        });
      },
    );
  }

  Widget _buildTool(String label, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStaticOperator(String label, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gridAreaHeight = screenHeight * 0.75;
    const toolSize = 50.0;
    const spacing = 10.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Game (Flutter)'),
        actions: [
          IconButton(icon: const Icon(Icons.pause), onPressed: () {
            debugPrint('Pause button tapped (Flutter)');
            // Implement pause menu navigation or logic here
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Initial List: ${initialNumbers.join(', ')}', style: const TextStyle(fontSize: 18)),
          ),
          SizedBox(
            height: gridAreaHeight,
            width: screenWidth,
            child: Stack(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    childAspectRatio: screenWidth / gridColumns / (gridAreaHeight / gridRows),
                  ),
                  itemCount: gridColumns * gridRows,
                  itemBuilder: (context, index) {
                    final row = index ~/ gridColumns;
                    final col = index % gridColumns;
                    final gridPosition = Offset(col.toDouble(), row.toDouble());
                    return DragTarget<String>(
                      onAccept: (toolLabel) {
                        _handleToolDrop(gridPosition, toolLabel);
                      },
                      builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
                        final occupant = gridOccupants[gridPosition];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: occupant != null
                              ? _buildTool(occupant, tools.firstWhere((t) => t.label == occupant).color, toolSize)
                              : null,
                        );
                      },
                    );
                  },
                ),
                if (_draggedToolData != null)
                  Positioned(
                    left: _dragPosition.dx - toolSize / 2,
                    top: _dragPosition.dy - toolSize / 2,
                    child: _buildTool(_draggedToolData!, tools.firstWhere((t) => t.label == _draggedToolData!).color, toolSize),
                  ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.25,
            color: Colors.red.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...tools.map((tool) => _buildDraggableTool(tool, toolSize)),
                  Wrap(
                    spacing: spacing,
                    children: operators.map((op) => _buildStaticOperator(op, Colors.blueAccent, 30)).toList(),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Algorithm: Bubble Sort', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class Tool {
  final String label;
  final Color color;

  Tool({required this.label, required this.color});
}