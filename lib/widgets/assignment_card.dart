import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';

/// A card widget that displays assignment information with priority color coding
/// and smooth animations for interactions
class AssignmentCard extends StatefulWidget {
  final Assignment assignment;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard>
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

  /// Get priority color based on priority level
  Color _getPriorityColor() {
    switch (widget.assignment.priority) {
      case PriorityLevel.high:
        return const Color(0xFFF44336); // Red
      case PriorityLevel.medium:
        return const Color(0xFFFF9800); // Orange
      case PriorityLevel.low:
        return const Color(0xFF4CAF50); // Green
    }
  }

  /// Get priority label text
  String _getPriorityLabel() {
    switch (widget.assignment.priority) {
      case PriorityLevel.high:
        return 'HIGH';
      case PriorityLevel.medium:
        return 'MEDIUM';
      case PriorityLevel.low:
        return 'LOW';
    }
  }

  /// Format due date for display
  String _formatDueDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      widget.assignment.dueDate.year,
      widget.assignment.dueDate.month,
      widget.assignment.dueDate.day,
    );
    final difference = dueDay.difference(today).inDays;

    if (difference == 0) {
      return 'Due Today';
    } else if (difference == 1) {
      return 'Due Tomorrow';
    } else if (difference < 0) {
      return 'Overdue';
    } else {
      return 'Due ${DateFormat('MMM d, yyyy').format(widget.assignment.dueDate)}';
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
          splashColor: _getPriorityColor().withValues(alpha: 0.2),
          highlightColor: _getPriorityColor().withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Checkbox Row
                Row(
                  children: [
                    // Completion Checkbox
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Checkbox(
                        value: widget.assignment.isCompleted,
                        onChanged: (_) => widget.onToggleComplete(),
                        activeColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Title with animated text style
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF212121),
                          decoration: widget.assignment.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        child: Text(widget.assignment.title),
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
                      tooltip: 'Edit assignment',
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
                      tooltip: 'Delete assignment',
                      splashRadius: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Course and Priority Row
                Row(
                  children: [
                    // Course
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.book_outlined,
                            size: 16,
                            color: Color(0xFF757575),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.assignment.course,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Priority Badge with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: _getPriorityColor(), width: 1),
                      ),
                      child: Text(
                        _getPriorityLabel(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Due Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: _getDueDateColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDueDate(),
                      style: TextStyle(
                        fontSize: 14,
                        color: _getDueDateColor(),
                        fontWeight:
                            _isOverdue() ? FontWeight.w600 : FontWeight.normal,
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

  /// Get due date text color based on urgency
  Color _getDueDateColor() {
    if (_isOverdue()) {
      return const Color(0xFFF44336); // Red for overdue
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      widget.assignment.dueDate.year,
      widget.assignment.dueDate.month,
      widget.assignment.dueDate.day,
    );
    final difference = dueDay.difference(today).inDays;

    if (difference <= 1) {
      return const Color(0xFFFF9800); // Orange for today/tomorrow
    }
    return const Color(0xFF757575); // Gray for future dates
  }

  /// Check if assignment is overdue
  bool _isOverdue() {
    if (widget.assignment.isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      widget.assignment.dueDate.year,
      widget.assignment.dueDate.month,
      widget.assignment.dueDate.day,
    );
    return dueDay.isBefore(today);
  }
}
