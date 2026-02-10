import 'package:flutter/foundation.dart';
import '../models/dashboard_summary.dart';
import '../services/assignment_service.dart';
import '../services/session_service.dart';
import '../services/attendance_service.dart';
import '../services/auth_service.dart';
import '../utils/error_handler.dart';

/// Provider for managing dashboard state and data aggregation
///
/// Aggregates data from AssignmentService, SessionService, and AttendanceService
/// to provide a comprehensive dashboard summary
class DashboardProvider extends ChangeNotifier {
  final AssignmentService _assignmentService;
  final SessionService _sessionService;
  final AttendanceService _attendanceService;
  final AuthService _authService;

  DashboardSummary? _summary;
  bool _isLoading = false;
  String? _error;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  DashboardProvider({
    required AssignmentService assignmentService,
    required SessionService sessionService,
    required AttendanceService attendanceService,
    required AuthService authService,
  })  : _assignmentService = assignmentService,
        _sessionService = sessionService,
        _attendanceService = attendanceService,
        _authService = authService;

  // Getters
  DashboardSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load dashboard data by aggregating from all services
  /// Optional course parameter to filter data by specific course
  Future<void> loadDashboard({String? course}) async {
    final userId = _userId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentDate = DateTime.now();
      final academicWeek = calculateAcademicWeek(currentDate);

      // Get today's sessions (filtered by course if specified)
      final todaySessions =
          await _sessionService.getTodaySessions(userId, course: course);

      // Get upcoming assignments (next 7 days, filtered by course if specified)
      final upcomingAssignments = await _assignmentService
          .getUpcomingAssignments(7, userId, course: course);

      // Get attendance percentage (always show all courses for attendance)
      final attendancePercentage =
          await _attendanceService.calculateAttendancePercentage(userId);

      // Get pending assignments count (filtered by course if specified)
      final pendingCount = await _assignmentService
          .getPendingAssignmentsCount(userId, course: course);

      _summary = DashboardSummary(
        currentDate: currentDate,
        academicWeek: academicWeek,
        todaySessions: todaySessions,
        upcomingAssignments: upcomingAssignments,
        attendancePercentage: attendancePercentage,
        pendingAssignmentsCount: pendingCount,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
      _error = 'Failed to load dashboard: $errorMessage';
      _isLoading = false;

      // Log the actual error for debugging
      if (kDebugMode) {
        print('Dashboard load error: $e');
      }

      notifyListeners();
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Calculate academic week number based on a start date
  ///
  /// Assumes academic year starts on a specific date (e.g., September 1st)
  /// and calculates the week number from that date
  int calculateAcademicWeek(DateTime date) {
    // Define academic year start date (September 1st of current or previous year)
    final year = date.month >= 9 ? date.year : date.year - 1;
    final academicYearStart = DateTime(year, 9, 1);

    // Calculate difference in days
    final difference = date.difference(academicYearStart).inDays;

    // Calculate week number (1-indexed)
    final weekNumber = (difference / 7).floor() + 1;

    // Ensure week number is at least 1
    return weekNumber > 0 ? weekNumber : 1;
  }
}
