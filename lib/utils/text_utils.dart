/// Utility functions for text handling and display
class TextUtils {
  /// Truncate text to a maximum length with ellipsis
  ///
  /// If the text exceeds maxLength, it will be truncated and '...' will be appended
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Truncate text for display in cards (shorter version)
  static String truncateForCard(String text) {
    return truncate(text, 50);
  }

  /// Truncate text for list items
  static String truncateForList(String text) {
    return truncate(text, 80);
  }

  /// Sanitize text input by trimming whitespace
  static String sanitize(String text) {
    return text.trim();
  }

  /// Check if text is effectively empty (null, empty, or only whitespace)
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Format text for display, handling null and empty cases
  static String formatForDisplay(String? text, {String defaultValue = 'N/A'}) {
    if (isEmpty(text)) {
      return defaultValue;
    }
    return text!.trim();
  }

  /// Validate text length is within bounds
  static bool isWithinLength(String? text, int maxLength) {
    if (text == null) return true;
    return text.length <= maxLength;
  }

  /// Get character count for display (useful for showing remaining characters)
  static String getCharacterCount(String? text, int maxLength) {
    final length = text?.length ?? 0;
    return '$length/$maxLength';
  }

  /// Check if text contains only whitespace
  static bool isOnlyWhitespace(String? text) {
    if (text == null) return true;
    return text.trim().isEmpty && text.isNotEmpty;
  }

  /// Remove excessive whitespace (multiple spaces, tabs, newlines)
  static String normalizeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Capitalize first letter only
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
