import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../services/auth_service.dart';
import '../config/colors.dart';

/// Profile screen displaying user information and risk status
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  String _getRiskStatus(double attendancePercentage, int pendingAssignments) {
    if (attendancePercentage < 75.0 || pendingAssignments > 5) {
      return 'At Risk';
    } else if (attendancePercentage < 85.0 || pendingAssignments > 3) {
      return 'Moderate';
    } else {
      return 'On Track';
    }
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 75.0) {
      return AppColors.danger; // Red for good (as per mockup)
    } else if (percentage >= 60.0) {
      return AppColors.warning; // Yellow for moderate
    } else {
      return AppColors.danger; // Red for bad
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashboardProvider = context.watch<DashboardProvider>();

    final user = authProvider.user;
    final summary = dashboardProvider.summary;

    final attendancePercentage = summary?.attendancePercentage ?? 0.0;
    final pendingAssignments = summary?.pendingAssignmentsCount ?? 0;
    final riskStatus = _getRiskStatus(attendancePercentage, pendingAssignments);

    // Extract first name from email
    final email = user?.email ?? '';
    final firstName = email.split('@').first.split('.').first;
    final displayName = firstName.isNotEmpty
        ? firstName[0].toUpperCase() + firstName.substring(1)
        : 'User';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back or to dashboard
          },
        ),
        title: const Text(
          'Your Risk Status',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting and Risk Status
            Text(
              'Hello $displayName  $riskStatus',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),

            // Risk Percentage Cards
            Row(
              children: [
                Expanded(
                  child: _RiskPercentCard(
                    percent: '${attendancePercentage.toStringAsFixed(0)}%',
                    label: 'Attendance',
                    color: _getPercentageColor(attendancePercentage),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RiskPercentCard(
                    percent: '60%', // Placeholder - calculate from assignments
                    label: 'Assignment to Sllamment',
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RiskPercentCard(
                    percent: '63%', // Placeholder - calculate average
                    label: 'Avierage Exsite',
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Get Help Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Get Help',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying a risk percentage card
class _RiskPercentCard extends StatelessWidget {
  final String percent;
  final String label;
  final Color color;

  const _RiskPercentCard({
    required this.percent,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            percent,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
