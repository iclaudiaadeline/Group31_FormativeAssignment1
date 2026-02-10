/// Sync Status Indicator Widget
///
/// Displays the current connectivity and sync status in the AppBar
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';

/// Widget that displays sync status in the AppBar
///
/// Shows an icon and optional text indicating whether the app is:
/// - Online (cloud_done icon, green)
/// - Offline (cloud_off icon, red)
/// - Syncing (sync icon, orange, animated)
class SyncStatusIndicator extends StatelessWidget {
  /// Whether to show the status text alongside the icon
  final bool showText;

  /// Whether to show as a badge (compact mode)
  final bool compact;

  const SyncStatusIndicator({
    super.key,
    this.showText = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (compact) {
          return _buildCompactIndicator(connectivity);
        } else {
          return _buildFullIndicator(connectivity);
        }
      },
    );
  }

  /// Build compact indicator (just icon with badge)
  Widget _buildCompactIndicator(ConnectivityProvider connectivity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            connectivity.statusIcon,
            color: connectivity.statusColor,
            size: 24,
          ),
          if (connectivity.isSyncing)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  /// Build full indicator with icon and optional text
  Widget _buildFullIndicator(ConnectivityProvider connectivity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                connectivity.statusIcon,
                color: connectivity.statusColor,
                size: 20,
              ),
              if (connectivity.isSyncing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
            ],
          ),
          if (showText) ...[
            const SizedBox(width: 6),
            Text(
              connectivity.statusText,
              style: TextStyle(
                color: connectivity.statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Offline badge widget
///
/// Displays a prominent "Offline" badge when the device is disconnected
class OfflineBadge extends StatelessWidget {
  const OfflineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (connectivity.isOnline) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Offline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Syncing indicator widget
///
/// Shows a syncing message when data is being synchronized
class SyncingIndicator extends StatelessWidget {
  const SyncingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (!connectivity.isSyncing) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Syncing...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
