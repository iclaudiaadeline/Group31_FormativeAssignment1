import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Widget to display attendance percentage with progress indicator
///
/// Shows warning icon and red color if below 75%
/// Shows success icon and green color if >= 75%
class AttendanceStatusWidget extends StatelessWidget {
  final double attendancePercentage;
  final bool showLabel;

  const AttendanceStatusWidget({
    super.key,
    required this.attendancePercentage,
    this.showLabel = true,
  });

  bool get isBelowThreshold => attendancePercentage < 75.0;

  @override
  Widget build(BuildContext context) {
    final color = isBelowThreshold ? AppColors.danger : Colors.green;
    final icon = isBelowThreshold ? Icons.warning : Icons.check_circle;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                '${attendancePercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (showLabel)
                Text(
                  isBelowThreshold ? 'AT RISK' : 'ON TRACK',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: attendancePercentage / 100,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          if (isBelowThreshold) ...[
            const SizedBox(height: 8),
            Text(
              'Your attendance is below 75%. Please attend more sessions.',
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
