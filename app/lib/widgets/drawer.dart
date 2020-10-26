import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/app_share.dart';
import 'package:loan_manager/methods/launch_url.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/screens/lend/list.dart';
import 'package:loan_manager/screens/loan/list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showSpinner = false;

  AppUser loggedUser;

  getLoginInformation() async {
    showSpinner = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    if (user != null) {
      loggedUser = AppUser.fromJson(jsonDecode(user));
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getLoginInformation();
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.

      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Text(loggedUser?.name == null
                        ? 'U'
                        : loggedUser?.name[0]?.toUpperCase()),
                    backgroundColor: secondaryColor,
                    radius: 25.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Welcome, ${loggedUser?.name == null ? 'User' : loggedUser?.name}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${loggedUser?.email == null ? '' : loggedUser?.email}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            ListTile(
              leading: Icon(MaterialIcons.account_balance),
              title: Text('Loan'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoanListScreen(),
                    ),
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(MaterialIcons.account_balance_wallet),
              title: Text('Lend'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LendListScreen(),
                    ),
                  );
                });
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.book),
            //   title: Text('Terms & Privacy'),
            //   onTap: () {
            //     setState(() {
            //       Navigator.pop(context);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => TermsScreen()),
            //       );
            //     });
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate Us'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  launchURL();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share the App'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  share();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
