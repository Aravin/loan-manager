import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/screens/lend/add.dart';
import 'package:loan_manager/screens/lend/list.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/screens/loan/list.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppUser loggedUser;

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    print(user);
    if (user != null) {
      this.loggedUser = AppUser.fromJson(jsonDecode(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLoginInformation();

    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: Text('Home'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: appPaddingS,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: liteAccentColor,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                padding: appPaddingM,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Loan Borrow',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\₹26,50,000.00',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      '14 year 1 month left',
                      style: TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Payable \₹32,50,000.00',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Interest \₹6,50,000.00',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Monthly Installment \₹50,000.00',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Yearly Installment \₹6,50,000.00',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton.icon(
                          color: primaryColor,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoanListScreen()),
                            )
                          },
                          icon: Icon(Icons.list),
                          label: Text('Go to Loan List'),
                        ),
                        RaisedButton.icon(
                          color: primaryColor,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddLoan()),
                            )
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add new Loan'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.5),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: liteSecondaryColor,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                padding: appPaddingM,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Lend',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\₹5,200.00',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton.icon(
                          color: primaryColor,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LendListScreen()),
                            )
                          },
                          icon: Icon(Icons.list),
                          label: Text('Go to Loan List'),
                        ),
                        RaisedButton.icon(
                          color: primaryColor,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddLend()),
                            )
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add new Loan'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.account_minus),
              title: Text('Borrowed'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.account_plus),
              title: Text('Lend'),
            ),
          ],
          currentIndex: 0,
          selectedItemColor: liteSecondaryColor,
          unselectedItemColor: liteAccentColor,
          backgroundColor: primaryColor,
          onTap: null,
        ),
      ),
    );
  }
}
