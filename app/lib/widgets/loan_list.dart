import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LoanList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: read('loan'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot);

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            print(document.data().length);

            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Card(
                margin: appPaddingXS,
                // color: liteAccentColor,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Payable ₹${document.data()['data']['totalEmi']}'),
                          Text(
                              'Paid ₹${document.data()['data']['accountName']}'),
                        ],
                      ),
                    ),
                    LinearPercentIndicator(
                      lineHeight: 15.0,
                      percent: 0.3,
                      backgroundColor: liteSecondaryColor,
                      progressColor: secondaryColor,
                      animation: true,
                      animationDuration: 1000,
                      center: new Text(
                        "10% paid",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.5)
                    // ButtonBar(
                    //   children: <Widget>[
                    //     FlatButton(
                    //       child: Text('Edit'),
                    //       onPressed: () {/* ... */},
                    //     ),
                    //     FlatButton(
                    //       child: Text('Delete'),
                    //       onPressed: () {/* ... */},
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
