import 'package:flutter/material.dart';

/// Class Schedule Model representing a timetable entry
class ClassModel {
  final String id;
  final String subjectCode;
  final String subjectName;
  final String faculty;
  final String classroom;
  final String day; // Monday, Tuesday, etc.
  final String startTime;
  final String endTime;
  final bool isLab;
  final String status; // 'Upcoming', 'Ongoing', 'Completed'
  final Color accentColor;

  const ClassModel({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.faculty,
    required this.classroom,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.isLab = false,
    this.status = 'Upcoming',
    this.accentColor = const Color(0xFF4F46E5),
  });

  String get timeSlot => '$startTime - $endTime';

  ClassModel copyWith({
    String? id,
    String? subjectCode,
    String? subjectName,
    String? faculty,
    String? classroom,
    String? day,
    String? startTime,
    String? endTime,
    bool? isLab,
    String? status,
    Color? accentColor,
  }) {
    return ClassModel(
      id: id ?? this.id,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      faculty: faculty ?? this.faculty,
      classroom: classroom ?? this.classroom,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isLab: isLab ?? this.isLab,
      status: status ?? this.status,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
