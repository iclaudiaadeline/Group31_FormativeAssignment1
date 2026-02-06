/// Validator class for Assignment model
class AssignmentValidator {
  /// Validates assignment title
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

  /// Validates assignment course
  /// Returns error message if invalid, null if valid
  static String? validateCourse(String? course) {
    if (course == null || course.trim().isEmpty) {
      return 'Course is required';
    }
    if (course.length > 50) {
      return 'Course must be 50 characters or less';
    }
    return null;
  }

  /// Validates assignment due date
  /// Returns error message if invalid, null if valid
  static String? validateDueDate(DateTime? dueDate) {
    if (dueDate == null) {
      return 'Due date is required';
    }
    return null;
  }

  /// Validates all assignment fields
  /// Returns true if all fields are valid, false otherwise
  static bool isValid({
    required String? title,
    required String? course,
    required DateTime? dueDate,
  }) {
    return validateTitle(title) == null &&
        validateCourse(course) == null &&
        validateDueDate(dueDate) == null;
  }
}
