import 'package:intl/intl.dart';

extension FormatDateToVN on DateTime {
  String get formatDayOfWeekVN {
    switch (DateFormat.E().format(this)) {
      case 'Mon':
        return 'Thứ 2';
      case 'Tue':
        return 'Thứ 3';
      case 'Wed':
        return 'Thứ 4';
      case 'Thu':
        return 'Thứ 5';
      case 'Fri':
        return 'Thứ 6';
      case 'Sat':
        return 'Thứ 7';
      case 'Sun':
        return 'Chủ nhật';
      default:
        return 'Thứ 2';
    }
  }
}
