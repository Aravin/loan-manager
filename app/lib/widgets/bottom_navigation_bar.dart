import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/home.dart';
import 'package:loan_manager/widgets/lend_list.dart';
import 'package:loan_manager/widgets/loan_list.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  CustomNavigationBar({this.selectedIndex});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    var page;
    if (index == 0) {
      page = Home();
    }
    if (index == 1) {
      page = LoanList();
    }
    if (index == 2) {
      page = LendList();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            icon: Icon(MaterialIcons.account_balance),
            title: Text('Borrowed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialIcons.account_balance_wallet),
            title: Text('Lend'),
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: liteSecondaryColor,
        unselectedItemColor: liteAccentColor,
        backgroundColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
