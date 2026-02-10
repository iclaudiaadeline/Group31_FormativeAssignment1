import 'package:flutter_test/flutter_test.dart';
import 'package:alu_academic_platform/utils/text_utils.dart';
import 'package:alu_academic_platform/utils/debouncer.dart';

/// Tests for utility functions
/// Tests Requirements 7.2, 8.1, 8.2, 8.3
void main() {
  group('TextUtils - Truncation', () {
    test('Text shorter than max length should not be truncated', () {
      final result = TextUtils.truncate('Short text', 20);
      expect(result, equals('Short text'));
    });

    test('Text equal to max length should not be truncated', () {
      final text = 'a' * 20;
      final result = TextUtils.truncate(text, 20);
      expect(result, equals(text));
    });

    test('Text longer than max length should be truncated with ellipsis', () {
      final text = 'This is a very long text that needs truncation';
      final result = TextUtils.truncate(text, 20);
      expect(result.length, equals(20));
      expect(result.endsWith('...'), isTrue);
    });

    test('Truncate for card should limit to 50 characters', () {
      final text = 'a' * 100;
      final result = TextUtils.truncateForCard(text);
      expect(result.length, equals(50));
    });

    test('Truncate for list should limit to 80 characters', () {
      final text = 'a' * 100;
      final result = TextUtils.truncateForList(text);
      expect(result.length, equals(80));
    });
  });

  group('TextUtils - Sanitization', () {
    test('Sanitize should trim leading whitespace', () {
      final result = TextUtils.sanitize('  text');
      expect(result, equals('text'));
    });

    test('Sanitize should trim trailing whitespace', () {
      final result = TextUtils.sanitize('text  ');
      expect(result, equals('text'));
    });

    test('Sanitize should trim both leading and trailing whitespace', () {
      final result = TextUtils.sanitize('  text  ');
      expect(result, equals('text'));
    });

    test('Sanitize should preserve internal whitespace', () {
      final result = TextUtils.sanitize('  hello world  ');
      expect(result, equals('hello world'));
    });
  });

  group('TextUtils - Empty Checks', () {
    test('isEmpty should return true for null', () {
      expect(TextUtils.isEmpty(null), isTrue);
    });

    test('isEmpty should return true for empty string', () {
      expect(TextUtils.isEmpty(''), isTrue);
    });

    test('isEmpty should return true for whitespace only', () {
      expect(TextUtils.isEmpty('   '), isTrue);
    });

    test('isEmpty should return false for non-empty text', () {
      expect(TextUtils.isEmpty('text'), isFalse);
    });

    test('isOnlyWhitespace should detect whitespace-only strings', () {
      expect(TextUtils.isOnlyWhitespace('   '), isTrue);
      expect(TextUtils.isOnlyWhitespace('\t\n'), isTrue);
      expect(TextUtils.isOnlyWhitespace('text'), isFalse);
    });
  });

  group('TextUtils - Formatting', () {
    test('formatForDisplay should return text when valid', () {
      final result = TextUtils.formatForDisplay('Valid text');
      expect(result, equals('Valid text'));
    });

    test('formatForDisplay should return default for null', () {
      final result = TextUtils.formatForDisplay(null);
      expect(result, equals('N/A'));
    });

    test('formatForDisplay should return default for empty', () {
      final result = TextUtils.formatForDisplay('');
      expect(result, equals('N/A'));
    });

    test('formatForDisplay should use custom default value', () {
      final result = TextUtils.formatForDisplay(null, defaultValue: 'No data');
      expect(result, equals('No data'));
    });
  });

  group('TextUtils - Length Validation', () {
    test('isWithinLength should return true for null', () {
      expect(TextUtils.isWithinLength(null, 10), isTrue);
    });

    test('isWithinLength should return true when within limit', () {
      expect(TextUtils.isWithinLength('short', 10), isTrue);
    });

    test('isWithinLength should return true when equal to limit', () {
      expect(TextUtils.isWithinLength('exactly10!', 10), isTrue);
    });

    test('isWithinLength should return false when exceeding limit', () {
      expect(TextUtils.isWithinLength('this is too long', 10), isFalse);
    });

    test('getCharacterCount should format correctly', () {
      expect(TextUtils.getCharacterCount('hello', 10), equals('5/10'));
      expect(TextUtils.getCharacterCount(null, 10), equals('0/10'));
      expect(TextUtils.getCharacterCount('', 10), equals('0/10'));
    });
  });

  group('TextUtils - Whitespace Normalization', () {
    test('normalizeWhitespace should replace multiple spaces with single', () {
      final result = TextUtils.normalizeWhitespace('hello    world');
      expect(result, equals('hello world'));
    });

    test('normalizeWhitespace should replace tabs with spaces', () {
      final result = TextUtils.normalizeWhitespace('hello\t\tworld');
      expect(result, equals('hello world'));
    });

    test('normalizeWhitespace should replace newlines with spaces', () {
      final result = TextUtils.normalizeWhitespace('hello\n\nworld');
      expect(result, equals('hello world'));
    });

    test('normalizeWhitespace should trim result', () {
      final result = TextUtils.normalizeWhitespace('  hello  world  ');
      expect(result, equals('hello world'));
    });
  });

  group('TextUtils - Capitalization', () {
    test('capitalizeWords should capitalize each word', () {
      final result = TextUtils.capitalizeWords('hello world');
      expect(result, equals('Hello World'));
    });

    test('capitalizeWords should handle mixed case', () {
      final result = TextUtils.capitalizeWords('hELLo WoRLd');
      expect(result, equals('Hello World'));
    });

    test('capitalizeFirst should capitalize only first letter', () {
      final result = TextUtils.capitalizeFirst('hello world');
      expect(result, equals('Hello world'));
    });

    test('capitalizeFirst should handle empty string', () {
      final result = TextUtils.capitalizeFirst('');
      expect(result, equals(''));
    });
  });

  group('Throttler - Rapid Action Prevention', () {
    test('Throttler should execute first action immediately', () {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 100));
      var executionCount = 0;

      final executed = throttler.run(() => executionCount++);

      expect(executed, isTrue);
      expect(executionCount, equals(1));
    });

    test('Throttler should block rapid subsequent actions', () {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 100));
      var executionCount = 0;

      throttler.run(() => executionCount++);
      final blocked = throttler.run(() => executionCount++);

      expect(blocked, isFalse);
      expect(executionCount, equals(1));
    });

    test('Throttler should allow action after cooldown', () async {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 50));
      var executionCount = 0;

      throttler.run(() => executionCount++);
      await Future.delayed(const Duration(milliseconds: 60));
      final executed = throttler.run(() => executionCount++);

      expect(executed, isTrue);
      expect(executionCount, equals(2));
    });

    test('Throttler canExecute should return correct state', () {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 100));

      expect(throttler.canExecute(), isTrue);
      throttler.run(() {});
      expect(throttler.canExecute(), isFalse);
    });

    test('Throttler reset should allow immediate execution', () {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 100));
      var executionCount = 0;

      throttler.run(() => executionCount++);
      throttler.reset();
      final executed = throttler.run(() => executionCount++);

      expect(executed, isTrue);
      expect(executionCount, equals(2));
    });

    test('Throttler getRemainingCooldown should return correct value', () {
      final throttler = Throttler(cooldown: const Duration(milliseconds: 100));

      expect(throttler.getRemainingCooldown(), equals(0));
      throttler.run(() {});
      expect(throttler.getRemainingCooldown(), greaterThan(0));
    });
  });

  group('Debouncer - Delayed Execution', () {
    test('Debouncer should delay execution', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      var executed = false;

      debouncer.run(() => executed = true);

      expect(executed, isFalse);
      await Future.delayed(const Duration(milliseconds: 60));
      expect(executed, isTrue);
    });

    test('Debouncer should cancel previous call when called again', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      var executionCount = 0;

      debouncer.run(() => executionCount++);
      await Future.delayed(const Duration(milliseconds: 20));
      debouncer.run(() => executionCount++);
      await Future.delayed(const Duration(milliseconds: 60));

      expect(executionCount, equals(1)); // Only second call should execute
    });

    test('Debouncer cancel should prevent execution', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      var executed = false;

      debouncer.run(() => executed = true);
      debouncer.cancel();
      await Future.delayed(const Duration(milliseconds: 60));

      expect(executed, isFalse);
    });

    test('Debouncer dispose should cancel pending actions', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      var executed = false;

      debouncer.run(() => executed = true);
      debouncer.dispose();
      await Future.delayed(const Duration(milliseconds: 60));

      expect(executed, isFalse);
    });
  });
}
