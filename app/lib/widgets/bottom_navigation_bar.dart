import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/home.dart';
import 'package:loan_manager/screens/lend/list.dart';
import 'package:loan_manager/screens/loan/list.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;

  CustomNavigationBar({this.currentIndex});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int selectedIndex) {
    if (selectedIndex == widget.currentIndex) {
      return;
    }
    var page;
    if (selectedIndex == 0) {
      page = Home();
    }
    if (selectedIndex == 1) {
      page = LoanListScreen();
    }
    if (selectedIndex == 2) {
      page = LendListScreen();
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialIcons.account_balance),
            label: 'Borrowed',
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialIcons.account_balance_wallet),
            label: 'Lend',
          ),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: liteSecondaryColor,
        unselectedItemColor: liteAccentColor,
        backgroundColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
