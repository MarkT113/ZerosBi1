import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../widgets/lesson/objectives_section.dart';
import '../../widgets/lesson/info_box.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Objectives Section
              if (lesson.objectives.isNotEmpty)
                ObjectivesSection(objectives: lesson.objectives),

              // Lesson Content
              Text(
                lesson.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Interactive Elements
              if (lesson.interactiveElements.isNotEmpty) ...[
                const Text(
                  'Interactive Elements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...lesson.interactiveElements.map((element) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildInteractiveElement(element),
                  );
                }),
              ],

              // Complete Lesson Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Mark lesson as complete
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Complete Lesson',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveElement(InteractiveElement element) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getInteractiveElementIcon(element.type),
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                element.type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            element.description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              onPressed: () {
                // Launch interactive element
              },
              child: const Text('Launch Interactive Element'),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getInteractiveElementIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle_outline;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'exercise':
        return Icons.code;
      case 'simulation':
        return Icons.animation;
      default:
        return Icons.extension;
    }
  }
} 