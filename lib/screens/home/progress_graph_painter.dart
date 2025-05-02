import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'daily_progress.dart';
import 'dart:ui' as ui;
class ProgressGraphPainter extends CustomPainter {
  final List<DailyProgress> data;
  final int maxDataPoints;
  final int maxYAxisLabels;

  ProgressGraphPainter({
    required this.data,
    required this.maxDataPoints,
    required this.maxYAxisLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final dotPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.withOpacity(0.1);

    // Calculate padding for labels
    const double leftPadding = 50.0;
    const double bottomPadding = 40.0;
    const double topPadding = 20.0;
    const double rightPadding = 20.0;

    // Calculate graph area
    final graphWidth = size.width - leftPadding - rightPadding;
    final graphHeight = size.height - topPadding - bottomPadding;

    // Draw axes
    paint.color = Colors.black;
    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width - rightPadding, size.height - bottomPadding),
      paint,
    );
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, size.height - bottomPadding),
      paint,
    );

    // Calculate data points to display
    final displayData = _getDisplayData();
    if (displayData.isEmpty) return;

    // Calculate scales
    final maxY = displayData.map((e) => e.lessonsCompleted).reduce(max);
    final minY = displayData.map((e) => e.lessonsCompleted).reduce(min);
    final yRange = (maxY - minY).toDouble();
    final yScale = graphHeight / (yRange > 0 ? yRange : 1);

    // Draw Y-axis labels
    final yLabelCount = min(maxYAxisLabels, yRange.ceil() + 1);
    final yIncrement = yRange / (yLabelCount - 1);
    for (var i = 0; i < yLabelCount; i++) {
      final y = minY + (yIncrement * i);
      final yPos = size.height - bottomPadding - ((y - minY) * yScale);
      
      // Draw horizontal grid line
      final gridPaint = Paint()
        ..color = Colors.grey.withOpacity(0.2)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(leftPadding, yPos),
        Offset(size.width - rightPadding, yPos),
        gridPaint,
      );
      
      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: y.round().toString(),
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 8, yPos - textPainter.height / 2),
      );
    }

    // Draw X-axis labels and data points
    final xStep = graphWidth / (displayData.length - 1);
    final points = <Offset>[];
    
    for (var i = 0; i < displayData.length; i++) {
      final item = displayData[i];
      final x = leftPadding + (i * xStep);
      final y = size.height - bottomPadding - ((item.lessonsCompleted - minY) * yScale);
      points.add(Offset(x, y));

      // Draw X-axis label
      if (i % ((displayData.length / min(maxDataPoints, displayData.length)).ceil()) == 0) {
        final label = _formatDate(item.date, displayData.length > 7);
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          textDirection: ui.TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - bottomPadding + 8),
        );
      }
    }

    // Draw the line connecting points
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) / 2,
        current.dy,
      );
      final controlPoint2 = Offset(
        current.dx + (next.dx - current.dx) / 2,
        next.dy,
      );
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        next.dx, next.dy,
      );
    }

    // Draw fill
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height - bottomPadding)
      ..lineTo(points.first.dx, size.height - bottomPadding)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    paint.color = Colors.green;
    canvas.drawPath(path, paint);

    // Draw points
    const double pointRadius = 4.0;
    for (final point in points) {
      canvas.drawCircle(point, pointRadius, dotPaint..style = PaintingStyle.stroke);
      canvas.drawCircle(point, pointRadius - 1, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  List<DailyProgress> _getDisplayData() {
    if (data.length <= maxDataPoints) return data;
    
    final step = (data.length / maxDataPoints).ceil();
    return data.asMap().entries
        .where((entry) => entry.key % step == 0)
        .map((entry) => entry.value)
        .take(maxDataPoints)
        .toList();
  }

  String _formatDate(DateTime date, bool isLongRange) {
    if (isLongRange) {
      // For ranges > 7 days, show first day of week
      if (date.weekday == DateTime.monday) {
        return DateFormat('dd/MM').format(date);
      }
      return '';
    } else {
      // For ranges <= 7 days, show abbreviated day name
      return DateFormat('E').format(date);
    }
  }
} 