import 'package:flutter/foundation.dart';

@immutable
class ArrayElementData {
  final int value;
  final int originalIndex;

  const ArrayElementData({required this.value, required this.originalIndex});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrayElementData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          originalIndex == other.originalIndex;

  @override
  int get hashCode => value.hashCode ^ originalIndex.hashCode;
}