import 'package:flutter/material.dart';

/// Validator class for Session model
class SessionValidator {
  /// Validates session title
  /// Returns error message if invalid, null if valid
  static String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title is required';
    }
    if (title.length > 100) {
      return 'Title must be 100 characters or less';
    }
    return null;
  }

  /// Validates session date
  /// Returns error message if invalid, null if valid
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }
    return null;
  }

  /// Validates session time range
  /// Returns error message if invalid, null if valid
  static String? validateTimeRange(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null) {
      return 'Start time is required';
    }
    if (endTime == null) {
      return 'End time is required';
    }

    // Convert to minutes for comparison
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    if (endMinutes <= startMinutes) {
      return 'End time must be after start time';
    }

    return null;
  }

  /// Validates session location
  /// Returns error message if invalid, null if valid
  static String? validateLocation(String? location) {
    if (location == null || location.trim().isEmpty) {
      return 'Location is required';
    }
    if (location.length > 100) {
      return 'Location must be 100 characters or less';
    }
    return null;
  }

  /// Validates all session fields
  /// Returns true if all fields are valid, false otherwise
  static bool isValid({
    required String? title,
    required DateTime? date,
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
    required String? location,
  }) {
    return validateTitle(title) == null &&
        validateDate(date) == null &&
        validateTimeRange(startTime, endTime) == null &&
        validateLocation(location) == null;
  }
}
