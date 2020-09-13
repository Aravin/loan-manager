import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/firestore.dart';
import 'package:intl/intl.dart';
import 'package:loan_manager/models/lend.dart';
import 'package:loan_manager/screens/lend/add.dart';
import 'package:loan_manager/widgets/toast.dart';

class LendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: read('lend'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Card(
              margin: appPaddingXS,
              shadowColor: liteSecondaryColor,
              child: Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            '${document.data()['data']['contactPerson']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          subtitle: Text(
                            'Amount - ₹${document.data()['data']['amount']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '${document.data()['data']['interest']} %',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Lend on'),
                              Text('Expected Return on'),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormat.yMMMd().format(DateTime.parse(document.data()['data']['lendDate'].toDate().toString()))}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'NA',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 115,
                      color: liteSecondaryColor,
                      child: PopupMenuButton<String>(
                        color: liteAccentColor,
                        onSelected: (String result) {
                          if (result == 'edit') {
                            var lend = Lend.fromJson(document.data()['data']);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddLend(
                                        lend: lend,
                                        lendId: document.id,
                                      )),
                            );
                          }
                          if (result == 'delete') {
                            delete('lend', document.id)
                                .then((value) => {
                                      showToast("Loan Deleted Successfully ✔"),
                                    })
                                .catchError((onError) => {
                                      {
                                        showToast("Failed to Delete ❌"),
                                      }
                                    });
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
                  )
                ],
              ),
            ),
          );
        }).toList());
      },
    );
  }
}