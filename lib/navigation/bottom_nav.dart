import 'package:flutter/material.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/assignments/screens/assignments_screen.dart';
import '../features/announcements/screens/announcements_screen.dart';
import '../features/risk/screens/risk_status_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AssignmentsScreen(),
    AnnouncementsScreen(),
    RiskStatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "Assignments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), label: "Announcements"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Risk"),
        ],
      ),
    );
  }
}
