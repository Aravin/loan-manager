import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/user.dart';

class AppDrawer extends StatefulWidget {
  final User loggedUser;

  const AppDrawer({Key key, this.loggedUser}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text(widget.loggedUser?.name == null
                      ? 'U'
                      : widget.loggedUser?.name[0]?.toUpperCase()),
                  backgroundColor: secondaryColor,
                  radius: 25.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Welcome, ${widget.loggedUser?.name == null ? 'User' : widget.loggedUser?.name}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${widget.loggedUser?.email == null ? '' : widget.loggedUser?.email}',
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
