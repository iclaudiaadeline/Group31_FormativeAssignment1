import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Widget to display session type with icon and consistent styling
class SessionTypeBadge extends StatelessWidget {
  final String sessionType;

  const SessionTypeBadge({super.key, required this.sessionType});

  String _getDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'classsession':
        return 'Class';
      case 'masterysession':
        return 'Mastery';
      case 'studygroup':
        return 'Study Group';
      case 'pslmeeting':
        return 'PSL Meeting';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getSessionTypeColor(sessionType);
    final icon = AppTheme.getSessionTypeIcon(sessionType);
    final displayName = _getDisplayName(sessionType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
