import 'firestore.dart';

class Loan {
  final String loanType;
  final String accountName;
  final double amount;
  final int tenure; // in months
  final double interest;
  final DateTime startDate;

  // optional fields
  final String accountNumber;
  final String bankName;
  final String phone;
  final String email;
  final String contactPerson;
  final String otherLoanInfo;

  final double processingFee;
  final double otherCharges;
  final double partPayment;
  final double advancePayment;
  final double insuranceCharges;
  final bool moratorium;
  final int moratoriumMonth;
  final String moratoriumType;

  Loan({
    this.loanType,
    this.accountName,
    this.amount,
    this.tenure,
    this.interest,
    this.startDate,
    this.accountNumber,
    this.bankName,
    this.phone,
    this.email,
    this.contactPerson,
    this.otherLoanInfo,
    this.processingFee,
    this.otherCharges,
    this.partPayment,
    this.advancePayment,
    this.insuranceCharges,
    this.moratorium,
    this.moratoriumMonth,
    this.moratoriumType,
  });

  Loan.fromJson(Map<String, dynamic> json)
      : loanType = json['loanType'],
        accountName = json['accountName'],
        amount = json['amount'],
        tenure = json['tenure'],
        interest = json['interest'],
        startDate = json['startDate'],
        accountNumber = json['accountNumber'],
        bankName = json['bankName'],
        phone = json['phone'],
        email = json['email'],
        contactPerson = json['contactPerson'],
        otherLoanInfo = json['otherLoanInfo'],
        processingFee = json['processingFee'],
        otherCharges = json['otherCharges'],
        partPayment = json['partPayment'],
        advancePayment = json['advancePayment'],
        insuranceCharges = json['insuranceCharges'],
        moratorium = json['moratorium'],
        moratoriumMonth = json['moratoriumMonth'],
        moratoriumType = json['moratoriumType'];

  Map<String, dynamic> toJson() => {
        'loanType': loanType,
        'accountName': accountName,
        'amount': amount,
        'tenure': tenure,
        'interest': interest,
        'startDate': startDate,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'phone': phone,
        'email': email,
        'contactPerson': contactPerson,
        'otherLoanInfo': otherLoanInfo,
        'processingFee': processingFee,
        'otherCharges': otherCharges,
        'partPayment': partPayment,
        'advancePayment': advancePayment,
        'insuranceCharges': insuranceCharges,
        'moratorium': moratorium,
        'moratoriumMonth': moratoriumMonth,
        'moratoriumType': moratoriumType,
      };

  // Create a CollectionReference called users that references the firestore collection

  Future<void> saveLoan() {
    // Call the user's CollectionReference to add a new user
    return create('loan', this.toJson());
  }
}
