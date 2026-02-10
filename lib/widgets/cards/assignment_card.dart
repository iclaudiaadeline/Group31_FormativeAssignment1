import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AssignmentCard extends StatelessWidget {
  final String title;
  final String dueDate;

  const AssignmentCard({
    super.key,
    required this.title,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Due $dueDate", style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
