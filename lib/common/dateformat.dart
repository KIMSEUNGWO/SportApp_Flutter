import 'package:intl/intl.dart';

class DateTimeFormatter {

  static String format({required String format, required String dateTime}) {
    final date = DateTime.parse(dateTime);
    return DateFormat(format).format(date);
  }


}