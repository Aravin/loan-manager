import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLoan extends StatefulWidget {
  @override
  _AddLoanState createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  User loggedUser;

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    print(user);
    if (user != null) {
      this.loggedUser = User.fromJson(jsonDecode(user));
    }
  }

  @override
  initState() {
    super.initState();
    _getLoginInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(loggedUser: loggedUser),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Add new Loan'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FormBuilder(
              key: _fbKey,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: TabBar(
                          indicatorColor: secondaryColor,
                          labelColor: primaryColor,
                          tabs: [
                            Tab(text: 'Required*'),
                            Tab(text: 'Bank Details'),
                            Tab(text: 'Other Details'),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            ListView(
                              padding: EdgeInsets.all(10.0),
                              children: [
                                FormBuilderDropdown(
                                  attribute: "loanType",
                                  decoration:
                                      InputDecoration(labelText: "Loan Type"),
                                  // initialValue: 'Male',
                                  hint: Text('Loan Type'),
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  items: [
                                    'Personal Loan',
                                    'Home Loan',
                                    'Gold Loan',
                                    'Auto Loan',
                                    'Education Loan',
                                    'Other Loan'
                                  ]
                                      .map((loanType) => DropdownMenuItem(
                                          value: loanType,
                                          child: Text("$loanType")))
                                      .toList(),
                                ),
                                FormBuilderTextField(
                                  attribute: "accountName",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Account's Nick Name"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "amount",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Principal Loan Amount"),
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(500),
                                    FormBuilderValidators.max(10000000),
                                  ],
                                ),
                                FormBuilderSlider(
                                  attribute: "interest",
                                  validators: [FormBuilderValidators.min(6)],
                                  min: 6.0,
                                  max: 36.0,
                                  initialValue: 10.5,
                                  decoration: InputDecoration(
                                    labelText: "Loan Interest (in %)",
                                  ),
                                  activeColor: primaryColor,
                                  inactiveColor: accentColor,
                                ),
                                FormBuilderSlider(
                                  attribute: "tenure",
                                  validators: [FormBuilderValidators.min(6)],
                                  min: 1.0,
                                  max: 30.0,
                                  initialValue: 2,
                                  decoration: InputDecoration(
                                    labelText: "Loan Tenure (in Years)",
                                  ),
                                  activeColor: primaryColor,
                                  inactiveColor: accentColor,
                                ),
                                FormBuilderDateTimePicker(
                                  attribute: "startDate",
                                  textInputAction: TextInputAction.next,
                                  inputType: InputType.date,
                                  format: DateFormat("dd-MMM-yyyy"),
                                  decoration: InputDecoration(
                                      labelText: "Loan Start Date"),
                                ),
                              ],
                            ),
                            ListView(
                              padding: EdgeInsets.all(10.0),
                              children: [
                                FormBuilderTextField(
                                  attribute: "bankAccountNumber",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Bank Account Number"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "bankName",
                                  textInputAction: TextInputAction.next,
                                  decoration:
                                      InputDecoration(labelText: "Bank Name"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "bankPhoneNumber",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Bank Phone Number"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "bankEmail",
                                  textInputAction: TextInputAction.next,
                                  decoration:
                                      InputDecoration(labelText: "Bank Email"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "bankContactPerson",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Contact Person"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  attribute: "bankAdditionalInfo",
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      labelText: "Additional Info"),
                                  validators: [],
                                ),
                              ],
                            ),
                            ListView(
                              padding: EdgeInsets.all(10.0),
                              children: [
                                FormBuilderTextField(
                                  attribute: "loanProcessingFee",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Loan Processing Fee"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "loanPartPayment",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Loan Part Payment"),
                                  validators: [],
                                ),
                                FormBuilderTextField(
                                  attribute: "loanOtherCharges",
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "Other Loan Charges"),
                                  validators: [],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: primaryColor,
                textColor: Colors.white,
                child: Text("Submit"),
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    print(_fbKey.currentState.value);
                  }
                },
              ),
              RaisedButton(
                color: secondaryColor,
                child: Text("Reset"),
                onPressed: () {
                  _fbKey.currentState.reset();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
