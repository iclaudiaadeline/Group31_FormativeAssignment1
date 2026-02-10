import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/assignment.dart';
import '../utils/error_handler.dart';

/// Service class for managing Assignment data in Firestore
class AssignmentService {
  final FirebaseFirestore _firestore;
  final String _collection = 'assignments';

  /// Constructor with optional Firestore instance (for testing)
  AssignmentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new assignment in Firestore
  /// Returns the ID of the created assignment
  /// Throws an error if creation fails
  Future<String> createAssignment(Assignment assignment) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(assignment.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get a real-time stream of all assignments sorted by due date
  /// Returns a stream that emits the updated list whenever data changes
  Stream<List<Assignment>> getAssignmentsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              try {
                return Assignment.fromFirestore(doc);
              } catch (e) {
                // Log error and skip corrupted documents
                debugPrint('Error parsing assignment ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Assignment>()
            .toList();
      });
    } catch (e) {
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  /// Get a single assignment by ID
  /// Returns null if the assignment doesn't exist
  Future<Assignment?> getAssignmentById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return Assignment.fromFirestore(doc);
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Update an existing assignment
  /// Automatically updates the updatedAt timestamp
  Future<void> updateAssignment(Assignment assignment) async {
    try {
      final updatedAssignment = assignment.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_collection)
          .doc(assignment.id)
          .update(updatedAssignment.toFirestore());
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Toggle the completion status of an assignment
  /// Updates the isCompleted field and updatedAt timestamp
  Future<void> toggleAssignmentCompletion(String id) async {
    try {
      final assignment = await getAssignmentById(id);

      if (assignment == null) {
        throw Exception('Assignment not found');
      }

      final updatedAssignment = assignment.copyWith(
        isCompleted: !assignment.isCompleted,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(id)
          .update(updatedAssignment.toFirestore());
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Delete an assignment from Firestore
  Future<void> deleteAssignment(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get assignments due within the specified number of days
  /// Returns assignments with due dates between now and now + days
  Future<List<Assignment>> getUpcomingAssignments(int days) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: days));

      final snapshot = await _firestore
          .collection(_collection)
          .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return Assignment.fromFirestore(doc);
            } catch (e) {
              debugPrint('Error parsing assignment ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Assignment>()
          .toList();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }

  /// Get the count of pending (incomplete) assignments
  /// Returns the number of assignments where isCompleted is false
  /// Optimized to use count() instead of fetching all documents
  Future<int> getPendingAssignmentsCount() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isCompleted', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      // Fallback to old method if count() is not supported
      try {
        final snapshot = await _firestore
            .collection(_collection)
            .where('isCompleted', isEqualTo: false)
            .get();

        return snapshot.docs.length;
      } catch (fallbackError) {
        throw Exception(FirestoreErrorHandler.getErrorMessage(fallbackError));
      }
    }
  }

  /// Get all assignments sorted by due date (helper method)
  /// Returns a list of assignments ordered by due date ascending
  Future<List<Assignment>> getAssignmentsSortedByDueDate() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('dueDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) {
            try {
              return Assignment.fromFirestore(doc);
            } catch (e) {
              debugPrint('Error parsing assignment ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Assignment>()
          .toList();
    } catch (e) {
      throw Exception(FirestoreErrorHandler.getErrorMessage(e));
    }
  }
}
