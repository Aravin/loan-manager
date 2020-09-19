double calculatePaidPercent(double paid, double payable) {
  if (paid == 0) {
    return 0.0;
  }
  return double.parse(((paid / payable) * 100).toStringAsFixed(2));
}
