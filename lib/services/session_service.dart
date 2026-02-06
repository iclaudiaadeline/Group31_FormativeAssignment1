import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../utils/error_handler.dart';

/// Service class for managing Session data in Firestore
class SessionService {
  final FirebaseFirestore _firestore;
  final String _collection = 'sessions';

  /// Constructor with optional Firestore instance (for testing)
  SessionService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new session in Firestore
  /// Returns the ID of the created session
  /// Throws an error if creation fails
  Future<String> createSession(Session session) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(session.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get a real-time stream of all sessions sorted by date and start time
  /// Returns a stream that emits the updated list whenever data changes
  Stream<List<Session>> getSessionsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  try {
                    return Session.fromFirestore(doc);
                  } catch (e) {
                    // Log error and skip corrupted documents
                    debugPrint('Error parsing session ${doc.id}: $e');
                    return null;
                  }
                })
                .whereType<Session>()
                .toList();
          });
    } catch (e) {
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  /// Get a single session by ID
  /// Returns null if the session doesn't exist
  Future<Session?> getSessionById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return Session.fromFirestore(doc);
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Update an existing session
  /// Automatically updates the updatedAt timestamp
  Future<void> updateSession(Session session) async {
    try {
      final updatedSession = session.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_collection)
          .doc(session.id)
          .update(updatedSession.toFirestore());
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Record attendance for a session
  /// Updates the attendanceStatus field and updatedAt timestamp
  Future<void> recordAttendance(String id, AttendanceStatus status) async {
    try {
      final session = await getSessionById(id);

      if (session == null) {
        throw Exception('Session not found');
      }

      final updatedSession = session.copyWith(
        attendanceStatus: status,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(id)
          .update(updatedSession.toFirestore());
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Delete a session from Firestore
  Future<void> deleteSession(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get sessions for a specific date
  /// Returns all sessions scheduled on the given date
  Future<List<Session>> getSessionsForDate(DateTime date) async {
    try {
      // Normalize date to start of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return Session.fromFirestore(doc);
            } catch (e) {
              debugPrint('Error parsing session ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Session>()
          .toList();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get sessions for a specific week
  /// Returns all sessions between weekStart (inclusive) and weekStart + 7 days (exclusive)
  Future<List<Session>> getSessionsForWeek(DateTime weekStart) async {
    try {
      // Normalize to start of day
      final startOfWeek = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      );
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final snapshot = await _firestore
          .collection(_collection)
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek),
          )
          .where('date', isLessThan: Timestamp.fromDate(endOfWeek))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return Session.fromFirestore(doc);
            } catch (e) {
              debugPrint('Error parsing session ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Session>()
          .toList();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get all sessions scheduled for today
  /// Returns sessions where the date matches the current date
  Future<List<Session>> getTodaySessions() async {
    try {
      final now = DateTime.now();
      return await getSessionsForDate(now);
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }
}
