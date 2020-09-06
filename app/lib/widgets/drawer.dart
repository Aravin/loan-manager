import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppUser loggedUser;

getLoginInformation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  if (user != null) {
    loggedUser = AppUser.fromJson(jsonDecode(user));
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    getLoginInformation();

    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.

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
            ),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Saved Loan'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Terms & Privacy'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate Us'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
