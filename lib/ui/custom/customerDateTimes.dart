

import 'package:intl/intl.dart';

class CustomDateTime{
  static String getDate = DateFormat('d MMMM y', 'fr_FR').format(DateTime.now());
  static String getMonth = DateFormat('MMMM y', 'fr_FR').format(DateTime.now());
  static String getDayName = DateFormat('EEEE', 'fr_FR').format(DateTime.now());
  static String getLast7Date = DateFormat('EEEE', 'fr_FR').format(DateTime.now().subtract(Duration(days: 7)));
}