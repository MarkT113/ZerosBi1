// lib/utils/constants.dart
import 'package:flutter/material.dart';

// Grid dimensions
const int kGridColumns = 6;
const int kGridRows = 10; // Adjust as needed based on screen space

// Visuals / Placeholders
const Color kBackgroundColor = Color(0xFFECECEC); // Placeholder background
const Color kGridCellColor = Colors.transparent; // Invisible grid
const Color kDragTargetHighlightColor = Color(0x3390EE90); // Pale green highlight
const Color kItemPlaceholderColor = Colors.blueGrey;
const Color kToolsMenuColor = Color(0xFFF44336); // Reddish-orange from image
const Color kPopupOverlayColor = Color(0xAA000000); // Semi-transparent black
const Color kPopupBackgroundColor = Colors.white;
const Color kAlgorithmPillColor = Colors.white;
const Color kDeleteButtonColor = Colors.white;
const Color kDeleteIconColor = Colors.black;
const Color kActionButtonColor = Colors.white; // For machine/list action buttons
const Color kActionIconColor = Colors.black;

// Animations
const Duration kDefaultAnimDuration = Duration(milliseconds: 200);
const Duration kAlgorithmPillDuration = Duration(seconds: 3);
const Duration kItemRemoveAnimDuration = Duration(milliseconds: 300);

// Tools Menu
const double kToolsMenuWidth = 100.0; // Adjust based on content
const double kToolsMenuHandleWidth = 25.0;

// Game Logic
const int kInitialArraySize = 7; // Like the first image example
const int kMaxRandomNumber = 100; // Max value for random numbers in array