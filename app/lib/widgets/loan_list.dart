import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/calculate_paid.dart';
import 'package:loan_manager/methods/calculate_paid_percent.dart';
import 'package:loan_manager/models/firestore.dart';
import 'package:loan_manager/models/loan.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/widgets/toast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LoanList extends StatelessWidget {
  final Function actionCallback;

  const LoanList({this.actionCallback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: read('loan'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.length == 0) {
          return Center(child: Text('You don\'t have any saved loans!'));
        }

        return new ListView(
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Card(
                  margin: appPaddingXS,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                '${document.data()['data']['accountName']} - ${document.data()['data']['loanType']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Loan Amount ${document.data()['data']['amount']}'),
                              trailing: Text(
                                  'Montly EMI ₹${document.data()['data']['monthlyEmi']}'),
                            ),
                            Container(
                              padding: appPaddingM,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Payable ₹${document.data()['data']['totalEmi']}'),
                                  Text(
                                      'Paid ₹${calculatePaid(document.data()['data']['startDate'].toDate(), document.data()['data']['monthlyEmi'])}'),
                                ],
                              ),
                            ),
                            LinearPercentIndicator(
                              lineHeight: 15.0,
                              percent: calculatePaidPercent(
                                      calculatePaid(
                                          document
                                              .data()['data']['startDate']
                                              .toDate(),
                                          document.data()['data']
                                              ['monthlyEmi']),
                                      document.data()['data']['totalEmi']) /
                                  100,
                              backgroundColor: liteSecondaryColor,
                              progressColor: secondaryColor,
                              animation: true,
                              animationDuration: 1000,
                              center: Text(
                                '${calculatePaidPercent(calculatePaid(document.data()['data']['startDate'].toDate(), document.data()['data']['monthlyEmi']), document.data()['data']['totalEmi'])}% paid',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.5)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Container(
                            height: 50,
                            color: liteAccentColor,
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              color: liteSecondaryColor,
                              onSelected: (String result) {
                                if (result == 'edit') {
                                  var loan =
                                      Loan.fromJson(document.data()['data']);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => AddLoan(
                                              loan: loan,
                                              loanId: document.id,
                                              actionCallback:
                                                  this.actionCallback,
                                            )),
                                  );
                                }
                                if (result == 'delete') {
                                  delete('loan', document.id)
                                      .then((value) => {
                                            showToast(
                                                "Loan Deleted Successfully ✔"),
                                          })
                                      .catchError((onError) => {
                                            {
                                              showToast("Failed to Delete ❌"),
                                            }
                                          });

                                  actionCallback(true);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
