import 'package:intl/intl.dart';

class TFormatter {
  static String formatChatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final timePart = DateFormat('HH:mm').format(dateTime); // e.g., 2:45 PM

    if (messageDate == today) {
      // Today → just show time
      return timePart;
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday + time
      return 'Yesterday • $timePart';
    } else if (now.difference(dateTime).inDays < 7) {
      // Weekday + time → e.g., Mon • 2:45 PM
      return '${DateFormat.E().format(dateTime)} • $timePart';
    } else if (now.year == dateTime.year) {
      // Month + day + time → e.g., Mar 25 • 2:45 PM
      return '${DateFormat.MMMd().format(dateTime)} • $timePart';
    } else {
      // Full date + time → e.g., Mar 25, 2023 • 2:45 PM
      return '${DateFormat.yMMMd().format(dateTime)} • $timePart';
    }
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('EEE, MMM d').format(date);
  }

  static String formatCurruency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  // static String formatPhoneNumber(String phoneNumber) {

  // }
}
