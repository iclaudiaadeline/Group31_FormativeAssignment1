import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer utility to prevent rapid repeated actions
///
/// Useful for preventing double-taps on buttons and rapid form submissions
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Execute the action after the delay period
  /// If called again before the delay expires, the previous call is cancelled
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose of the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler utility to limit action frequency
///
/// Unlike debouncer, throttler executes the first call immediately
/// and ignores subsequent calls until the cooldown period expires
class Throttler {
  final Duration cooldown;
  DateTime? _lastExecutionTime;

  Throttler({this.cooldown = const Duration(milliseconds: 500)});

  /// Execute the action if cooldown period has passed
  /// Returns true if action was executed, false if throttled
  bool run(void Function() action) {
    final now = DateTime.now();

    if (_lastExecutionTime == null ||
        now.difference(_lastExecutionTime!) >= cooldown) {
      _lastExecutionTime = now;
      action();
      return true;
    }

    return false;
  }

  /// Reset the throttler state
  void reset() {
    _lastExecutionTime = null;
  }

  /// Check if action can be executed now
  bool canExecute() {
    if (_lastExecutionTime == null) return true;
    final now = DateTime.now();
    return now.difference(_lastExecutionTime!) >= cooldown;
  }

  /// Get remaining cooldown time in milliseconds
  int getRemainingCooldown() {
    if (_lastExecutionTime == null) return 0;
    final now = DateTime.now();
    final elapsed = now.difference(_lastExecutionTime!).inMilliseconds;
    final remaining = cooldown.inMilliseconds - elapsed;
    return remaining > 0 ? remaining : 0;
  }
}

/// Extension on VoidCallback to add debouncing capability
extension DebouncedCallback on VoidCallback {
  /// Create a debounced version of this callback
  VoidCallback debounced({Duration delay = const Duration(milliseconds: 500)}) {
    final debouncer = Debouncer(delay: delay);
    return () => debouncer.run(this);
  }

  /// Create a throttled version of this callback
  VoidCallback throttled(
      {Duration cooldown = const Duration(milliseconds: 500)}) {
    final throttler = Throttler(cooldown: cooldown);
    return () => throttler.run(this);
  }
}
