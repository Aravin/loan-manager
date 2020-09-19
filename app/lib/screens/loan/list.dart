import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/widgets/bottom_navigation_bar.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:loan_manager/widgets/loan_list.dart';

class LoanListScreen extends StatefulWidget {
  @override
  _LoanListScreenState createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddLoan(actionCallback: actionCallback)),
          );
        },
        label: Text('Add new Loan'),
        icon: Icon(Icons.add),
        backgroundColor: secondaryColor,
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Saved Loans'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: LoanList(actionCallback: actionCallback),
      backgroundColor: themeWhite,
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 1),
    );
  }
}
