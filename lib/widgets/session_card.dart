import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';

/// A card widget that displays session information with type badge and attendance status
class SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback? onRecordAttendance;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
    this.onRecordAttendance,
    required this.onEdit,
    required this.onDelete,
  });

  /// Get session type color
  Color _getSessionTypeColor() {
    switch (session.type) {
      case SessionType.classSession:
        return const Color(0xFF003DA5); // ALU Blue
      case SessionType.masterySession:
        return const Color(0xFFFF6B35); // ALU Orange
      case SessionType.studyGroup:
        return const Color(0xFF4CAF50); // Green
      case SessionType.pslMeeting:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  /// Get session type label
  String _getSessionTypeLabel() {
    switch (session.type) {
      case SessionType.classSession:
        return 'CLASS';
      case SessionType.masterySession:
        return 'MASTERY';
      case SessionType.studyGroup:
        return 'STUDY GROUP';
      case SessionType.pslMeeting:
        return 'PSL MEETING';
    }
  }

  /// Get session type icon
  IconData _getSessionTypeIcon() {
    switch (session.type) {
      case SessionType.classSession:
        return Icons.school_outlined;
      case SessionType.masterySession:
        return Icons.psychology_outlined;
      case SessionType.studyGroup:
        return Icons.groups_outlined;
      case SessionType.pslMeeting:
        return Icons.meeting_room_outlined;
    }
  }

  /// Format time range for display
  String _formatTimeRange() {
    final startHour = session.startTime.hour;
    final startMinute = session.startTime.minute.toString().padLeft(2, '0');
    final endHour = session.endTime.hour;
    final endMinute = session.endTime.minute.toString().padLeft(2, '0');

    final startPeriod = startHour >= 12 ? 'PM' : 'AM';
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';

    final displayStartHour = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);
    final displayEndHour = endHour > 12
        ? endHour - 12
        : (endHour == 0 ? 12 : endHour);

    return '$displayStartHour:$startMinute $startPeriod - $displayEndHour:$endMinute $endPeriod';
  }

  /// Format date for display
  String _formatDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(
      session.date.year,
      session.date.month,
      session.date.day,
    );
    final difference = sessionDay.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else {
      return DateFormat('EEE, MMM d').format(session.date);
    }
  }

  /// Get attendance status color
  Color _getAttendanceStatusColor() {
    if (session.attendanceStatus == null) {
      return const Color(0xFF757575); // Gray
    }
    switch (session.attendanceStatus!) {
      case AttendanceStatus.present:
        return const Color(0xFF4CAF50); // Green
      case AttendanceStatus.absent:
        return const Color(0xFFF44336); // Red
    }
  }

  /// Get attendance status icon
  IconData _getAttendanceStatusIcon() {
    if (session.attendanceStatus == null) {
      return Icons.radio_button_unchecked;
    }
    switch (session.attendanceStatus!) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
    }
  }

  /// Get attendance status text
  String _getAttendanceStatusText() {
    if (session.attendanceStatus == null) {
      return 'Not Recorded';
    }
    switch (session.attendanceStatus!) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Action Buttons Row
              Row(
                children: [
                  // Session Type Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getSessionTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getSessionTypeIcon(),
                      color: _getSessionTypeColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                  // Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onEdit,
                    color: const Color(0xFF757575),
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    tooltip: 'Edit session',
                  ),
                  // Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: const Color(0xFFF44336),
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    tooltip: 'Delete session',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Session Type Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getSessionTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _getSessionTypeColor(), width: 1),
                ),
                child: Text(
                  _getSessionTypeLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getSessionTypeColor(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Date and Time Row
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: const Color(0xFF757575),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time_outlined,
                    size: 16,
                    color: const Color(0xFF757575),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _formatTimeRange(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location Row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: const Color(0xFF757575),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      session.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Attendance Status Row
              Row(
                children: [
                  Icon(
                    _getAttendanceStatusIcon(),
                    size: 18,
                    color: _getAttendanceStatusColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getAttendanceStatusText(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getAttendanceStatusColor(),
                    ),
                  ),
                  const Spacer(),
                  // Record Attendance Button (only show if callback provided and not recorded)
                  if (onRecordAttendance != null &&
                      session.attendanceStatus == null)
                    ElevatedButton.icon(
                      onPressed: onRecordAttendance,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Record'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003DA5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
