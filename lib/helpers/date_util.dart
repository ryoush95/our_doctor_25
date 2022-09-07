// date formate
import 'package:intl/intl.dart';

String convertDateFromStr(String input, String inFormat, String outFormat) {
  DateFormat inDateFormat = DateFormat(inFormat);
  DateFormat outDateFormat = DateFormat(outFormat);

  DateTime dateTime = inDateFormat.parse(input);
  String output = outDateFormat.format(dateTime);
  return output;
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}
