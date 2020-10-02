import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/lend/add.dart';
import 'package:loan_manager/widgets/bottom_navigation_bar.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:loan_manager/widgets/lend_list.dart';

class LendListScreen extends StatefulWidget {
  @override
  _LendListScreenState createState() => _LendListScreenState();
}

class _LendListScreenState extends State<LendListScreen> {
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
                builder: (context) => AddLend(actionCallback: actionCallback)),
          );
        },
        label: Text('Add new Lend'),
        icon: Icon(Icons.add),
        backgroundColor: secondaryColor,
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Saved Lending'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: LendList(actionCallback: actionCallback),
      bottomNavigationBar: CustomNavigationBar(currentIndex: 2),
    );
  }
}
