/// Spacing constants for consistent layout throughout the app
///
/// This file defines standard spacing values to ensure visual consistency
/// and proper alignment across all screens and components.
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  /// Extra small spacing (4dp) - for tight spacing between related elements
  static const double xs = 4.0;

  /// Small spacing (8dp) - for spacing between closely related elements
  static const double sm = 8.0;

  /// Medium spacing (12dp) - for spacing between related groups
  static const double md = 12.0;

  /// Large spacing (16dp) - standard spacing for most UI elements
  static const double lg = 16.0;

  /// Extra large spacing (24dp) - for spacing between major sections
  static const double xl = 24.0;

  /// Extra extra large spacing (32dp) - for large gaps between sections
  static const double xxl = 32.0;

  /// Card margin - horizontal and vertical spacing for cards
  static const double cardMarginHorizontal = 16.0;
  static const double cardMarginVertical = 8.0;

  /// Card padding - internal padding for card content
  static const double cardPadding = 16.0;

  /// Screen padding - padding for screen edges
  static const double screenPadding = 16.0;

  /// Minimum touch target size (48dp) - for accessibility
  static const double minTouchTarget = 48.0;

  /// Border radius values
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusPill = 999.0; // For fully rounded elements

  /// Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconExtraLarge = 48.0;

  /// Elevation values for consistent shadows
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}
