import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../utils/error_handler.dart';

/// Service class for calculating attendance statistics
class AttendanceService {
  final FirebaseFirestore _firestore;
  final String _collection = 'sessions';

  /// Constructor with optional Firestore instance (for testing)
  AttendanceService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Calculate attendance percentage
  /// Returns (Present sessions / Total sessions with attendance) × 100
  /// Returns 0.0 if no sessions have recorded attendance
  Future<double> calculateAttendancePercentage(String userId) async {
    try {
      final sessionsWithAttendance = await getSessionsWithAttendance(userId);

      if (sessionsWithAttendance.isEmpty) {
        return 0.0;
      }

      final presentCount = sessionsWithAttendance
          .where(
            (session) => session.attendanceStatus == AttendanceStatus.present,
          )
          .length;

      final percentage = (presentCount / sessionsWithAttendance.length) * 100;

      // Round to 2 decimal places
      return double.parse(percentage.toStringAsFixed(2));
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get attendance statistics
  /// Returns a map with 'present', 'absent', and 'total' counts
  Future<Map<String, int>> getAttendanceStats(String userId) async {
    try {
      final sessionsWithAttendance = await getSessionsWithAttendance(userId);

      final presentCount = sessionsWithAttendance
          .where(
            (session) => session.attendanceStatus == AttendanceStatus.present,
          )
          .length;

      final absentCount = sessionsWithAttendance
          .where(
            (session) => session.attendanceStatus == AttendanceStatus.absent,
          )
          .length;

      return {
        'present': presentCount,
        'absent': absentCount,
        'total': sessionsWithAttendance.length,
      };
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get all sessions with recorded attendance
  /// Returns sessions where attendanceStatus is not null
  Future<List<Session>> getSessionsWithAttendance(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('attendanceStatus', isNotEqualTo: null)
          .get();

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
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Check if attendance percentage is below the 75% threshold
  /// Returns true if attendance is below 75%, false otherwise
  Future<bool> isAttendanceBelowThreshold(String userId) async {
    try {
      final percentage = await calculateAttendancePercentage(userId);
      return percentage < 75.0;
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }
}
