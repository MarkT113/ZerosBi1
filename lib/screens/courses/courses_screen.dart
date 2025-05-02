import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../data/courses_data.dart';
import 'lesson_screen.dart';
import 'package:provider/provider.dart';
import '../../sorting_game/screens/game_screen.dart';
import '../../sorting_game/providers/game_provider.dart';
import '../../condition_catcher_game/screens/condition_catcher_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            // Course List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: coursesData.length,
                itemBuilder: (context, index) {
                  final course = coursesData[index];
                  return CourseCard(course: course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseTopicsScreen(course: course),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: course.primaryColor.withOpacity(0.1),
                child: Icon(
                  _getCourseIcon(course.id),
                  size: 48,
                  color: course.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(course.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(course.progress * 100).toInt()}% Complete',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCourseIcon(String courseId) {
    switch (courseId) {
      case 'prog101':
        return Icons.code;
      case 'dsa101':
        return Icons.account_tree;
      case 'web101':
        return Icons.web;
      case 'ml101':
        return Icons.psychology;
      case 'mobile101':
        return Icons.phone_android;
      default:
        return Icons.school;
    }
  }
}

class CourseTopicsScreen extends StatelessWidget {
  final Course course;

  const CourseTopicsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    // Check which course this is to conditionally add buttons
    final bool isDsaCourse = course.id == 'dsa101';
    final bool isProgCourse = course.id == 'prog101';

    // Determine how many extra items (buttons) to add
    final int extraItems = (isDsaCourse ? 1 : 0) + (isProgCourse ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          // Use Column if adding items below ListView
          children: [
            Expanded(
              // Make ListView take available space
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: course.topics.length +
                    extraItems, // Add space for button(s)
                itemBuilder: (context, index) {
                  // Check if the index is beyond the topics count
                  if (index >= course.topics.length) {
                    // --- Build the Game Buttons ---
                    // This logic assumes only ONE game button per course page.
                    // If multiple games could be linked, the logic would need adjustment.

                    if (isDsaCourse) {
                      // --- Build Sorting Game Button ---
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 16, right: 16, bottom: 16),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.sort), // Sorting icon
                          label: const Text('Play Sorting Game'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor:
                                course.primaryColor, // Use course color
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Sorting game needs its provider provided here
                                builder: (_) => ChangeNotifierProvider(
                                  create: (context) => GameProvider(),
                                  child: const GameScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (isProgCourse) {
                      // --- Build Condition Catcher Button ---
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 16, right: 16, bottom: 16),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons
                              .touch_app_outlined), // Condition catcher icon
                          label: const Text('Play Condition Catcher'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor:
                                course.primaryColor, // Use course color
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Condition Catcher screen provides its own provider internally
                                builder: (_) => const ConditionCatcherScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // Should not happen if extraItems calculation is correct
                      return const SizedBox.shrink();
                    }
                  } else {
                    // --- Build Topic Tile ---
                    final topic = course.topics[index];
                    return TopicExpansionTile(topic: topic);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicExpansionTile extends StatelessWidget {
  final Topic topic;

  const TopicExpansionTile({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          topic.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: topic.lessons.map((lesson) {
          return ListTile(
            leading: Icon(
              lesson.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: lesson.isCompleted ? Colors.green : Colors.grey,
            ),
            title: Text(lesson.title),
            trailing: lesson.isLocked
                ? const Icon(Icons.lock, color: Colors.grey)
                : null,
            onTap: lesson.isLocked
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonScreen(lesson: lesson),
                      ),
                    );
                  },
          );
        }).toList(),
      ),
    );
  }
}