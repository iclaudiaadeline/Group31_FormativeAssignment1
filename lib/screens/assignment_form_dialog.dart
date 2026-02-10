import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';
import '../models/assignment_validator.dart';
import '../providers/assignment_provider.dart';
import '../utils/error_handler.dart';

class AssignmentFormDialog extends StatefulWidget {
  final Assignment? assignment;

  const AssignmentFormDialog({super.key, this.assignment});

  @override
  State<AssignmentFormDialog> createState() => _AssignmentFormDialogState();
}

class _AssignmentFormDialogState extends State<AssignmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String? _selectedCourse; // Changed to dropdown selection
  List<String> _userCourses = []; // User's enrolled courses
  DateTime? _selectedDueDate;
  PriorityLevel _selectedPriority = PriorityLevel.medium;
  bool _isSubmitting = false;
  bool _isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadUserCourses();

    // Pre-fill form if editing existing assignment
    if (widget.assignment != null) {
      _titleController.text = widget.assignment!.title;
      _selectedCourse = widget.assignment!.course;
      _selectedDueDate = widget.assignment!.dueDate;
      _selectedPriority = widget.assignment!.priority;
    }
  }

  Future<void> _loadUserCourses() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data()?['courses'] != null) {
          setState(() {
            _userCourses = List<String>.from(userDoc.data()!['courses']);
            _isLoadingCourses = false;
          });
        } else {
          setState(() {
            _isLoadingCourses = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingCourses = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.assignment != null;

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dialog title
                Text(
                  isEditing ? 'Edit Assignment' : 'New Assignment',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter assignment title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                      AssignmentValidator.validateTitle(value),
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 100,
                ),
                const SizedBox(height: 16),

                // Course dropdown
                if (_isLoadingCourses)
                  const Center(child: CircularProgressIndicator())
                else if (_userCourses.isEmpty)
                  const Text(
                    'No courses found. Please add courses in your profile.',
                    style: TextStyle(color: Colors.orange),
                  )
                else
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCourse,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book),
                    ),
                    hint: const Text('Select course'),
                    items: _userCourses.map((course) {
                      return DropdownMenuItem(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a course';
                      }
                      return null;
                    },
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() => _selectedCourse = value);
                          },
                  ),
                const SizedBox(height: 16),

                // Due date picker
                InkWell(
                  onTap: _isSubmitting ? null : _selectDueDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                      errorText: _selectedDueDate == null &&
                              _formKey.currentState?.validate() == false
                          ? AssignmentValidator.validateDueDate(null)
                          : null,
                    ),
                    child: Text(
                      _selectedDueDate != null
                          ? DateFormat(
                              'EEEE, MMMM d, yyyy',
                            ).format(_selectedDueDate!)
                          : 'Select due date',
                      style: TextStyle(
                        color: _selectedDueDate != null
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority dropdown
                DropdownButtonFormField<PriorityLevel>(
                  initialValue: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: PriorityLevel.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: _getPriorityColor(priority),
                          ),
                          const SizedBox(width: 8),
                          Text(_formatPriority(priority)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedPriority = value);
                          }
                        },
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Update' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDueDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  Future<void> _submitForm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate due date separately since it's not a TextFormField
    if (_selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final provider = context.read<AssignmentProvider>();
      final now = DateTime.now();

      if (widget.assignment != null) {
        // Update existing assignment
        final updatedAssignment = widget.assignment!.copyWith(
          title: _titleController.text.trim(),
          course: _selectedCourse!,
          dueDate: _selectedDueDate,
          priority: _selectedPriority,
          updatedAt: now,
        );

        await provider.updateAssignment(updatedAssignment);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assignment updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new assignment
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You must be logged in to create assignments'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final newAssignment = Assignment(
          id: '', // Will be generated by Firestore
          title: _titleController.text.trim(),
          course: _selectedCourse!,
          dueDate: _selectedDueDate!,
          priority: _selectedPriority,
          isCompleted: false,
          userId: currentUser.uid,
          createdAt: now,
          updatedAt: now,
        );

        await provider.createAssignment(newAssignment);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assignment created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _submitForm,
            ),
          ),
        );
      }
    }
  }

  Color _getPriorityColor(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.high:
        return Colors.red;
      case PriorityLevel.medium:
        return Colors.orange;
      case PriorityLevel.low:
        return Colors.green;
    }
  }

  String _formatPriority(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.high:
        return 'High';
      case PriorityLevel.medium:
        return 'Medium';
      case PriorityLevel.low:
        return 'Low';
    }
  }
}
