import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    // Initialize with current user
    _user = _authService.currentUser;

    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      print('AuthProvider: Auth state changed, user = ${user?.uid ?? "null"}');
      _user = user;
      notifyListeners();
    });
  }

  /// Initialize auth state listener (called after provider is created)
  void initialize() {
    // Ensure we have the latest auth state
    _user = _authService.currentUser;
    notifyListeners();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required List<String> courses, // Changed to List
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        courses: courses,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    print('AuthProvider: Starting sign out...');

    // First sign out from Firebase
    await _authService.signOut();

    // Then update local state
    _user = null;
    print('AuthProvider: User set to null, isAuthenticated = $isAuthenticated');

    // Force notify listeners immediately
    notifyListeners();
    print('AuthProvider: Listeners notified');

    // Give the UI a moment to rebuild
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get user-friendly error messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}
