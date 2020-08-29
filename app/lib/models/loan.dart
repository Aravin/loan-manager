import 'dart:ffi';

class Loan {
  final String loanType;
  final String nickname;
  final String loanAmount;
  final Float interest;
  final Int16 tenure;
  final DateTime startDate;

  // optional fields
  final String accountNumber;
  final String bankName;
  final String phone;
  final String email;
  final String contactPerson;
  final String additionalInfo;

  final String processingFee;
  final String otherCharges;
  final String partPayment;
  final String advancePayment;

  Loan(
    this.loanType,
    this.nickname,
    this.loanAmount,
    this.interest,
    this.tenure,
    this.startDate,
    this.accountNumber,
    this.bankName,
    this.phone,
    this.email,
    this.contactPerson,
    this.additionalInfo,
    this.processingFee,
    this.otherCharges,
    this.partPayment,
    this.advancePayment,
  );
}
