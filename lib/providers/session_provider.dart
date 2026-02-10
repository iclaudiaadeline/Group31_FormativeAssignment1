import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../services/session_service.dart';
import '../utils/error_handler.dart';

/// Provider for managing session state and operations
/// Extends ChangeNotifier to notify listeners of state changes
class SessionProvider extends ChangeNotifier {
  final SessionService _service;

  // State fields
  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Session>>? _sessionsSubscription;

  // Getters
  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Constructor with SessionService dependency
  SessionProvider({required SessionService service}) : _service = service;

  /// Initialize the provider and listen to Firestore stream
  /// Should be called when the provider is first created
  void initialize() {
    _setLoading(true);
    _setError(null);

    _sessionsSubscription = _service.getSessionsStream().listen(
      (sessions) {
        _sessions = sessions;
        _setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        _setError(FirestoreErrorHandler.getErrorMessage(error));
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  /// Create a new session
  /// Shows loading state during creation and handles errors
  Future<void> createSession(Session session) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.createSession(session);
      // Stream will automatically update the list
      _setLoading(false);
      // No need to notify here - stream will trigger update
    } catch (e) {
      final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Update an existing session
  /// Shows loading state during update and handles errors
  Future<void> updateSession(Session session) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.updateSession(session);
      // Stream will automatically update the list
      _setLoading(false);
      // No need to notify here - stream will trigger update
    } catch (e) {
      final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a session
  /// Shows loading state during deletion and handles errors
  Future<void> deleteSession(String id) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.deleteSession(id);
      // Stream will automatically update the list
      _setLoading(false);
      // No need to notify here - stream will trigger update
    } catch (e) {
      final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Record attendance for a session
  /// Shows loading state during recording and handles errors
  Future<void> recordAttendance(String id, AttendanceStatus status) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.recordAttendance(id, status);
      // Stream will automatically update the list
      _setLoading(false);
      // No need to notify here - stream will trigger update
    } catch (e) {
      final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
      _setError(errorMessage);
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Get sessions scheduled for today
  /// Returns a filtered list from the current sessions
  List<Session> getTodaySessions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _sessions.where((session) {
      final sessionDate = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );
      return sessionDate.isAtSameMomentAs(today);
    }).toList();
  }

  /// Get sessions for a specific week
  /// Returns sessions between weekStart (inclusive) and weekStart + 7 days (exclusive)
  List<Session> getSessionsForWeek(DateTime weekStart) {
    // Normalize to start of day
    final startOfWeek = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return _sessions.where((session) {
      final sessionDate = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );
      return (sessionDate.isAtSameMomentAs(startOfWeek) ||
              sessionDate.isAfter(startOfWeek)) &&
          sessionDate.isBefore(endOfWeek);
    }).toList();
  }

  /// Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
  }

  /// Helper method to set error state
  void _setError(String? value) {
    _error = value;
  }

  @override
  void dispose() {
    _sessionsSubscription?.cancel();
    super.dispose();
  }
}
