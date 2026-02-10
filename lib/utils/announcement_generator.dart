import 'package:flutter/material.dart';
import '../services/dynamic_announcement_service.dart';
import '../services/auth_service.dart';

/// Utility class to manually trigger announcement generation
class AnnouncementGenerator {
  final DynamicAnnouncementService _dynamicService;
  final AuthService _authService;

  AnnouncementGenerator({
    DynamicAnnouncementService? dynamicService,
    AuthService? authService,
  })  : _dynamicService = dynamicService ?? DynamicAnnouncementService(),
        _authService = authService ?? AuthService();

  /// Generate announcements for the current user
  Future<void> generateForCurrentUser() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      debugPrint('No user logged in');
      return;
    }

    try {
      debugPrint('Generating announcements for user: $userId');
      await _dynamicService.generateAnnouncementsForUser(userId);
      debugPrint('Announcements generated successfully');
    } catch (e) {
      debugPrint('Error generating announcements: $e');
    }
  }
}
