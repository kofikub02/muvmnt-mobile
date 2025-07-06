import 'package:intl/intl.dart';

/// Extension methods for DateTime class
extension DateTimeExtensions on DateTime {
  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if the date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if the date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if the date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if the date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if the date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if the date is this year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Get the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get the start of the week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday));
  }

  /// Get the end of the week (Sunday)
  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday));
  }

  /// Get the start of the month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// Get the start of the year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31);

  /// Format date as relative time (e.g., "2 hours ago", "3 days ago")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format date as relative time for future dates
  String toRelativeTimeFuture() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays > 0) {
      return 'in ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Now';
    }
  }

  /// Format date with custom pattern
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Format date as short date (MM/dd/yyyy)
  String toShortDate() {
    return DateFormat('MM/dd/yyyy').format(this);
  }

  /// Format date as long date (EEEE, MMMM d, yyyy)
  String toLongDate() {
    return DateFormat('EEEE, MMMM d, yyyy').format(this);
  }

  /// Format date as time (HH:mm)
  String toTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format date as time with seconds (HH:mm:ss)
  String toTimeWithSeconds() {
    return DateFormat('HH:mm:ss').format(this);
  }

  /// Format date as date and time (MM/dd/yyyy HH:mm)
  String toDateTime() {
    return DateFormat('MM/dd/yyyy HH:mm').format(this);
  }

  /// Format date as ISO string
  String toISOString() {
    return toIso8601String();
  }

  /// Get age from birth date
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add days to date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days from date
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add months to date
  DateTime addMonths(int months) {
    final newMonth = month + months;
    final newYear = year + (newMonth - 1) ~/ 12;
    final finalMonth = ((newMonth - 1) % 12) + 1;
    return DateTime(newYear, finalMonth, day);
  }

  /// Subtract months from date
  DateTime subtractMonths(int months) => addMonths(-months);

  /// Add years to date
  DateTime addYears(int years) => DateTime(year + years, month, day);

  /// Subtract years from date
  DateTime subtractYears(int years) => DateTime(year - years, month, day);

  /// Check if date is between two other dates (inclusive)
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start.subtract(const Duration(milliseconds: 1))) &&
        isBefore(end.add(const Duration(milliseconds: 1)));
  }

  /// Get the number of days between this date and another date
  int daysBetween(DateTime other) {
    return difference(other).inDays.abs();
  }

  /// Get the number of months between this date and another date
  int monthsBetween(DateTime other) {
    return ((year - other.year) * 12 + month - other.month).abs();
  }

  /// Get the number of years between this date and another date
  int yearsBetween(DateTime other) {
    return (year - other.year).abs();
  }

  /// Check if the date is a weekend
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Check if the date is a weekday
  bool get isWeekday => !isWeekend;

  /// Get the quarter of the year (1-4)
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Get the week of the year (1-53)
  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final daysSinceStart = difference(startOfYear).inDays;
    return ((daysSinceStart + startOfYear.weekday - 1) ~/ 7) + 1;
  }

  /// Get the day of the year (1-366)
  int get dayOfYear {
    final startOfYear = DateTime(year, 1, 1);
    return difference(startOfYear).inDays + 1;
  }

  /// Check if the year is a leap year
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Get the number of days in the month
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// Get the number of days in the year
  int get daysInYear => isLeapYear ? 366 : 365;

  /// Copy date with new values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
