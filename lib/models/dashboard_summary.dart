import 'session.dart';
import 'assignment.dart';

/// Model representing dashboard summary data
///
/// Aggregates data from sessions and assignments to provide
/// a comprehensive overview of the student's academic status
class DashboardSummary {
  final DateTime currentDate;
  final int academicWeek;
  final List<Session> todaySessions;
  final List<Assignment> upcomingAssignments;
  final double attendancePercentage;
  final int pendingAssignmentsCount;
  final bool isAttendanceBelowThreshold;

  DashboardSummary({
    required this.currentDate,
    required this.academicWeek,
    required this.todaySessions,
    required this.upcomingAssignments,
    required this.attendancePercentage,
    required this.pendingAssignmentsCount,
  }) : isAttendanceBelowThreshold = attendancePercentage < 75.0;

  /// Creates an empty dashboard summary
  factory DashboardSummary.empty() {
    return DashboardSummary(
      currentDate: DateTime.now(),
      academicWeek: 1,
      todaySessions: [],
      upcomingAssignments: [],
      attendancePercentage: 0.0,
      pendingAssignmentsCount: 0,
    );
  }

  /// Creates a copy with updated fields
  DashboardSummary copyWith({
    DateTime? currentDate,
    int? academicWeek,
    List<Session>? todaySessions,
    List<Assignment>? upcomingAssignments,
    double? attendancePercentage,
    int? pendingAssignmentsCount,
  }) {
    return DashboardSummary(
      currentDate: currentDate ?? this.currentDate,
      academicWeek: academicWeek ?? this.academicWeek,
      todaySessions: todaySessions ?? this.todaySessions,
      upcomingAssignments: upcomingAssignments ?? this.upcomingAssignments,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      pendingAssignmentsCount:
          pendingAssignmentsCount ?? this.pendingAssignmentsCount,
    );
  }
}
