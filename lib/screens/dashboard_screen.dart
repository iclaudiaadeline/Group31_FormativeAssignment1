import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_provider.dart';
import '../config/colors.dart';
import '../widgets/attendance_status_widget.dart';
import '../widgets/session_type_badge.dart';
import '../widgets/priority_badge.dart';
import '../widgets/sync_status_indicator.dart';

/// Dashboard screen displaying academic overview
///
/// Shows current date, academic week, today's sessions, upcoming assignments,
/// attendance status, and pending assignments count
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    // Load dashboard data on init only if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedOnce) {
        context.read<DashboardProvider>().loadDashboard();
        _hasLoadedOnce = true;
      }
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<DashboardProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALU Academic Platform'),
        centerTitle: false,
        actions: const [
          SyncStatusIndicator(showText: true),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.summary == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            );
          }

          if (provider.error != null && provider.summary == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final summary = provider.summary;
          if (summary == null) {
            return const Center(child: Text('No data available'));
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.secondary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offline badge banner
                  const OfflineBadge(),

                  // Current Date Widget
                  _CurrentDateWidget(date: summary.currentDate),
                  const SizedBox(height: 16),

                  // Academic Week Widget
                  _AcademicWeekWidget(weekNumber: summary.academicWeek),
                  const SizedBox(height: 24),

                  // Attendance Status Card
                  const Text(
                    'Attendance Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AttendanceStatusWidget(
                    attendancePercentage: summary.attendancePercentage,
                  ),
                  const SizedBox(height: 24),

                  // Pending Assignments Card
                  _PendingAssignmentsCard(
                    count: summary.pendingAssignmentsCount,
                  ),
                  const SizedBox(height: 24),

                  // Today's Sessions Card
                  _TodaySessionsCard(sessions: summary.todaySessions),
                  const SizedBox(height: 24),

                  // Upcoming Assignments Card
                  _UpcomingAssignmentsCard(
                    assignments: summary.upcomingAssignments,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Widget displaying current date
class _CurrentDateWidget extends StatelessWidget {
  final DateTime date;

  const _CurrentDateWidget({required this.date});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppColors.secondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget displaying academic week number
class _AcademicWeekWidget extends StatelessWidget {
  final int weekNumber;

  const _AcademicWeekWidget({required this.weekNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_note, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Academic Week',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Week $weekNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying pending assignments count
class _PendingAssignmentsCard extends StatelessWidget {
  final int count;

  const _PendingAssignmentsCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment,
              color: AppColors.secondary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Pending Assignments',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying today's sessions
class _TodaySessionsCard extends StatelessWidget {
  final List sessions;

  const _TodaySessionsCard({required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Sessions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: sessions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No sessions scheduled for today',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white12, height: 24),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return _SessionListItem(session: session);
                  },
                ),
        ),
      ],
    );
  }
}

/// List item for a session
class _SessionListItem extends StatelessWidget {
  final dynamic session;

  const _SessionListItem({required this.session});

  @override
  Widget build(BuildContext context) {
    // Helper function to format TimeOfDay
    String formatTime(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${formatTime(session.startTime)} - ${formatTime(session.endTime)}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                session.location,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        SessionTypeBadge(sessionType: session.type),
      ],
    );
  }
}

/// Card displaying upcoming assignments
class _UpcomingAssignmentsCard extends StatelessWidget {
  final List assignments;

  const _UpcomingAssignmentsCard({required this.assignments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Assignments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: assignments.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No upcoming assignments in the next 7 days',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assignments.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white12, height: 24),
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return _AssignmentListItem(assignment: assignment);
                  },
                ),
        ),
      ],
    );
  }
}

/// List item for an assignment
class _AssignmentListItem extends StatelessWidget {
  final dynamic assignment;

  const _AssignmentListItem({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                assignment.course,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Due: ${dateFormat.format(assignment.dueDate)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        PriorityBadge(priority: assignment.priority),
      ],
    );
  }
}
