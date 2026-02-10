/// Group 31 - Formative Assignment 1
/// ALU Student Academic Platform
///
/// Main entry point for the application.
/// This file handles Firebase initialization, offline persistence setup,
/// and app bootstrapping with error handling.
library;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'providers/assignment_provider.dart';
import 'providers/session_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/auth_provider.dart';
import 'services/assignment_service.dart';
import 'services/session_service.dart';
import 'services/attendance_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/login_screen.dart';

/// Application entry point
///
/// Initializes Flutter bindings, Firebase, and Firestore settings before
/// launching the app. Handles initialization errors gracefully by displaying
/// an error screen if Firebase setup fails.
void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with platform-specific configuration
    // This connects the app to the Firebase project
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Firestore offline persistence for better user experience
    // This allows the app to work without internet connection
    // and automatically syncs data when connectivity is restored
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Launch the main application
    runApp(const MainApp());
  } catch (e) {
    // If Firebase initialization fails, show error screen
    // This prevents the app from crashing and provides useful feedback
    runApp(ErrorApp(error: e.toString()));
  }
}

/// Main application widget
///
/// This is the root widget of the application. It sets up the MaterialApp
/// with theme configuration, state management providers, and navigation.
///
/// Uses MultiProvider to inject all necessary providers into the widget tree,
/// making them available to all screens and widgets in the app.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final assignmentService = AssignmentService();
    final sessionService = SessionService();
    final attendanceService = AttendanceService();

    return MultiProvider(
      providers: [
        // Authentication provider (must be first)
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        // Connectivity monitoring provider
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..initialize(),
        ),
        // Assignment management provider
        ChangeNotifierProvider(
          create: (_) =>
              AssignmentProvider(service: assignmentService)..initialize(),
        ),
        // Session scheduling provider
        ChangeNotifierProvider(
          create: (_) => SessionProvider(service: sessionService)..initialize(),
        ),
        // Dashboard aggregation provider
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            assignmentService: assignmentService,
            sessionService: sessionService,
            attendanceService: attendanceService,
          )..loadDashboard(),
        ),
      ],
      child: MaterialApp(
        // Application title shown in task switcher
        title: 'ALU Academic Platform',

        // Theme configuration with ALU branding
        theme: AppTheme.buildALUTheme(),

        // Start with login screen, then navigate to main app
        home: const AuthWrapper(),

        // Remove debug banner in release mode
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Main navigation screen with bottom navigation bar
///
/// This widget manages the main navigation structure of the app using
/// a bottom navigation bar with three tabs: Dashboard, Assignments, and Schedule.
///
/// Uses IndexedStack to preserve the state of each screen when switching tabs,
/// ensuring that user input and scroll positions are maintained.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  // Current selected tab index
  int _currentIndex = 0;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      // Restart animation for smooth transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  // List of screens corresponding to each tab
  // Using IndexedStack preserves state when switching tabs
  final List<Widget> _screens = const [
    DashboardScreen(),
    AssignmentsScreen(),
    ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the current screen based on selected tab
      // IndexedStack keeps all screens in memory to preserve state
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),

      // Bottom navigation bar with three tabs
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}

/// Error screen displayed when Firebase initialization fails
///
/// This widget provides user-friendly error feedback if Firebase
/// cannot be initialized. It displays the error message and an
/// error icon to help with debugging.
///
/// Common causes of initialization errors:
/// - Missing firebase_options.dart configuration
/// - Invalid Firebase project credentials
/// - Network connectivity issues during first launch
class ErrorApp extends StatelessWidget {
  /// The error message to display
  final String error;

  /// Creates an error app with the given error message
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),

                // Error title
                const Text(
                  'Firebase Initialization Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Error message details
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),

                // Help text
                const Text(
                  'Please check FIREBASE_SETUP.md for configuration instructions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Auth wrapper to handle authentication state
///
/// Shows login screen if not authenticated, otherwise shows main app
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show main app if authenticated
        if (authProvider.isAuthenticated) {
          return const MainNavigationScreen();
        }

        // Show login screen if not authenticated
        return const LoginScreen();
      },
    );
  }
}
