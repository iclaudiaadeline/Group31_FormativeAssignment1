import 'package:firebase_core/firebase_core.dart';

/// Utility class for handling Firestore errors and converting them to user-friendly messages
class FirestoreErrorHandler {
  /// Converts a Firestore error to a user-friendly error message
  ///
  /// Handles common FirebaseException codes and returns appropriate messages
  /// for users to understand what went wrong.
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
          return 'Operation timed out. Please check your connection and try again.';
        case 'invalid-argument':
          return 'Invalid data provided. Please check your input.';
        case 'unauthenticated':
          return 'You must be signed in to perform this action';
        case 'resource-exhausted':
          return 'Too many requests. Please try again later.';
        case 'failed-precondition':
          return 'Operation cannot be performed in the current state';
        case 'aborted':
          return 'Operation was aborted. Please try again.';
        case 'out-of-range':
          return 'Operation was attempted past the valid range';
        case 'unimplemented':
          return 'This operation is not implemented';
        case 'internal':
          return 'Internal server error. Please try again later.';
        case 'data-loss':
          return 'Data loss or corruption detected';
        default:
          return 'An error occurred: ${error.message ?? 'Unknown error'}';
      }
    }

    // Handle non-Firebase exceptions
    return 'An unexpected error occurred';
  }
}
