import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/announcement.dart';
import '../utils/error_handler.dart';

/// Service class for managing user-specific Announcement data in Firestore
class AnnouncementService {
  final FirebaseFirestore _firestore;
  final String _collection = 'announcements';

  /// Constructor with optional Firestore instance (for testing)
  AnnouncementService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get a real-time stream of user-specific announcements sorted by creation date
  /// Returns a stream that emits the updated list whenever data changes
  Stream<List<Announcement>> getAnnouncementsStream(String userId) {
    try {
      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                final announcement = Announcement.fromFirestore(doc);
                // Only return valid (non-expired) announcements
                return announcement.isValid ? announcement : null;
              } catch (e) {
                // Log error and skip corrupted documents
                debugPrint('Error parsing announcement ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Announcement>()
            .toList();
      });
    } catch (e) {
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  /// Get a single announcement by ID
  /// Returns null if the announcement doesn't exist
  Future<Announcement?> getAnnouncementById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return Announcement.fromFirestore(doc);
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get all announcements for a specific user
  Future<List<Announcement>> getUserAnnouncements(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return Announcement.fromFirestore(doc);
            } catch (e) {
              debugPrint('Error parsing announcement ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Announcement>()
          .toList();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Mark an announcement as read
  Future<void> markAsRead(String announcementId) async {
    try {
      await _firestore.collection(_collection).doc(announcementId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get count of unread announcements for a user
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      // Fallback to old method if count() is not supported
      try {
        final snapshot = await _firestore
            .collection(_collection)
            .where('userId', isEqualTo: userId)
            .where('isRead', isEqualTo: false)
            .get();

        return snapshot.docs.length;
      } catch (fallbackError) {
        throw Exception(FirestoreErrorHandler.getErrorMessage(fallbackError));
      }
    }
  }

  /// Create a new announcement (for admin/system use)
  Future<String> createAnnouncement(Announcement announcement) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(announcement.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }
}
