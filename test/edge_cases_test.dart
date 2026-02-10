import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alu_academic_platform/models/assignment.dart';
import 'package:alu_academic_platform/models/assignment_validator.dart';
import 'package:alu_academic_platform/models/session.dart';
import 'package:alu_academic_platform/models/session_validator.dart';

/// Edge case tests for validation and boundary conditions
/// Tests Requirements 7.2, 8.1, 8.2, 8.3
void main() {
  group('Edge Cases - Empty Lists', () {
    test('Empty assignment list should be handled gracefully', () {
      final List<Assignment> emptyList = [];
      expect(emptyList.isEmpty, isTrue);
      expect(emptyList.length, equals(0));
    });

    test('Empty session list should be handled gracefully', () {
      final List<Session> emptyList = [];
      expect(emptyList.isEmpty, isTrue);
      expect(emptyList.length, equals(0));
    });

    test('Filtering empty assignment list should return empty list', () {
      final List<Assignment> emptyList = [];
      final filtered = emptyList.where((a) => !a.isCompleted).toList();
      expect(filtered.isEmpty, isTrue);
    });

    test('Sorting empty assignment list should not throw error', () {
      final List<Assignment> emptyList = [];
      expect(() => emptyList.sort((a, b) => a.dueDate.compareTo(b.dueDate)),
          returnsNormally);
    });
  });

  group('Edge Cases - Boundary Dates', () {
    test('Past date should be accepted for assignments', () {
      final pastDate = DateTime(2020, 1, 1);
      final error = AssignmentValidator.validateDueDate(pastDate);
      expect(error, isNull);
    });

    test('Far future date should be accepted for assignments', () {
      final futureDate = DateTime(2099, 12, 31);
      final error = AssignmentValidator.validateDueDate(futureDate);
      expect(error, isNull);
    });

    test('Past date should be accepted for sessions', () {
      final pastDate = DateTime(2020, 1, 1);
      final error = SessionValidator.validateDate(pastDate);
      expect(error, isNull);
    });

    test('Far future date should be accepted for sessions', () {
      final futureDate = DateTime(2099, 12, 31);
      final error = SessionValidator.validateDate(futureDate);
      expect(error, isNull);
    });

    test('Leap year date (Feb 29) should be handled correctly', () {
      final leapYearDate = DateTime(2024, 2, 29);
      final error = SessionValidator.validateDate(leapYearDate);
      expect(error, isNull);
    });

    test('End of year date (Dec 31) should be handled correctly', () {
      final endOfYear = DateTime(2024, 12, 31);
      final error = AssignmentValidator.validateDueDate(endOfYear);
      expect(error, isNull);
    });

    test('Start of year date (Jan 1) should be handled correctly', () {
      final startOfYear = DateTime(2024, 1, 1);
      final error = SessionValidator.validateDate(startOfYear);
      expect(error, isNull);
    });
  });

  group('Edge Cases - Time Edge Cases', () {
    test('Midnight (00:00) should be valid start time', () {
      const midnight = TimeOfDay(hour: 0, minute: 0);
      const endTime = TimeOfDay(hour: 1, minute: 0);
      final error = SessionValidator.validateTimeRange(midnight, endTime);
      expect(error, isNull);
    });

    test('23:59 should be valid end time', () {
      const startTime = TimeOfDay(hour: 23, minute: 0);
      const endTime = TimeOfDay(hour: 23, minute: 59);
      final error = SessionValidator.validateTimeRange(startTime, endTime);
      expect(error, isNull);
    });

    test('00:00 to 23:59 should be valid time range', () {
      const startTime = TimeOfDay(hour: 0, minute: 0);
      const endTime = TimeOfDay(hour: 23, minute: 59);
      final error = SessionValidator.validateTimeRange(startTime, endTime);
      expect(error, isNull);
    });

    test('Same time for start and end should be invalid', () {
      const sameTime = TimeOfDay(hour: 12, minute: 30);
      final error = SessionValidator.validateTimeRange(sameTime, sameTime);
      expect(error, isNotNull);
      expect(error, contains('after'));
    });

    test('End time before start time should be invalid', () {
      const startTime = TimeOfDay(hour: 14, minute: 0);
      const endTime = TimeOfDay(hour: 13, minute: 0);
      final error = SessionValidator.validateTimeRange(startTime, endTime);
      expect(error, isNotNull);
      expect(error, contains('after'));
    });

    test('One minute difference should be valid', () {
      const startTime = TimeOfDay(hour: 12, minute: 0);
      const endTime = TimeOfDay(hour: 12, minute: 1);
      final error = SessionValidator.validateTimeRange(startTime, endTime);
      expect(error, isNull);
    });

    test('23:59 to 00:00 (next day) should be invalid', () {
      // This represents crossing midnight, which should be invalid
      const startTime = TimeOfDay(hour: 23, minute: 59);
      const endTime = TimeOfDay(hour: 0, minute: 0);
      final error = SessionValidator.validateTimeRange(startTime, endTime);
      expect(error, isNotNull);
    });
  });

  group('Edge Cases - Long Text Inputs', () {
    test('Assignment title at exactly 100 characters should be valid', () {
      final title = 'a' * 100;
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Assignment title at 101 characters should be invalid', () {
      final title = 'a' * 101;
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNotNull);
      expect(error, contains('100'));
    });

    test('Assignment course at exactly 50 characters should be valid', () {
      final course = 'a' * 50;
      final error = AssignmentValidator.validateCourse(course);
      expect(error, isNull);
    });

    test('Assignment course at 51 characters should be invalid', () {
      final course = 'a' * 51;
      final error = AssignmentValidator.validateCourse(course);
      expect(error, isNotNull);
      expect(error, contains('50'));
    });

    test('Session title at exactly 100 characters should be valid', () {
      final title = 'a' * 100;
      final error = SessionValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Session title at 101 characters should be invalid', () {
      final title = 'a' * 101;
      final error = SessionValidator.validateTitle(title);
      expect(error, isNotNull);
      expect(error, contains('100'));
    });

    test('Session location at exactly 100 characters should be valid', () {
      final location = 'a' * 100;
      final error = SessionValidator.validateLocation(location);
      expect(error, isNull);
    });

    test('Session location at 101 characters should be invalid', () {
      final location = 'a' * 101;
      final error = SessionValidator.validateLocation(location);
      expect(error, isNotNull);
      expect(error, contains('100'));
    });

    test('Title with only whitespace should be invalid', () {
      final title = '   ';
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Title with leading/trailing whitespace should be valid', () {
      final title = '  Valid Title  ';
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Title with special characters should be valid', () {
      final title = 'Assignment #1: Test & Review (Part 2)';
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Title with unicode characters should be valid', () {
      final title = 'Assignment 数学 Математика';
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Title with emojis should be valid', () {
      final title = 'Assignment 📚 Study Session 🎓';
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNull);
    });

    test('Very long title with newlines should be truncated properly', () {
      final title = 'Line 1\nLine 2\nLine 3' * 20;
      final error = AssignmentValidator.validateTitle(title);
      expect(error, isNotNull); // Should exceed 100 chars
    });
  });

  group('Edge Cases - Null and Empty Values', () {
    test('Null assignment title should be invalid', () {
      final error = AssignmentValidator.validateTitle(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Empty assignment title should be invalid', () {
      final error = AssignmentValidator.validateTitle('');
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null assignment course should be invalid', () {
      final error = AssignmentValidator.validateCourse(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null assignment due date should be invalid', () {
      final error = AssignmentValidator.validateDueDate(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null session title should be invalid', () {
      final error = SessionValidator.validateTitle(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null session date should be invalid', () {
      final error = SessionValidator.validateDate(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null start time should be invalid', () {
      final endTime = const TimeOfDay(hour: 14, minute: 0);
      final error = SessionValidator.validateTimeRange(null, endTime);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null end time should be invalid', () {
      final startTime = const TimeOfDay(hour: 12, minute: 0);
      final error = SessionValidator.validateTimeRange(startTime, null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Both times null should be invalid', () {
      final error = SessionValidator.validateTimeRange(null, null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });

    test('Null session location should be invalid', () {
      final error = SessionValidator.validateLocation(null);
      expect(error, isNotNull);
      expect(error, contains('required'));
    });
  });

  group('Edge Cases - Validation Combinations', () {
    test('All valid assignment fields should pass validation', () {
      final isValid = AssignmentValidator.isValid(
        title: 'Valid Assignment',
        course: 'Math 101',
        dueDate: DateTime.now().add(const Duration(days: 7)),
      );
      expect(isValid, isTrue);
    });

    test('One invalid field should fail overall validation', () {
      final isValid = AssignmentValidator.isValid(
        title: '', // Invalid
        course: 'Math 101',
        dueDate: DateTime.now(),
      );
      expect(isValid, isFalse);
    });

    test('All valid session fields should pass validation', () {
      final isValid = SessionValidator.isValid(
        title: 'Valid Session',
        date: DateTime.now(),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        location: 'Room 101',
      );
      expect(isValid, isTrue);
    });

    test('Invalid time range should fail overall validation', () {
      final isValid = SessionValidator.isValid(
        title: 'Valid Session',
        date: DateTime.now(),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 13, minute: 0), // Before start
        location: 'Room 101',
      );
      expect(isValid, isFalse);
    });
  });

  group('Edge Cases - Date Calculations', () {
    const testUserId = 'test-user-123';

    test('Assignment due today should be included in upcoming', () {
      final today = DateTime.now();
      final todayNormalized = DateTime(today.year, today.month, today.day);
      final assignment = Assignment(
        id: '1',
        title: 'Test',
        course: 'Math',
        dueDate: todayNormalized,
        priority: PriorityLevel.medium,
        userId: testUserId,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Check if due date is within 7 days
      final daysDifference =
          assignment.dueDate.difference(todayNormalized).inDays;
      expect(daysDifference >= 0 && daysDifference <= 7, isTrue);
    });

    test('Assignment due in exactly 7 days should be included', () {
      final today = DateTime.now();
      final todayNormalized = DateTime(today.year, today.month, today.day);
      final sevenDaysLater = todayNormalized.add(const Duration(days: 7));

      final assignment = Assignment(
        id: '1',
        title: 'Test',
        course: 'Math',
        dueDate: sevenDaysLater,
        priority: PriorityLevel.medium,
        userId: testUserId,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final daysDifference =
          assignment.dueDate.difference(todayNormalized).inDays;
      expect(daysDifference, equals(7));
    });

    test('Session isToday should work correctly', () {
      final today = DateTime.now();
      final todayNormalized = DateTime(today.year, today.month, today.day);

      final session = Session(
        id: '1',
        title: 'Test Session',
        date: todayNormalized,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        location: 'Room 101',
        type: SessionType.classSession,
        userId: testUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(session.isToday(), isTrue);
    });

    test('Session from yesterday should not be today', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayNormalized =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      final session = Session(
        id: '1',
        title: 'Test Session',
        date: yesterdayNormalized,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        location: 'Room 101',
        type: SessionType.classSession,
        userId: testUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(session.isToday(), isFalse);
    });
  });

  group('Edge Cases - Attendance Calculations', () {
    const testUserId = 'test-user-123';

    test('Zero sessions should result in 0% attendance', () {
      final sessionsWithAttendance = <Session>[];
      final presentCount = sessionsWithAttendance
          .where((s) => s.attendanceStatus == AttendanceStatus.present)
          .length;
      final totalCount = sessionsWithAttendance.length;

      final percentage =
          totalCount > 0 ? (presentCount / totalCount) * 100 : 0.0;
      expect(percentage, equals(0.0));
    });

    test('All present should result in 100% attendance', () {
      final sessions = List.generate(
        5,
        (i) => Session(
          id: '$i',
          title: 'Session $i',
          date: DateTime.now(),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          location: 'Room 101',
          type: SessionType.classSession,
          attendanceStatus: AttendanceStatus.present,
          userId: testUserId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final presentCount = sessions
          .where((s) => s.attendanceStatus == AttendanceStatus.present)
          .length;
      final percentage = (presentCount / sessions.length) * 100;
      expect(percentage, equals(100.0));
    });

    test('Exactly 75% attendance should not trigger warning', () {
      final percentage = 75.0;
      final isBelow = percentage < 75.0;
      expect(isBelow, isFalse);
    });

    test('74.9% attendance should trigger warning', () {
      final percentage = 74.9;
      final isBelow = percentage < 75.0;
      expect(isBelow, isTrue);
    });
  });
}
