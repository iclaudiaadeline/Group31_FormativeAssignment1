import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class for handling Firestore errors and converting them to user-friendly messages
class FirestoreErrorHandler {
  /// Get a user-friendly error message from a Firestore error
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action';
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again.';
        case 'not-found':
          return 'The requested data was not found';
        case 'already-exists':
          return 'This item already exists';
        case 'cancelled':
          return 'Operation was cancelled';
        case 'deadline-exceeded':
          return 'Operation timed out. Please try again.';
        case 'unauthenticated':
          return 'You must be logged in to perform this action';
        default:
          return 'An error occurred: ${error.message ?? 'Unknown error'}';
      }
    }
    return 'An unexpected error occurred';
  }
}
