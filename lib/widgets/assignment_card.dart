import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';

/// A card widget that displays assignment information with priority color coding
class AssignmentCard extends StatelessWidget {
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

  /// Get priority color based on priority level
  Color _getPriorityColor() {
    switch (assignment.priority) {
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
    switch (assignment.priority) {
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
      assignment.dueDate.year,
      assignment.dueDate.month,
      assignment.dueDate.day,
    );
    final difference = dueDay.difference(today).inDays;

    if (difference == 0) {
      return 'Due Today';
    } else if (difference == 1) {
      return 'Due Tomorrow';
    } else if (difference < 0) {
      return 'Overdue';
    } else {
      return 'Due ${DateFormat('MMM d, yyyy').format(assignment.dueDate)}';
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
              // Title and Checkbox Row
              Row(
                children: [
                  // Completion Checkbox
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Checkbox(
                      value: assignment.isCompleted,
                      onChanged: (_) => onToggleComplete(),
                      activeColor: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                        decoration: assignment.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
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
                    tooltip: 'Edit assignment',
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
                    tooltip: 'Delete assignment',
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
                        Icon(
                          Icons.book_outlined,
                          size: 16,
                          color: const Color(0xFF757575),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            assignment.course,
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
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _getPriorityColor(), width: 1),
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
                      fontWeight: _isOverdue()
                          ? FontWeight.w600
                          : FontWeight.normal,
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

  /// Get due date text color based on urgency
  Color _getDueDateColor() {
    if (_isOverdue()) {
      return const Color(0xFFF44336); // Red for overdue
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      assignment.dueDate.year,
      assignment.dueDate.month,
      assignment.dueDate.day,
    );
    final difference = dueDay.difference(today).inDays;

    if (difference <= 1) {
      return const Color(0xFFFF9800); // Orange for today/tomorrow
    }
    return const Color(0xFF757575); // Gray for future dates
  }

  /// Check if assignment is overdue
  bool _isOverdue() {
    if (assignment.isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      assignment.dueDate.year,
      assignment.dueDate.month,
      assignment.dueDate.day,
    );
    return dueDay.isBefore(today);
  }
}
