import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RiskWarningBanner extends StatelessWidget {
  const RiskWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "AT RISK WARNING",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
