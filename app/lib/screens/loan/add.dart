import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/calculate_emi.dart';
import 'package:loan_manager/methods/calculate_enddate.dart';
import 'package:loan_manager/models/loan.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/widgets/drawer.dart';
import 'package:loan_manager/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddLoan extends StatefulWidget {
  final Loan loan;
  final String loanId;
  final Function actionCallback;

  const AddLoan({this.loan, this.loanId, this.actionCallback});

  @override
  _AddLoanState createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final FocusNode loanTypeFocus = FocusNode();
  final FocusNode accountNameFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();
  final FocusNode tenureFocus = FocusNode();
  final FocusNode interestFocus = FocusNode();
  final FocusNode startDateFocus = FocusNode();
  // optional
  final FocusNode accountNumberFocus = FocusNode();
  final FocusNode bankNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode contactPersonFocus = FocusNode();
  final FocusNode otherLoanInfoFocus = FocusNode();
  final FocusNode loanPartPaymentFocus = FocusNode();
  final FocusNode loanAdvancePaymentFocus = FocusNode();
  final FocusNode loanProcessingFeeFocus = FocusNode();
  final FocusNode loanInsuranceFocus = FocusNode();
  final FocusNode loanOtherChargesFocus = FocusNode();

  String loanTenureLabel = 'Year';
  int tenureMultiple = 12; // year (1) or month (12)

  final FocusNode moratoriumFocus = FocusNode();
  AppUser loggedUser;

  // steps
  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != 3
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      this.loggedUser = AppUser.fromJson(jsonDecode(user));
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
        title: Text('Add new Loan'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FormBuilder(
              key: _fbKey,
              initialValue: {
                'loanType': widget.loan?.loanType != null
                    ? widget.loan?.loanType
                    : 'Other Loan',
                'accountName': widget.loan?.accountName != null
                    ? widget.loan?.accountName
                    : '',
                'amount': widget.loan?.amount != null
                    ? widget.loan?.amount.toString()
                    : '',
                'tenure': widget.loan?.tenure != null
                    ? (widget.loan.tenure / 12).toString()
                    : '',
                'interest': widget.loan?.interest != null
                    ? widget.loan?.interest.toString()
                    : '',
                'startDate': widget.loan?.startDate ?? widget.loan?.startDate,
                'accountNumber': widget.loan?.accountNumber != null
                    ? widget.loan?.accountNumber
                    : null,
                'bankName': widget.loan?.bankName != null
                    ? widget.loan?.bankName
                    : null,
                'phone': widget.loan?.phone != null ? widget.loan?.phone : null,
                'email': widget.loan?.email != null ? widget.loan?.email : null,
                'contactPerson': widget.loan?.contactPerson != null
                    ? widget.loan?.contactPerson
                    : null,
                'otherLoanInfo': widget.loan?.otherLoanInfo != null
                    ? widget.loan?.otherLoanInfo
                    : null,
                'partPayment': widget.loan?.partPayment != null
                    ? widget.loan?.partPayment.toString()
                    : null,
                'advancePayment': widget.loan?.advancePayment != null
                    ? widget.loan?.advancePayment.toString()
                    : null,
                'processingFee': widget.loan?.processingFee != null
                    ? widget.loan?.processingFee.toString()
                    : null,
                'insuranceCharges': widget.loan?.insuranceCharges != null
                    ? widget.loan?.insuranceCharges.toString()
                    : null,
                'otherCharges': widget.loan?.otherCharges != null
                    ? widget.loan?.otherCharges.toString()
                    : null,
                'moratorium': widget.loan?.moratorium != null
                    ? widget.loan?.moratorium
                    : false,
                'moratoriumMonth': widget.loan?.moratoriumMonth != null
                    ? widget.loan?.moratoriumMonth.toString()
                    : '0',
                'moratoriumType': widget.loan?.moratoriumType != null
                    ? widget.loan?.moratoriumType
                    : null,
              },
              autovalidate: false,
              child: Stepper(
                type: StepperType.horizontal,
                steps: [
                  Step(
                    title: Text('Required'),
                    isActive: currentStep == 0 ? true : false,
                    content: Column(
                      children: [
                        FormBuilderDropdown(
                          // autofocus: true,
                          attribute: "loanType",
                          focusNode: accountNameFocus,
                          decoration: InputDecoration(
                            labelText: "Loan Type",
                            prefixIcon:
                                Icon(MaterialCommunityIcons.account_search),
                          ),
                          // initialValue: 'Male',
                          hint: Text('Loan Type'),
                          validators: [FormBuilderValidators.required()],
                          items: [
                            'Personal Loan',
                            'Home Loan',
                            'Gold Loan',
                            'Auto Loan',
                            'Education Loan',
                            'Other Loan'
                          ]
                              .map((loanType) => DropdownMenuItem(
                                  value: loanType, child: Text("$loanType")))
                              .toList(),
                        ),
                        FormBuilderTextField(
                          attribute: "accountName",
                          focusNode: accountNameFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Account's Nick Name",
                            prefixIcon: Icon(AntDesign.idcard),
                          ),
                          validators: [
                            FormBuilderValidators.minLength(2),
                            FormBuilderValidators.maxLength(25),
                          ],
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(amountFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "amount",
                          focusNode: amountFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Principal Loan Amount",
                            prefixIcon: Icon(FontAwesome.money),
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(500),
                            FormBuilderValidators.max(10000000),
                          ],
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(tenureFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "tenure",
                          focusNode: tenureFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Loan Tenure",
                            prefixIcon: Icon(MaterialCommunityIcons.timetable),
                            suffixText: this.loanTenureLabel,
                            suffixIcon: IconButton(
                              icon: Icon(FontAwesome.exchange),
                              onPressed: () => {
                                setState(() {
                                  if (this.loanTenureLabel == 'Month') {
                                    this.loanTenureLabel = 'Year';
                                    this.tenureMultiple = 12;
                                  } else {
                                    this.loanTenureLabel = 'Month';
                                    this.tenureMultiple = 1;
                                  }
                                })
                              },
                            ),
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0.3),
                            FormBuilderValidators.max(40 * 12),
                          ],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(interestFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "interest",
                          focusNode: interestFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Loan Interest (in %)",
                            prefixIcon: Icon(MaterialCommunityIcons.percent),
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(6.0),
                            FormBuilderValidators.max(40),
                          ],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(startDateFocus),
                        ),
                        // FormBuilderSlider(
                        //   attribute: "interest",
                        //   validators: [FormBuilderValidators.min(6)],
                        //   min: 6.0,
                        //   max: 36.0,
                        //   initialValue: 10.5,
                        //   decoration: InputDecoration(
                        //     labelText: "Loan Interest (in %)",
                        //   ),
                        //   activeColor: primaryColor,
                        //   inactiveColor: accentColor,
                        // ),
                        // FormBuilderSlider(
                        //   attribute: "tenure",
                        //   validators: [FormBuilderValidators.min(6)],
                        //   min: 1.0,
                        //   max: 30.0,
                        //   initialValue: 2,
                        //   decoration: InputDecoration(
                        //     labelText: "Loan Tenure (in Years)",
                        //   ),
                        //   activeColor: primaryColor,
                        //   inactiveColor: accentColor,
                        // ),
                        FormBuilderDateTimePicker(
                          attribute: "startDate",
                          focusNode: startDateFocus,
                          textInputAction: TextInputAction.next,
                          inputType: InputType.date,
                          format: DateFormat("dd-MMM-yyyy"),
                          decoration: InputDecoration(
                            labelText: "Loan Start Date",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 1 ? true : false,
                    title: Text('Bank Details'),
                    content: Column(
                      children: [
                        FormBuilderTextField(
                          attribute: "accountNumber",
                          focusNode: accountNumberFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Bank Account Number",
                            prefixIcon:
                                Icon(MaterialCommunityIcons.sort_numeric),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(bankNameFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "bankName",
                          focusNode: bankNameFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: "Bank Name",
                              prefixIcon: Icon(MaterialCommunityIcons.bank)),
                          validators: [],
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(phoneFocus),
                        ),
                        FormBuilderPhoneField(
                          attribute: "phone",
                          focusNode: phoneFocus,
                          keyboardType: TextInputType.phone,
                          defaultSelectedCountryIsoCode: 'IN',
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Bank Phone Number",
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validators: [],
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(emailFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "email",
                          focusNode: emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Bank Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(contactPersonFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "contactPerson",
                          focusNode: contactPersonFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Contact Person",
                            prefixIcon: Icon(Icons.contacts),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(otherLoanInfoFocus),
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
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(loanPartPaymentFocus),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 2 ? true : false,
                    title: Text('Other'),
                    content: Column(
                      children: [
                        FormBuilderTextField(
                          attribute: "partPayment",
                          focusNode: loanPartPaymentFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Loan Part Payment",
                            prefixIcon: Icon(MaterialCommunityIcons.plus_box),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(loanAdvancePaymentFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "advancePayment",
                          focusNode: loanAdvancePaymentFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Advance Payment",
                            prefixIcon: Icon(MaterialCommunityIcons.plus_box),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(loanProcessingFeeFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "processingFee",
                          focusNode: loanProcessingFeeFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Loan Processing Fee",
                            prefixIcon: Icon(MaterialCommunityIcons.minus_box),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(loanInsuranceFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "insuranceCharges",
                          focusNode: loanInsuranceFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Loan Insurance",
                            prefixIcon: Icon(MaterialCommunityIcons.minus_box),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(loanOtherChargesFocus),
                        ),
                        FormBuilderTextField(
                          attribute: "otherCharges",
                          focusNode: loanOtherChargesFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Other Loan Charges",
                            prefixIcon: Icon(MaterialCommunityIcons.minus_box),
                          ),
                          validators: [],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(moratoriumFocus),
                        ),
                        // FormBuilderSwitch(
                        //   attribute: "moratorium",
                        //   focusNode: moratoriumFocus,
                        //   label: Text('Enrollment (Yes/No)'),
                        //   decoration: InputDecoration(
                        //     labelText: "Moratorium",
                        //     prefixIcon:
                        //         Icon(MaterialCommunityIcons.minus_box),
                        //     border: InputBorder.none,
                        //   ),
                        //   initialValue: false,
                        // ),
                        // FormBuilderTouchSpin(
                        //   attribute: "moratoriumMonth",
                        //   decoration: InputDecoration(
                        //     labelText: "Moratorium Month",
                        //     border: InputBorder.none,
                        //     contentPadding: EdgeInsets.only(top: 0),
                        //   ),
                        //   initialValue: 0,
                        //   step: 1,
                        // ),
                        // FormBuilderRadioGroup(
                        //   attribute: "moratoriumType",
                        //   decoration: InputDecoration(
                        //     labelText: "Moratorium Type",
                        //     contentPadding: EdgeInsets.only(top: 0),
                        //   ),
                        //   validators: [],
                        //   options: [
                        //     "Loan Tenure",
                        //     "Loan Amount (EMI)",
                        //   ]
                        //       .map((lang) =>
                        //           FormBuilderFieldOption(value: lang))
                        //       .toList(growable: false),
                        // ),
                      ],
                    ),
                  )
                ],
                currentStep: currentStep,
                onStepContinue: next,
                onStepTapped: (step) => goTo(step),
                onStepCancel: cancel,
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
                child: Text("Save"),
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    double amount =
                        double.parse(_fbKey.currentState.value['amount']);
                    int tenure =
                        int.parse(_fbKey.currentState.value['tenure']) *
                            tenureMultiple;
                    double interest =
                        double.parse(_fbKey.currentState.value['interest']);
                    double monthlyEmi = calculateEmi(amount, tenure, interest);
                    DateTime startDate = _fbKey.currentState.value['startDate'];
                    DateTime endDate = calculateEndDate(startDate, tenure);

                    Loan loan = Loan(
                      loanType: _fbKey.currentState.value['loanType'],
                      accountName: _fbKey.currentState.value['accountName'],
                      amount: amount,
                      tenure: tenure,
                      interest: interest,
                      startDate: startDate,
                      accountNumber: _fbKey.currentState.value['accountNumber'],
                      bankName: _fbKey.currentState.value['bankName'],
                      phone: _fbKey.currentState.value['phone'],
                      email: _fbKey.currentState.value['email'],
                      contactPerson: _fbKey.currentState.value['contactPerson'],
                      otherLoanInfo: _fbKey.currentState.value['otherLoanInfo'],
                      processingFee: _fbKey.currentState.value['processingFee'],
                      otherCharges: _fbKey.currentState.value['otherCharges'],
                      partPayment: _fbKey.currentState.value['partPayment'],
                      advancePayment:
                          _fbKey.currentState.value['advancePayment'],
                      insuranceCharges:
                          _fbKey.currentState.value['insuranceCharges'],
                      moratorium: _fbKey.currentState.value['moratorium'],
                      moratoriumMonth: int.parse(
                          _fbKey.currentState.value['moratoriumMonth']),
                      moratoriumType:
                          _fbKey.currentState.value['moratoriumType'],
                      monthlyEmi: monthlyEmi,
                      totalEmi: double.parse(
                          (monthlyEmi * tenure).toStringAsFixed(2)),
                      endDate: endDate,
                    );

                    if (widget.loanId != null) {
                      loan.updateLoan(widget.loanId);
                      showToast("Loan Updated Successfully ✔");
                    } else {
                      loan.saveLoan();
                      showToast("Loan Saved Successfully ✔");
                    }

                    widget.actionCallback(true);
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
            ],
          )
        ],
      ),
    );
  }
}
