import 'firestore.dart';

class Lend {
  final double amount;
  final double interest;
  final DateTime lendDate;
  final DateTime expectedReturnDate;

  final String phone;
  final String email;
  final String contactPerson;
  final String otherLoanInfo;

  Lend({
    this.amount,
    this.interest,
    this.lendDate,
    this.expectedReturnDate,
    this.phone,
    this.email,
    this.contactPerson,
    this.otherLoanInfo,
  });

  Lend.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        interest = json['interest'],
        lendDate = json['lendDate'] != null ? json['lendDate'].toDate() : null,
        expectedReturnDate = json['expectedReturnDate'] != null
            ? json['expectedReturnDate'].toDate()
            : null,
        phone = json['phone'],
        email = json['email'],
        contactPerson = json['contactPerson'],
        otherLoanInfo = json['otherLoanInfo'];

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'interest': interest,
        'lendDate': lendDate,
        'expectedReturnDate': expectedReturnDate,
        'phone': phone,
        'email': email,
        'contactPerson': contactPerson,
        'otherLoanInfo': otherLoanInfo,
      };

  Future<void> saveLend() {
    // Call the user's CollectionReference to add a new user
    return create('lend', this.toJson());
  }

  Future<void> updateLend(docId) {
    // Call the user's CollectionReference to add a new user
    return update('lend', docId, this.toJson());
  }
}
