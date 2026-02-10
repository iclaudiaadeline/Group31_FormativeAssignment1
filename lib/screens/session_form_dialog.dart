import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session.dart';
import '../models/session_validator.dart';
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/error_handler.dart';

/// Dialog for creating or editing a session
class SessionFormDialog extends StatefulWidget {
  final Session? session;

  const SessionFormDialog({super.key, this.session});

  @override
  State<SessionFormDialog> createState() => _SessionFormDialogState();
}

class _SessionFormDialogState extends State<SessionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCourse; // Added course selection
  List<String> _userCourses = []; // User's enrolled courses
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  SessionType _selectedType = SessionType.classSession;

  bool _isLoading = false;
  bool _isLoadingCourses = true;
  String? _dateError;
  String? _startTimeError;
  String? _endTimeError;
  String? _timeRangeError;

  @override
  void initState() {
    super.initState();
    _loadUserCourses();

    // If editing, populate fields with existing session data
    if (widget.session != null) {
      _titleController.text = widget.session!.title;
      _selectedCourse = widget.session!.course;
      _locationController.text = widget.session!.location;
      _selectedDate = widget.session!.date;
      _selectedStartTime = widget.session!.startTime;
      _selectedEndTime = widget.session!.endTime;
      _selectedType = widget.session!.type;
    }
  }

  Future<void> _loadUserCourses() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

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
    _locationController.dispose();
    super.dispose();
  }

  /// Show date picker dialog
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateError = SessionValidator.validateDate(_selectedDate);
        _validateTimeRange();
      });
    }
  }

  /// Show time picker dialog for start time
  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
        _startTimeError = null;
        _validateTimeRange();
      });
    }
  }

  /// Show time picker dialog for end time
  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ??
          TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 1) % 24),
    );

    if (picked != null) {
      setState(() {
        _selectedEndTime = picked;
        _endTimeError = null;
        _validateTimeRange();
      });
    }
  }

  /// Validate time range
  void _validateTimeRange() {
    setState(() {
      _timeRangeError = SessionValidator.validateTimeRange(
        _selectedStartTime,
        _selectedEndTime,
      );
    });
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  /// Format time for display
  String _formatTime(TimeOfDay time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Get session type label
  String _getSessionTypeLabel(SessionType type) {
    switch (type) {
      case SessionType.classSession:
        return 'Class';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }

  /// Validate and save the form
  Future<void> _saveSession() async {
    // Validate text fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate date and time fields
    setState(() {
      _dateError = SessionValidator.validateDate(_selectedDate);
      _startTimeError =
          _selectedStartTime == null ? 'Start time is required' : null;
      _endTimeError = _selectedEndTime == null ? 'End time is required' : null;
      _timeRangeError = SessionValidator.validateTimeRange(
        _selectedStartTime,
        _selectedEndTime,
      );
    });

    // Check if all validations pass
    if (_dateError != null ||
        _startTimeError != null ||
        _endTimeError != null ||
        _timeRangeError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<SessionProvider>();
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.user?.uid ?? '';
      final now = DateTime.now();

      final session = Session(
        id: widget.session?.id ?? '',
        title: _titleController.text.trim(),
        course: _selectedCourse!, // Added course field
        date: _selectedDate!,
        startTime: _selectedStartTime!,
        endTime: _selectedEndTime!,
        location: _locationController.text.trim(),
        type: _selectedType,
        attendanceStatus: widget.session?.attendanceStatus,
        userId: widget.session?.userId ?? userId,
        createdAt: widget.session?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.session == null) {
        // Create new session
        await provider.createSession(session);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session created successfully')),
          );
        }
      } else {
        // Update existing session
        await provider.updateSession(session);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session updated successfully')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final errorMessage = FirestoreErrorHandler.getErrorMessage(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _saveSession,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Title
                Text(
                  widget.session == null ? 'Add Session' : 'Edit Session',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 24),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter session title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: SessionValidator.validateTitle,
                  enabled: !_isLoading,
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
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() => _selectedCourse = value);
                          },
                  ),
                const SizedBox(height: 16),

                // Date Field
                InkWell(
                  onTap: _isLoading ? null : _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                      errorText: _dateError,
                    ),
                    child: Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: _selectedDate != null
                            ? const Color(0xFF212121)
                            : const Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Start Time Field
                InkWell(
                  onTap: _isLoading ? null : _selectStartTime,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.access_time),
                      errorText: _startTimeError,
                    ),
                    child: Text(
                      _selectedStartTime != null
                          ? _formatTime(_selectedStartTime!)
                          : 'Select start time',
                      style: TextStyle(
                        color: _selectedStartTime != null
                            ? const Color(0xFF212121)
                            : const Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // End Time Field
                InkWell(
                  onTap: _isLoading ? null : _selectEndTime,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.access_time),
                      errorText: _endTimeError ?? _timeRangeError,
                    ),
                    child: Text(
                      _selectedEndTime != null
                          ? _formatTime(_selectedEndTime!)
                          : 'Select end time',
                      style: TextStyle(
                        color: _selectedEndTime != null
                            ? const Color(0xFF212121)
                            : const Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Location Field
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: SessionValidator.validateLocation,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Session Type Dropdown
                DropdownButtonFormField<SessionType>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Session Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: SessionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getSessionTypeLabel(type)),
                    );
                  }).toList(),
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    // Save Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003DA5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(widget.session == null ? 'Create' : 'Save'),
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
}
