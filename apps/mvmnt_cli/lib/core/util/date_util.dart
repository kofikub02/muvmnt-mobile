import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('EEE, MMM d').format(date);
}
