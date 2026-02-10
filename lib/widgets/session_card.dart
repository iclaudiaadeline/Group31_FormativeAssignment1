import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';

/// A card widget that displays session information with type badge and attendance status
/// Enhanced with smooth animations and ripple effects
class SessionCard extends StatefulWidget {
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

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  /// Get session type color
  Color _getSessionTypeColor() {
    switch (widget.session.type) {
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
    switch (widget.session.type) {
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
    switch (widget.session.type) {
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
    final startHour = widget.session.startTime.hour;
    final startMinute =
        widget.session.startTime.minute.toString().padLeft(2, '0');
    final endHour = widget.session.endTime.hour;
    final endMinute = widget.session.endTime.minute.toString().padLeft(2, '0');

    final startPeriod = startHour >= 12 ? 'PM' : 'AM';
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';

    final displayStartHour =
        startHour > 12 ? startHour - 12 : (startHour == 0 ? 12 : startHour);
    final displayEndHour =
        endHour > 12 ? endHour - 12 : (endHour == 0 ? 12 : endHour);

    return '$displayStartHour:$startMinute $startPeriod - $displayEndHour:$endMinute $endPeriod';
  }

  /// Format date for display
  String _formatDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(
      widget.session.date.year,
      widget.session.date.month,
      widget.session.date.day,
    );
    final difference = sessionDay.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else {
      return DateFormat('EEE, MMM d').format(widget.session.date);
    }
  }

  /// Get attendance status color
  Color _getAttendanceStatusColor() {
    if (widget.session.attendanceStatus == null) {
      return const Color(0xFF757575); // Gray
    }
    switch (widget.session.attendanceStatus!) {
      case AttendanceStatus.present:
        return const Color(0xFF4CAF50); // Green
      case AttendanceStatus.absent:
        return const Color(0xFFF44336); // Red
    }
  }

  /// Get attendance status icon
  IconData _getAttendanceStatusIcon() {
    if (widget.session.attendanceStatus == null) {
      return Icons.radio_button_unchecked;
    }
    switch (widget.session.attendanceStatus!) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
    }
  }

  /// Get attendance status text
  String _getAttendanceStatusText() {
    if (widget.session.attendanceStatus == null) {
      return 'Not Recorded';
    }
    switch (widget.session.attendanceStatus!) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: _isPressed ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onEdit,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          splashColor: _getSessionTypeColor().withValues(alpha: 0.2),
          highlightColor: _getSessionTypeColor().withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Action Buttons Row
                Row(
                  children: [
                    // Session Type Icon with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                        widget.session.title,
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
                      onPressed: widget.onEdit,
                      color: const Color(0xFF757575),
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      tooltip: 'Edit session',
                      splashRadius: 24,
                    ),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: widget.onDelete,
                      color: const Color(0xFFF44336),
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      tooltip: 'Delete session',
                      splashRadius: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Session Type Badge with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Color(0xFF757575),
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
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Color(0xFF757575),
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
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF757575),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.session.location,
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
                    if (widget.onRecordAttendance != null &&
                        widget.session.attendanceStatus == null)
                      ElevatedButton.icon(
                        onPressed: widget.onRecordAttendance,
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
                          elevation: 2,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
