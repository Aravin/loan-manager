import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/models/lend.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:loan_manager/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddLend extends StatefulWidget {
  final Lend lend;
  final String lendId;
  final Function actionCallback;

  const AddLend({this.lend, this.lendId, this.actionCallback});

  @override
  _AddLendState createState() => _AddLendState();
}

class _AddLendState extends State<AddLend> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final FocusNode amountFocus = FocusNode();
  final FocusNode interestFocus = FocusNode();
  final FocusNode startDateFocus = FocusNode();
  final FocusNode returnDateFocus = FocusNode();
  // optional
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode contactPersonFocus = FocusNode();
  final FocusNode otherLoanInfoFocus = FocusNode();

  String loanTenureLabel = 'Year';

  final FocusNode moratoriumFocus = FocusNode();

  AppUser loggedUser;

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      loggedUser = AppUser.fromJson(jsonDecode(user));
    }
  }

  @override
  initState() {
    super.initState();
    _getLoginInformation();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Add new Lend'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: FormBuilder(
              key: _fbKey,
              initialValue: {
                'amount': widget.lend?.amount != null
                    ? widget.lend?.amount.toString()
                    : null,
                'interest': widget.lend?.interest != null
                    ? widget.lend?.interest.toString()
                    : '0.0',
                'phone': widget.lend?.phone != null ? widget.lend?.phone : '',
                'email': widget.lend?.email != null ? widget.lend?.email : '',
                'contactPerson': widget.lend?.contactPerson != null
                    ? widget.lend?.contactPerson
                    : '',
                'otherLoanInfo': widget.lend?.otherLoanInfo != null
                    ? widget.lend?.otherLoanInfo
                    : '',
              },
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children: [
                  FormBuilderTextField(
                    attribute: "contactPerson",
                    focusNode: contactPersonFocus,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Contact Person*",
                      prefixIcon: Icon(Icons.contacts),
                    ),
                    validators: [],
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(amountFocus),
                  ),
                  FormBuilderTextField(
                    attribute: "amount",
                    focusNode: amountFocus,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Loan Amount*",
                      prefixIcon: Icon(FontAwesome.money),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(100),
                      FormBuilderValidators.max(10000000),
                    ],
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(interestFocus),
                  ),
                  FormBuilderTextField(
                    attribute: "interest",
                    focusNode: interestFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Loan Interest (in %)*",
                      prefixIcon: Icon(MaterialCommunityIcons.percent),
                    ),
                    validators: [
                      // FormBuilderValidators.numeric(),
                      // FormBuilderValidators.min(0.0),
                      // FormBuilderValidators.max(40),
                    ],
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(startDateFocus),
                  ),
                  FormBuilderDateTimePicker(
                    attribute: "lendDate",
                    focusNode: startDateFocus,
                    textInputAction: TextInputAction.next,
                    inputType: InputType.date,
                    format: DateFormat("dd-MMM-yyyy"),
                    decoration: InputDecoration(
                      labelText: "Lend Date*",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderDateTimePicker(
                    attribute: "expectedReturnDate",
                    focusNode: returnDateFocus,
                    textInputAction: TextInputAction.next,
                    inputType: InputType.date,
                    format: DateFormat("dd-MMM-yyyy"),
                    decoration: InputDecoration(
                      labelText: "Expected Return Date",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validators: [],
                  ),
                  FormBuilderPhoneField(
                    attribute: "phone",
                    focusNode: phoneFocus,
                    keyboardType: TextInputType.phone,
                    defaultSelectedCountryIsoCode: 'IN',
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validators: [
                      // FormBuilderValidators.required(),
                    ],
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(emailFocus),
                  ),
                  FormBuilderTextField(
                    attribute: "email",
                    focusNode: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validators: [],
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(otherLoanInfoFocus),
                  ),
                  FormBuilderTextField(
                    attribute: "otherLoanInfo",
                    focusNode: otherLoanInfoFocus,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Additional Info",
                      prefixIcon: Icon(Icons.more),
                    ),
                    validators: [],
                  ),
                  SizedBox(height: 25),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text("Save"),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              Lend lend = Lend(
                                amount: double.parse(
                                    _fbKey.currentState.value['amount']),
                                interest: _fbKey
                                            .currentState.value['interest'] !=
                                        null
                                    ? double.parse(
                                        _fbKey.currentState.value['interest'])
                                    : null,
                                lendDate: _fbKey.currentState.value['lendDate'],
                                expectedReturnDate: _fbKey
                                    .currentState.value['expectedReturnDate'],
                                phone: _fbKey.currentState.value['phone'],
                                email: _fbKey.currentState.value['email'],
                                contactPerson:
                                    _fbKey.currentState.value['contactPerson'],
                                otherLoanInfo:
                                    _fbKey.currentState.value['otherLoanInfo'],
                              );

                              if (widget.lendId != null) {
                                lend.updateLend(widget.lendId);
                                showToast("Loan Updated Successfully ✔");
                              } else {
                                lend.saveLend();
                                showToast("Loan Saved Successfully ✔");
                              }

                              widget.actionCallback != null ?? widget.actionCallback(true);
                              Navigator.pop(context, true);
                            }
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                        RaisedButton(
                          color: secondaryColor,
                          child: Text("Reset"),
                          onPressed: () {
                            _fbKey.currentState.reset();
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          )
        ]));
  }
}
