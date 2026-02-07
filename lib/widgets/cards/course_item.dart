import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CourseItem extends StatelessWidget {
  final String title;

  const CourseItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
