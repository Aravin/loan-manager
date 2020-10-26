import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/app_share.dart';
import 'package:loan_manager/methods/calculate_paid.dart';
import 'package:loan_manager/methods/calculate_paid_percent.dart';
import 'package:loan_manager/methods/launch_url.dart';
import 'package:loan_manager/models/firestore.dart';
import 'package:loan_manager/screens/lend/add.dart';
import 'package:loan_manager/screens/lend/list.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/screens/loan/list.dart';
import 'package:loan_manager/widgets/bottom_navigation_bar.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

NumberFormat f =
    NumberFormat.currency(locale: 'en_IN', name: 'INR', symbol: '₹');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showSpinner = false;
  double totalLend = 0.0;
  double totalBorrow = 0.0;
  double loanTotalPayable = 0.0;
  double loanTotalPaid = 0.0;
  double loanTotalMonthlyPayable = 0.0;
  double totalPaidPercent = 0.0;
  DateTime highestEndDate = DateTime.now();
  String daysLeft = 'na';
  List<DateTime> endDateList = [];

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: 'en_IN', allowFromNow: true);
  }

  Future<bool> _getHomeInformation() async {
    showSpinner = false;
    totalLend = 0.0;
    totalBorrow = 0.0;
    loanTotalPayable = 0.0;
    loanTotalPaid = 0.0;
    loanTotalMonthlyPayable = 0.0;
    totalPaidPercent = 0.0;
    highestEndDate = DateTime.now();
    daysLeft = 'na';
    endDateList = [];

    await read('lend').then(
      (value) => value.docs?.forEach((element) {
        totalLend += element.data()['data']['amount'];
      }),
    );

    await read('loan').then(
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
      }),
    );

    return true;
  }

  void actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
          actions: [
            // IconButton(
            //     icon: Icon(MaterialIcons.refresh),
            //     onPressed: () => actionCallback(true)),
            IconButton(
                icon: Icon(MaterialIcons.star), onPressed: () => launchURL()),
            IconButton(
                icon: Icon(MaterialIcons.share), onPressed: () => share())
          ],
        ),
        body: Padding(
          padding: appPaddingS,
          child: FutureBuilder(
            future: _getHomeInformation(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
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
                          'Total Paid ${f.format(loanTotalPaid)}',
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
                                    builder: (context) => LoanListScreen(
                                        actionCallback: actionCallback),
                                  ),
                                ).then((value) => setState(() => {}))
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
                                    builder: (context) =>
                                        AddLoan(actionCallback: actionCallback),
                                  ),
                                ).then((value) => setState(() => {}))
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
                          'Money Lend',
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
                                      builder: (context) => LendListScreen(
                                          actionCallback: actionCallback)),
                                ).then((value) => setState(() => {}))
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
                                      builder: (context) => AddLend(
                                          actionCallback: actionCallback)),
                                ).then((value) => setState(() => {}))
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
              );
            },
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(currentIndex: 0),
      );
}
