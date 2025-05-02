import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final List<Topic> topics;
  final Color primaryColor;
  final String imageUrl;
  final bool isLocked;
  final double progress;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.topics,
    required this.primaryColor,
    required this.imageUrl,
    this.isLocked = false,
    this.progress = 0.0,
  });
}

class Topic {
  final String id;
  final String title;
  final List<Lesson> lessons;
  final bool isLocked;
  final double progress;

  const Topic({
    required this.id,
    required this.title,
    required this.lessons,
    this.isLocked = false,
    this.progress = 0.0,
  });
}

class Lesson {
  final String id;
  final String title;
  final String content;
  final List<String> objectives;
  final List<InteractiveElement> interactiveElements;
  final bool isCompleted;
  final bool isLocked;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.objectives,
    required this.interactiveElements,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

class InteractiveElement {
  final String id;
  final String type;
  final String description;
  final Map<String, dynamic> configuration;

  const InteractiveElement({
    required this.id,
    required this.type,
    required this.description,
    required this.configuration,
  });
} 