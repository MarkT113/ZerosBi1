import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../data/courses_data.dart';
import 'lesson_screen.dart';

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
                    valueColor: AlwaysStoppedAnimation<Color>(course.primaryColor),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: course.topics.length,
          itemBuilder: (context, index) {
            final topic = course.topics[index];
            return TopicExpansionTile(topic: topic);
          },
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