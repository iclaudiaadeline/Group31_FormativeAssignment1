import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assignment_provider.dart';
import '../widgets/assignment_card.dart';
import '../widgets/sync_status_indicator.dart';
import 'assignment_form_dialog.dart';
import '../utils/error_handler.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          const SyncStatusIndicator(compact: true),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAssignmentForm(context),
            tooltip: 'Add Assignment',
          ),
        ],
      ),
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading assignments',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.initialize(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (provider.assignments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No assignments yet',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first assignment',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          // Show assignments list sorted by due date
          final sortedAssignments = List.from(provider.assignments)
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedAssignments.length,
            itemBuilder: (context, index) {
              final assignment = sortedAssignments[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AssignmentCard(
                  assignment: assignment,
                  onToggleComplete: () async {
                    await provider.toggleCompletion(assignment.id);
                  },
                  onEdit: () =>
                      _showAssignmentForm(context, assignment: assignment),
                  onDelete: () =>
                      _confirmDelete(context, provider, assignment.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentForm(context),
        tooltip: 'Add Assignment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAssignmentForm(BuildContext context, {assignment}) {
    showDialog(
      context: context,
      builder: (context) => AssignmentFormDialog(assignment: assignment),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AssignmentProvider provider,
    String assignmentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: const Text('Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await provider.deleteAssignment(assignmentId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Assignment deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting assignment: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
