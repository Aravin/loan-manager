import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loan_manager/methods/sharedPreference.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  User loggedUser;

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    print(user);
    if (user != null) {
      this.loggedUser = jsonDecode(user);
    }
  }

  void initState() {
    _getLoginInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(loggedUser: loggedUser),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              child: Text('User Logged in...'),
            )
          ],
        ),
      ),
    );
  }
}
