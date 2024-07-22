import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';
class DateTimeFormatter {

  static String format({required String format, required String dateTime}) {
    final date = DateTime.parse(dateTime);
    return DateFormat(format).format(date);
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'time'.tr(gender: 'seconds', args: ['${difference.inSeconds}']);
    } else if (difference.inMinutes < 60) {
      return 'time'.tr(gender: 'minutes', args: ['${difference.inMinutes}']);
    } else if (difference.inHours < 24) {
      return 'time'.tr(gender: 'hours', args: ['${difference.inHours}']);
    } else if (difference.inDays == 1) {
      return '어제 ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return 'time'.tr(gender: 'days', args: ['${difference.inDays}']);
    } else if (difference.inDays < 365) {
      return DateFormat('MM-dd').format(date);
    } else {
      return DateFormat('yy-MM-dd').format(date);
    }
  }


}