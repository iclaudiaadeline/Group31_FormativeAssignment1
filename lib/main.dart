/// Group 31 - Formative Assignment 1
/// ALU Student Academic Platform
///
/// Main entry point for the application.
/// This file handles Firebase initialization, offline persistence setup,
/// and app bootstrapping with error handling.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

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
/// with theme configuration and initial home screen.
///
/// Currently displays a placeholder screen during development.
/// Will be replaced with proper navigation structure in Phase 7.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title shown in task switcher
      title: 'ALU Academic Platform',

      // Theme configuration
      // TODO: Replace with custom ALU theme in Task 3
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // Temporary home screen during setup phase
      // Will be replaced with MainNavigationScreen in Task 18
      home: const Scaffold(
        body: Center(
          child: Text(
            'ALU Academic Platform - Setup in Progress',
            style: TextStyle(fontSize: 18),
          ),
        ),
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
