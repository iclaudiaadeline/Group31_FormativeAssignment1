import 'package:flutter/foundation.dart';
import '../models/dashboard_summary.dart';
import '../services/assignment_service.dart';
import '../services/session_service.dart';
import '../services/attendance_service.dart';

/// Provider for managing dashboard state and data aggregation
///
/// Aggregates data from AssignmentService, SessionService, and AttendanceService
/// to provide a comprehensive dashboard summary
class DashboardProvider extends ChangeNotifier {
  final AssignmentService _assignmentService;
  final SessionService _sessionService;
  final AttendanceService _attendanceService;

  DashboardSummary? _summary;
  bool _isLoading = false;
  String? _error;

  DashboardProvider({
    required AssignmentService assignmentService,
    required SessionService sessionService,
    required AttendanceService attendanceService,
  }) : _assignmentService = assignmentService,
       _sessionService = sessionService,
       _attendanceService = attendanceService;

  // Getters
  DashboardSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load dashboard data by aggregating from all services
  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentDate = DateTime.now();
      final academicWeek = calculateAcademicWeek(currentDate);

      // Get today's sessions
      final todaySessions = await _sessionService.getTodaySessions();

      // Get upcoming assignments (next 7 days)
      final upcomingAssignments = await _assignmentService
          .getUpcomingAssignments(7);

      // Get attendance percentage
      final attendancePercentage = await _attendanceService
          .calculateAttendancePercentage();

      // Get pending assignments count
      final pendingCount = await _assignmentService
          .getPendingAssignmentsCount();

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
      _error = 'Failed to load dashboard: ${e.toString()}';
      _isLoading = false;
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
