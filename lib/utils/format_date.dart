import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final durationSinceDateTime = DateTime.now().difference(dateTime);
  if (durationSinceDateTime < Duration(days: 1)) {
    return DateFormat.jm().format(dateTime);
  }
  if (durationSinceDateTime < Duration(days: 2)) {
    return 'Yesterday';
  }
  return DateFormat.yMd().format(dateTime);
}
