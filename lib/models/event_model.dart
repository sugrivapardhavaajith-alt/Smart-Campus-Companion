import 'package:flutter/material.dart';

/// Campus Event Model for events discovery and registration
class EventModel {
  final String id;
  final String title;
  final String category; // 'Technical', 'Cultural', 'Sports', 'Workshops'
  final String date;
  final String time;
  final String venue;
  final String description;
  final String organizer;
  final int registeredCount;
  final int capacity;
  final bool isRegistered;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String? bannerAsset;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.venue,
    required this.description,
    required this.organizer,
    required this.registeredCount,
    required this.capacity,
    this.isRegistered = false,
    this.icon = Icons.event,
    this.primaryColor = const Color(0xFF4F46E5),
    this.secondaryColor = const Color(0xFF8B5CF6),
    this.bannerAsset,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? category,
    String? date,
    String? time,
    String? venue,
    String? description,
    String? organizer,
    int? registeredCount,
    int? capacity,
    bool? isRegistered,
    IconData? icon,
    Color? primaryColor,
    Color? secondaryColor,
    String? bannerAsset,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      description: description ?? this.description,
      organizer: organizer ?? this.organizer,
      registeredCount: registeredCount ?? this.registeredCount,
      capacity: capacity ?? this.capacity,
      isRegistered: isRegistered ?? this.isRegistered,
      icon: icon ?? this.icon,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      bannerAsset: bannerAsset ?? this.bannerAsset,
    );
  }
}
