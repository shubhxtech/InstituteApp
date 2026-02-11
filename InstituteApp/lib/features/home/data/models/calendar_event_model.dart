import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final Color color;
  final String category;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
    required this.color,
    required this.category,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isAllDay: json['isAllDay'] ?? true,
      color: _hexToColor(json['color'] ?? '#3283D5'),
      category: json['category'] ?? 'event',
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
