import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Subject Attendance Model with automatic percentage calculation and status
class AttendanceModel {
  final String id;
  final String subjectCode;
  final String subjectName;
  final String faculty;
  final int attendedClasses;
  final int totalClasses;

  const AttendanceModel({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.faculty,
    required this.attendedClasses,
    required this.totalClasses,
  });

  double get percentage {
    if (totalClasses == 0) return 0.0;
    return (attendedClasses / totalClasses) * 100;
  }

  double get ratio {
    if (totalClasses == 0) return 0.0;
    return attendedClasses / totalClasses;
  }

  String get percentageFormatted => '${percentage.toStringAsFixed(1)}%';

  String get status {
    if (percentage >= 75.0) return 'Safe';
    if (percentage >= 65.0) return 'Warning';
    return 'Critical';
  }

  Color get statusColor {
    if (percentage >= 75.0) return AppColors.success;
    if (percentage >= 65.0) return AppColors.warning;
    return AppColors.error;
  }

  Color get statusBgColor {
    if (percentage >= 75.0) return AppColors.successBgLight;
    if (percentage >= 65.0) return AppColors.warningBgLight;
    return AppColors.errorBgLight;
  }

  AttendanceModel copyWith({
    String? id,
    String? subjectCode,
    String? subjectName,
    String? faculty,
    int? attendedClasses,
    int? totalClasses,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      faculty: faculty ?? this.faculty,
      attendedClasses: attendedClasses ?? this.attendedClasses,
      totalClasses: totalClasses ?? this.totalClasses,
    );
  }
}
