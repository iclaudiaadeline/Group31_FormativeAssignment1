import 'package:flutter/foundation.dart';
import '../models/announcement.dart';
import '../services/announcement_service.dart';
import '../services/dynamic_announcement_service.dart';
import '../services/auth_service.dart';

/// Provider for managing user-specific announcement state
class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementService _service;
  final DynamicAnnouncementService _dynamicService;
  final AuthService _authService;

  List<Announcement> _announcements = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;

  AnnouncementProvider({
    required AnnouncementService service,
    required AuthService authService,
    DynamicAnnouncementService? dynamicService,
  })  : _service = service,
        _dynamicService = dynamicService ?? DynamicAnnouncementService(),
        _authService = authService;

  // Getters
  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get announcementCount => _announcements.length;
  int get unreadCount => _unreadCount;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  /// Initialize and listen to Firestore stream for user-specific announcements
  void initialize() {
    final userId = _userId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Generate dynamic announcements first
    _generateDynamicAnnouncements();

    _service.getAnnouncementsStream(userId).listen(
      (announcements) {
        _announcements = announcements;
        _isLoading = false;
        _error = null;
        _updateUnreadCount();
        notifyListeners();
      },
      onError: (error) {
        _error = 'Failed to load announcements: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Generate dynamic announcements based on sessions and assignments
  Future<void> _generateDynamicAnnouncements() async {
    final userId = _userId;
    if (userId == null) return;

    try {
      await _dynamicService.generateAnnouncementsForUser(userId);
    } catch (e) {
      debugPrint('Failed to generate dynamic announcements: $e');
    }
  }

  /// Refresh announcements
  Future<void> refresh() async {
    final userId = _userId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Generate dynamic announcements first
      await _generateDynamicAnnouncements();

      final announcements = await _service.getUserAnnouncements(userId);
      _announcements = announcements.where((a) => a.isValid).toList();
      _error = null;
      _updateUnreadCount();
    } catch (e) {
      _error = 'Failed to refresh announcements: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark an announcement as read
  Future<void> markAsRead(String announcementId) async {
    try {
      await _service.markAsRead(announcementId);
      // Update local state
      final index = _announcements.indexWhere((a) => a.id == announcementId);
      if (index != -1) {
        _announcements[index] = _announcements[index].copyWith(isRead: true);
        _updateUnreadCount();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to mark announcement as read: $e';
      notifyListeners();
    }
  }

  /// Update unread count
  void _updateUnreadCount() {
    _unreadCount = _announcements.where((a) => !a.isRead).length;
  }

  /// Get announcements by priority
  List<Announcement> getAnnouncementsByPriority(String priority) {
    return _announcements.where((a) => a.priority == priority).toList();
  }

  /// Get high priority announcements
  List<Announcement> get highPriorityAnnouncements {
    return getAnnouncementsByPriority('high');
  }

  /// Get unread announcements
  List<Announcement> get unreadAnnouncements {
    return _announcements.where((a) => !a.isRead).toList();
  }
}
