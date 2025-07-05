/// Extension methods for String class
extension StringExtensions on String {
  /// Check if the string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if the string is not null and not empty
  bool get isNotNullOrEmpty => !isEmpty;

  /// Check if the string is null, empty, or contains only whitespace
  bool get isNullOrWhitespace => trim().isEmpty;

  /// Check if the string is not null, not empty, and not only whitespace
  bool get isNotNullOrWhitespace => trim().isNotEmpty;

  /// Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize the first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert string to camelCase
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s\-_]'));
    if (words.length == 1) return words[0].toLowerCase();
    return words[0].toLowerCase() +
        words.skip(1).map((word) => word.capitalize).join();
  }

  /// Convert string to snake_case
  String get toSnakeCase {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'[\s\-]'), '_').toLowerCase();
  }

  /// Convert string to kebab-case
  String get toKebabCase {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'[\s_]'), '-').toLowerCase();
  }

  /// Convert string to PascalCase
  String get toPascalCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s\-_]'));
    return words.map((word) => word.capitalize).join();
  }

  /// Remove all whitespace from the string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove extra whitespace and normalize spaces
  String get normalizeWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Reverse the string
  String get reversed => split('').reversed.join();

  /// Check if the string is a valid email
  bool get isEmail {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is a valid phone number
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(removeWhitespace);
  }

  /// Check if the string is a valid URL
  bool get isUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Check if the string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Check if the string is an integer
  bool get isInteger {
    return int.tryParse(this) != null;
  }

  /// Check if the string contains only letters
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if the string contains only letters and numbers
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Check if the string is a palindrome
  bool get isPalindrome {
    final clean = toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return clean == clean.reversed;
  }

  /// Truncate string to specified length with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Truncate string to specified length at word boundary
  String truncateWords(int maxWords, {String suffix = '...'}) {
    final words = split(' ');
    if (words.length <= maxWords) return this;
    return '${words.take(maxWords).join(' ')}$suffix';
  }

  /// Extract numbers from string
  String get extractNumbers {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Extract letters from string
  String get extractLetters {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Extract alphanumeric characters from string
  String get extractAlphanumeric {
    return replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Count occurrences of a substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    return split(substring).length - 1;
  }

  /// Check if string contains any of the provided values
  bool containsAny(List<String> values) {
    return values.any((value) => contains(value));
  }

  /// Check if string contains all of the provided values
  bool containsAll(List<String> values) {
    return values.every((value) => contains(value));
  }

  /// Remove specified characters from string
  String removeCharacters(String characters) {
    return replaceAll(RegExp('[$characters]'), '');
  }

  /// Keep only specified characters in string
  String keepCharacters(String characters) {
    return replaceAll(RegExp('[^$characters]'), '');
  }

  /// Wrap string to specified width
  List<String> wrap(int width) {
    if (length <= width) return [this];

    final words = split(' ');
    final lines = <String>[];
    String currentLine = '';

    for (final word in words) {
      if ((currentLine + word).length <= width) {
        currentLine += (currentLine.isEmpty ? '' : ' ') + word;
      } else {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  /// Convert string to list of characters
  List<String> get toCharacters => split('');

  /// Get the first character of the string
  String get firstChar => isEmpty ? '' : this[0];

  /// Get the last character of the string
  String get lastChar => isEmpty ? '' : this[length - 1];

  /// Remove first character from string
  String get removeFirstChar => isEmpty ? this : substring(1);

  /// Remove last character from string
  String get removeLastChar => isEmpty ? this : substring(0, length - 1);

  /// Get substring from start to specified index
  String substringTo(int endIndex) {
    if (endIndex < 0) endIndex = 0;
    if (endIndex > length) endIndex = length;
    return substring(0, endIndex);
  }

  /// Get substring from specified index to end
  String substringFrom(int startIndex) {
    if (startIndex < 0) startIndex = 0;
    if (startIndex > length) return '';
    return substring(startIndex);
  }

  /// Check if string starts with any of the provided values
  bool startsWithAny(List<String> values) {
    return values.any((value) => startsWith(value));
  }

  /// Check if string ends with any of the provided values
  bool endsWithAny(List<String> values) {
    return values.any((value) => endsWith(value));
  }

  /// Convert string to boolean
  bool get toBool {
    final lower = toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'yes' || lower == 'on';
  }

  /// Convert string to int with fallback
  int toInt({int fallback = 0}) {
    return int.tryParse(this) ?? fallback;
  }

  /// Convert string to double with fallback
  double toDouble({double fallback = 0.0}) {
    return double.tryParse(this) ?? fallback;
  }

  /// Convert string to DateTime with fallback
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (_) {
      return null;
    }
  }

  /// Mask string (e.g., for credit card numbers)
  String mask({
    int visibleStart = 4,
    int visibleEnd = 4,
    String maskChar = '*',
  }) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final maskedLength = length - visibleStart - visibleEnd;
    final masked = maskChar * maskedLength;

    return '$start$masked$end';
  }
}
