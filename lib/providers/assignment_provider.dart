import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/assignment.dart';
import '../services/assignment_service.dart';
import '../utils/error_handler.dart';

/// Provider for managing assignment state and operations
/// Extends ChangeNotifier to notify listeners of state changes
class AssignmentProvider extends ChangeNotifier {
  final AssignmentService _service;

  // State fields
  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Assignment>>? _assignmentsSubscription;

  // Getters
  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Constructor with AssignmentService dependency
  AssignmentProvider({required AssignmentService service}) : _service = service;

  /// Initialize the provider and listen to Firestore stream
  /// Should be called when the provider is first created
  void initialize() {
    _setLoading(true);
    _setError(null);

    _assignmentsSubscription = _service.getAssignmentsStream().listen(
      (assignments) {
        _assignments = assignments;
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

  /// Create a new assignment
  /// Shows loading state during creation and handles errors
  Future<void> createAssignment(Assignment assignment) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.createAssignment(assignment);
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

  /// Update an existing assignment
  /// Shows loading state during update and handles errors
  Future<void> updateAssignment(Assignment assignment) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.updateAssignment(assignment);
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

  /// Delete an assignment
  /// Shows loading state during deletion and handles errors
  Future<void> deleteAssignment(String id) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.deleteAssignment(id);
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

  /// Toggle the completion status of an assignment
  /// Shows loading state during toggle and handles errors
  Future<void> toggleCompletion(String id) async {
    _setLoading(true);
    _setError(null);
    notifyListeners();

    try {
      await _service.toggleAssignmentCompletion(id);
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

  /// Get assignments due within the specified number of days
  /// Returns a filtered list from the current assignments
  List<Assignment> getUpcomingAssignments(int days) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return _assignments.where((assignment) {
      return assignment.dueDate.isAfter(
            now.subtract(const Duration(days: 1)),
          ) &&
          assignment.dueDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get the count of pending (incomplete) assignments
  /// Returns the number of assignments where isCompleted is false
  int getPendingCount() {
    return _assignments.where((assignment) => !assignment.isCompleted).length;
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
    _assignmentsSubscription?.cancel();
    super.dispose();
  }
}
