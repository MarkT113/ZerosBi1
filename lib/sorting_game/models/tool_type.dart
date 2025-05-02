// lib/models/tool_type.dart
enum ToolType {
  conveyor,
  machine,
  basket,
  swap,
  keySlot, // Placeholder for 'Key' tool
  listSlot, // Placeholder for 'List' tool
  comparisonOperator, // Special type for operators inside the machine
}

enum ComparisonOperator {
  greater, // >
  less, // <
  greaterEqual, // >=
  lessEqual, // <=
  equal, // ==
  notEqual, // !=
}