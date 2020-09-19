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

  // calculate field
  final double monthlyEmi;
  final double totalEmi;
  final DateTime endDate;

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
    this.monthlyEmi,
    this.totalEmi,
    this.endDate,
  });

  Loan.fromJson(Map<String, dynamic> json)
      : loanType = json['loanType'],
        accountName = json['accountName'],
        amount = json['amount'],
        tenure = json['tenure'],
        interest = json['interest'],
        startDate =
            json['startDate'] != null ? json['startDate'].toDate() : null,
        // calculated value
        endDate = json['endDate'] != null ? json['endDate'].toDate() : null,
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
        moratoriumType = json['moratoriumType'],
        monthlyEmi = json['monthlyEmi'],
        totalEmi = json['totalEmi'];

  Map<String, dynamic> toJson() => {
        'loanType': loanType,
        'accountName': accountName,
        'amount': amount,
        'tenure': tenure,
        'interest': interest,
        'startDate': startDate,
        'endDate': endDate, // calculated value
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
        'monthlyEmi': monthlyEmi,
        'totalEmi': totalEmi,
      };

  Future<void> saveLoan() {
    return create('loan', this.toJson());
  }

  Future<void> updateLoan(docId) {
    return update('loan', docId, this.toJson());
  }
}
