import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/loan/add.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:loan_manager/widgets/loan_list.dart';

class LoanListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLoan()),
          );
        },
        label: Text('Add new Loan'),
        icon: Icon(Icons.add),
        backgroundColor: secondaryColor,
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Saved Loan'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: LoanList(),
      backgroundColor: themeWhite,
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
          currentIndex: 1,
          selectedItemColor: liteSecondaryColor,
          unselectedItemColor: liteAccentColor,
          backgroundColor: primaryColor,
          onTap: null,
        ),
      ),
    );
  }
}
