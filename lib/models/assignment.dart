import 'package:cloud_firestore/cloud_firestore.dart';

/// Priority levels for assignments
enum PriorityLevel { high, medium, low }

/// Assignment model representing a student's academic task
class Assignment {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final PriorityLevel priority;
  final bool isCompleted;
  final String userId; // User who owns this assignment
  final DateTime createdAt;
  final DateTime updatedAt;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create Assignment from Firestore document
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Assignment(
      id: doc.id,
      title: data['title'] as String,
      course: data['course'] as String,
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: _stringToPriority(data['priority'] as String),
      isCompleted: data['isCompleted'] as bool? ?? false,
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert Assignment to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'course': course,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': _priorityToString(priority),
      'isCompleted': isCompleted,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy of Assignment with updated fields
  Assignment copyWith({
    String? id,
    String? title,
    String? course,
    DateTime? dueDate,
    PriorityLevel? priority,
    bool? isCompleted,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert PriorityLevel enum to string for Firestore
  static String _priorityToString(PriorityLevel priority) {
    return priority.name;
  }

  /// Convert string to PriorityLevel enum from Firestore
  static PriorityLevel _stringToPriority(String str) {
    return PriorityLevel.values.byName(str);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assignment &&
        other.id == id &&
        other.title == title &&
        other.course == course &&
        other.dueDate == dueDate &&
        other.priority == priority &&
        other.isCompleted == isCompleted &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      course,
      dueDate,
      priority,
      isCompleted,
      userId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Assignment(id: $id, title: $title, course: $course, dueDate: $dueDate, '
        'priority: $priority, isCompleted: $isCompleted, userId: $userId)';
  }
}
