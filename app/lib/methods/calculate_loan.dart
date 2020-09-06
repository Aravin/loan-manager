import 'dart:math';

double calculateEmi(double amount, int tenure, double interest) {
  interest = interest / 12 / 100;
  return double.parse((amount *
          interest *
          (pow(1 + interest, tenure)) /
          (pow(1 + interest, tenure) - 1))
      .toStringAsFixed(2));
}
