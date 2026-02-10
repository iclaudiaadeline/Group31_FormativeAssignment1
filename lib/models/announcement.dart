import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for Announcement
class Announcement {
  final String id;
  final String userId; // User-specific announcements
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String priority; // 'high', 'medium', 'low'
  final bool isRead; // Track if user has read the announcement

  Announcement({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.expiresAt,
    this.priority = 'medium',
    this.isRead = false,
  });

  /// Create Announcement from Firestore document
  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      priority: data['priority'] ?? 'medium',
      isRead: data['isRead'] ?? false,
    );
  }

  /// Convert Announcement to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'priority': priority,
      'isRead': isRead,
    };
  }

  /// Check if announcement is still valid (not expired)
  bool get isValid {
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }

  /// Copy with method for immutable updates
  Announcement copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? priority,
    bool? isRead,
  }) {
    return Announcement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
    );
  }
}
