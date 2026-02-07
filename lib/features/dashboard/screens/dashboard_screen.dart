import 'package:flutter/material.dart';
import '../../../widgets/cards/stat_card.dart';
import '../../../widgets/banners/risk_warning_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const RiskWarningBanner(),
            const SizedBox(height: 20),
            Row(
              children: const [
                StatCard(value: "4", label: "Active Projects"),
                SizedBox(width: 12),
                StatCard(value: "7", label: "Code Factories"),
                SizedBox(width: 12),
                StatCard(value: "1", label: "Upcoming Exams"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
