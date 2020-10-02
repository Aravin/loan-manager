import 'package:jiffy/jiffy.dart';

double calculatePaid(DateTime startDate, double monthlyEmi) {
  Jiffy currTime = Jiffy();
  Jiffy startJiff = Jiffy(startDate);

  int diffInMonth = currTime.diff(startJiff, Units.MONTH);
  return double.parse((diffInMonth * monthlyEmi).toStringAsFixed(2));
}
