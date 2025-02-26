import 'package:intl/intl.dart';

class LocalizationHelper {
  static double parseDouble(String value) {
    try {
      return NumberFormat().parse(value) as double;
    } catch (e) {
      return 0.0;
    }
  }
}
