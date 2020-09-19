import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/calculate_paid.dart';
import 'package:loan_manager/methods/calculate_paid_percent.dart';
import 'package:loan_manager/models/firestore.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/screens/lend/add.dart';
import 'package:loan_manager/screens/lend/list.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/screens/loan/list.dart';
import 'package:loan_manager/widgets/bottom_navigation_bar.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showSpinner = false;
  AppUser loggedUser;
  double totalLend = 0.0;
  double totalBorrow = 0.0;
  double loanTotalPayable = 0.0;
  double loanTotalPaid = 0.0;
  double loanTotalMonthlyPayable = 0.0;
  double totalPaidPercent = 0.0;
  DateTime highestEndDate = DateTime.now();
  String daysLeft = 'na';
  List<DateTime> endDateList = [];
  NumberFormat f =
      NumberFormat.currency(locale: 'en_IN', name: 'INR', symbol: '₹');

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: 'en_IN', allowFromNow: true);
  }

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      this.loggedUser = AppUser.fromJson(jsonDecode(user));
    }
  }

  _getHomeInformation() async {
    showSpinner = true;

    read('lend').then(
      (value) => value.docs?.forEach((element) {
        totalLend += element.data()['data']['amount'];
      }),
    );

    read('loan').then(
      (value) => value.docs?.forEach((element) {
        totalBorrow += element.data()['data']['amount'];
        loanTotalPayable += element.data()['data']['totalEmi'];
        var monthlyEmi = element.data()['data']['monthlyEmi'];
        loanTotalPaid += calculatePaid(
            element.data()['data']['startDate'].toDate(), monthlyEmi);
        loanTotalMonthlyPayable += monthlyEmi;
        endDateList.add(element.data()['data']['endDate'].toDate());
        highestEndDate = endDateList.reduce((value, element) =>
            value.difference(element).inDays > 0 ? value : element);
        daysLeft = timeUntil(highestEndDate);
        totalPaidPercent =
            calculatePaidPercent(loanTotalPaid, loanTotalPayable);

        setState(() {
          showSpinner = false;
        });
      }),
    );
  }

  @override
  void initState() {
    _getLoginInformation();
    _getHomeInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: appPaddingS,
          child: ListView(
            children: [
              Container(
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
                      '${f.format(totalBorrow)}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      'Ends in $daysLeft',
                      style: TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Payable ${f.format(loanTotalPayable)}',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Payable ${f.format(loanTotalPaid)}',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Interest ${f.format(loanTotalPayable - totalBorrow)}',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Total Monthly Installment ${f.format(loanTotalMonthlyPayable)}',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    LinearPercentIndicator(
                      lineHeight: 15.0,
                      percent: totalPaidPercent / 100,
                      backgroundColor: liteSecondaryColor,
                      progressColor: secondaryColor,
                      animation: true,
                      animationDuration: 1000,
                      center: new Text(
                        "$totalPaidPercent% paid",
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
                          icon: Icon(MaterialIcons.account_balance),
                          label: Text('View All'),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
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
                          icon: Icon(Icons.add_box),
                          label: Text('Add New'),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.5),
              Container(
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
                      '${f.format(totalLend)}',
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
                          icon: Icon(MaterialIcons.account_balance_wallet),
                          label: Text('View All'),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
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
                          icon: Icon(Icons.add_box),
                          label: Text('Add New'),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 0),
    );
  }
}
