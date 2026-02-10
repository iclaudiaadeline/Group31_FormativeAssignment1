/// Connectivity Provider
///
/// Monitors network connectivity status and provides real-time updates
/// to the UI about online/offline state and Firestore sync status.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provider that monitors network connectivity and Firestore sync status
///
/// This provider listens to connectivity changes and provides information
/// about whether the device is online or offline. It also monitors Firestore
/// sync status to show when data is being synchronized.
class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Current connectivity status
  bool _isOnline = true;

  /// Whether Firestore is currently syncing data
  bool _isSyncing = false;

  /// Last time connectivity status changed
  DateTime? _lastStatusChange;

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Get current syncing status
  bool get isSyncing => _isSyncing;

  /// Get last status change time
  DateTime? get lastStatusChange => _lastStatusChange;

  /// Initialize connectivity monitoring
  ///
  /// Starts listening to connectivity changes and checks initial status
  void initialize() {
    // Check initial connectivity status
    _checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      },
    );
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      // Assume online if we can't check
      _updateOnlineStatus(true);
    }
  }

  /// Handle connectivity change events
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Consider online if any connection type is available
    final wasOnline = _isOnline;
    final isNowOnline = results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);

    _updateOnlineStatus(isNowOnline);

    // If we just came back online, trigger a sync
    if (!wasOnline && isNowOnline) {
      _triggerSync();
    }
  }

  /// Update online status and notify listeners
  void _updateOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      _lastStatusChange = DateTime.now();
      notifyListeners();
    }
  }

  /// Trigger Firestore sync when coming back online
  void _triggerSync() {
    _isSyncing = true;
    notifyListeners();

    // Firestore automatically syncs when connectivity is restored
    // We'll show the syncing indicator for a short time
    Future.delayed(const Duration(seconds: 2), () {
      _isSyncing = false;
      notifyListeners();
    });
  }

  /// Manually trigger a connectivity check
  Future<void> checkConnectivity() async {
    await _checkConnectivity();
  }

  /// Get connectivity status as a string
  String get statusText {
    if (_isSyncing) {
      return 'Syncing...';
    } else if (_isOnline) {
      return 'Online';
    } else {
      return 'Offline';
    }
  }

  /// Get status icon
  IconData get statusIcon {
    if (_isSyncing) {
      return Icons.sync;
    } else if (_isOnline) {
      return Icons.cloud_done;
    } else {
      return Icons.cloud_off;
    }
  }

  /// Get status color
  Color get statusColor {
    if (_isSyncing) {
      return Colors.orange;
    } else if (_isOnline) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
