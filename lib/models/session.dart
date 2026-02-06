import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Session types for academic events
enum SessionType { classSession, masterySession, studyGroup, pslMeeting }

/// Attendance status for sessions
enum AttendanceStatus { present, absent }

/// Session model representing a scheduled academic event
class Session {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final SessionType type;
  final AttendanceStatus? attendanceStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Session({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.type,
    this.attendanceStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create Session from Firestore document
  factory Session.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Session(
      id: doc.id,
      title: data['title'] as String,
      date: (data['date'] as Timestamp).toDate(),
      startTime: _stringToTime(data['startTime'] as String),
      endTime: _stringToTime(data['endTime'] as String),
      location: data['location'] as String,
      type: _stringToSessionType(data['type'] as String),
      attendanceStatus: data['attendanceStatus'] != null
          ? _stringToAttendance(data['attendanceStatus'] as String)
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert Session to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'startTime': _timeToString(startTime),
      'endTime': _timeToString(endTime),
      'location': location,
      'type': _sessionTypeToString(type),
      'attendanceStatus': attendanceStatus != null
          ? _attendanceToString(attendanceStatus!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy of Session with updated fields
  Session copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    SessionType? type,
    AttendanceStatus? attendanceStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if session is scheduled for today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if session is in the specified week
  bool isInWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd);
  }

  /// Get the week number for this session
  /// Assumes semester starts on a fixed date (can be configured)
  int getWeekNumber() {
    // Default semester start date (can be configured)
    final semesterStart = DateTime(date.year, 1, 1);
    final difference = date.difference(semesterStart).inDays;
    return (difference / 7).floor() + 1;
  }

  /// Convert TimeOfDay to string in HH:mm format
  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Convert string to TimeOfDay from HH:mm format
  static TimeOfDay _stringToTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Convert SessionType enum to string for Firestore
  static String _sessionTypeToString(SessionType type) {
    switch (type) {
      case SessionType.classSession:
        return 'class';
      case SessionType.masterySession:
        return 'mastery';
      case SessionType.studyGroup:
        return 'study_group';
      case SessionType.pslMeeting:
        return 'psl';
    }
  }

  /// Convert string to SessionType enum from Firestore
  static SessionType _stringToSessionType(String str) {
    switch (str) {
      case 'class':
        return SessionType.classSession;
      case 'mastery':
        return SessionType.masterySession;
      case 'study_group':
        return SessionType.studyGroup;
      case 'psl':
        return SessionType.pslMeeting;
      default:
        throw ArgumentError('Invalid session type: $str');
    }
  }

  /// Convert AttendanceStatus enum to string for Firestore
  static String _attendanceToString(AttendanceStatus status) {
    return status.name;
  }

  /// Convert string to AttendanceStatus enum from Firestore
  static AttendanceStatus _stringToAttendance(String str) {
    return AttendanceStatus.values.byName(str);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session &&
        other.id == id &&
        other.title == title &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.location == location &&
        other.type == type &&
        other.attendanceStatus == attendanceStatus &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      date,
      startTime,
      endTime,
      location,
      type,
      attendanceStatus,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Session(id: $id, title: $title, date: $date, '
        'startTime: $startTime, endTime: $endTime, location: $location, '
        'type: $type, attendanceStatus: $attendanceStatus)';
  }
}
