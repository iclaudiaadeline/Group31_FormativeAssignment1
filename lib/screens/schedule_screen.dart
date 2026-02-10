import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/session_provider.dart';
import '../widgets/session_card.dart';
import '../widgets/sync_status_indicator.dart';
import 'session_form_dialog.dart';
import '../utils/error_handler.dart';
import 'attendance_dialog.dart';

/// Screen for displaying and managing academic sessions organized by week
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _currentWeekStart;

  @override
  void initState() {
    super.initState();
    // Initialize to the start of the current week (Monday)
    _currentWeekStart = _getWeekStart(DateTime.now());
  }

  /// Get the start of the week (Monday) for a given date
  DateTime _getWeekStart(DateTime date) {
    // DateTime.weekday returns 1 for Monday, 7 for Sunday
    final daysFromMonday = date.weekday - 1;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromMonday));
  }

  /// Navigate to the previous week
  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
    });
  }

  /// Navigate to the next week
  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
    });
  }

  /// Format the week date range for display
  String _formatWeekRange() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final startFormat = DateFormat('MMM d');
    final endFormat = DateFormat('MMM d, yyyy');

    // If same month, show "Jan 1 - 7, 2024"
    if (_currentWeekStart.month == weekEnd.month) {
      return '${startFormat.format(_currentWeekStart).split(' ')[0]} ${_currentWeekStart.day} - ${weekEnd.day}, ${weekEnd.year}';
    }
    // If different months, show "Jan 30 - Feb 5, 2024"
    return '${startFormat.format(_currentWeekStart)} - ${endFormat.format(weekEnd)}';
  }

  /// Group sessions by day of week
  Map<int, List<Session>> _groupSessionsByDay(List<Session> sessions) {
    final grouped = <int, List<Session>>{};

    for (var session in sessions) {
      final dayOfWeek = session.date.weekday;
      if (!grouped.containsKey(dayOfWeek)) {
        grouped[dayOfWeek] = [];
      }
      grouped[dayOfWeek]!.add(session);
    }

    // Sort sessions within each day by start time
    for (var day in grouped.keys) {
      grouped[day]!.sort((a, b) {
        final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return aMinutes.compareTo(bMinutes);
      });
    }

    return grouped;
  }

  /// Get day name from weekday number (1 = Monday, 7 = Sunday)
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  /// Show the session form dialog for creating a new session
  void _showAddSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SessionFormDialog(),
    );
  }

  /// Show the session form dialog for editing an existing session
  void _showEditSessionDialog(BuildContext context, Session session) {
    showDialog(
      context: context,
      builder: (context) => SessionFormDialog(session: session),
    );
  }

  /// Show the attendance dialog for recording attendance
  void _showAttendanceDialog(BuildContext context, Session session) {
    showDialog(
      context: context,
      builder: (context) => AttendanceDialog(session: session),
    );
  }

  /// Show confirmation dialog before deleting a session
  Future<void> _confirmDeleteSession(
    BuildContext context,
    Session session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: Text('Are you sure you want to delete "${session.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF44336),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await context.read<SessionProvider>().deleteSession(session.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text('Error deleting session: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          const SyncStatusIndicator(compact: true),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSessionDialog(context),
            tooltip: 'Add session',
          ),
        ],
      ),
      body: Consumer<SessionProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isLoading && provider.sessions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFF44336),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Color(0xFF757575)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Get sessions for the current week
          final weekSessions = provider.getSessionsForWeek(_currentWeekStart);

          return Column(
            children: [
              // Week Navigation Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Previous Week Button
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _goToPreviousWeek,
                      tooltip: 'Previous week',
                    ),
                    // Week Range Display
                    Expanded(
                      child: Text(
                        _formatWeekRange(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Next Week Button
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _goToNextWeek,
                      tooltip: 'Next week',
                    ),
                  ],
                ),
              ),

              // Sessions List
              Expanded(
                child: weekSessions.isEmpty
                    ? _buildEmptyState()
                    : _buildSessionsList(weekSessions),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSessionDialog(context),
        tooltip: 'Add session',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build the empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: const Color(0xFF757575).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No sessions this week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add a session',
            style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
        ],
      ),
    );
  }

  /// Build the sessions list grouped by day
  Widget _buildSessionsList(List<Session> sessions) {
    final groupedSessions = _groupSessionsByDay(sessions);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: 7, // 7 days in a week
      itemBuilder: (context, index) {
        final weekday = index + 1; // 1 = Monday, 7 = Sunday
        final dayDate = _currentWeekStart.add(Duration(days: index));
        final daySessions = groupedSessions[weekday] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF5F5F5),
              child: Row(
                children: [
                  Text(
                    _getDayName(weekday),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d').format(dayDate),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const Spacer(),
                  if (daySessions.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003DA5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${daySessions.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003DA5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Day Sessions
            if (daySessions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No sessions',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF757575).withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...daySessions.map(
                (session) => SessionCard(
                  session: session,
                  onRecordAttendance: () =>
                      _showAttendanceDialog(context, session),
                  onEdit: () => _showEditSessionDialog(context, session),
                  onDelete: () => _confirmDeleteSession(context, session),
                ),
              ),
          ],
        );
      },
    );
  }
}
