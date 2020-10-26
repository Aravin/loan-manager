import 'dart:convert';

import 'package:flutter/material.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/methods/sharedPreference.dart';
import 'package:loan_manager/models/user.dart';
import 'package:loan_manager/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String bottomSheetButtonText = 'Existing User? Login';
  IconData bottomSheetButtonIcon = Icons.verified_user;
  String toggleLogin = 'Login';
  AppUser loggedUser;
  bool showSpinner = false;

  _getLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      this.loggedUser = AppUser.fromJson(jsonDecode(user));
      if (this.loggedUser.uid != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLoginInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Welcome to Loan Manager'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 175,
                      width: 175,
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  Container(
                    child: Text('Login / Sign-up'),
                    padding: const EdgeInsets.all(16),
                  ),
                  _GoogleSignIn(),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SignInButtonBuilder(
                      text: "Continue with Email",
                      icon: Icons.email,
                      backgroundColor: Colors.blue,
                      onPressed: () => {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                //  padding: EdgeInsets.only(
                                //         bottom:
                                //             MediaQuery.of(context).viewInsets.bottom),
                                return Scaffold(
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      toggleLogin == 'Login'
                                          ? RegisterPage()
                                          : _EmailPasswordForm(),
                                      RaisedButton.icon(
                                        icon: Icon(bottomSheetButtonIcon),
                                        label: Text(bottomSheetButtonText),
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        onPressed: () => {
                                          setState(
                                            () {
                                              showSpinner = true;
                                              if (toggleLogin == 'Login') {
                                                bottomSheetButtonIcon =
                                                    Icons.create;
                                                bottomSheetButtonText =
                                                    'Register';
                                                toggleLogin = 'Register';
                                              } else {
                                                bottomSheetButtonIcon =
                                                    Icons.verified_user;
                                                bottomSheetButtonText =
                                                    'Existing User? Login';
                                                toggleLogin = 'Login';
                                              }

                                              setState(
                                                  () => {showSpinner = false});
                                            },
                                          )
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        color: primaryColor,
                                        tooltip:
                                            MaterialLocalizations.of(context)
                                                .closeButtonTooltip,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      },
                    ),
                  ),
                  _AnonymouslySignInSection(),
                  Container(
                    child: Text(
                        'By using this application you accept our Terms of Use and Privacy Policy.'),
                    padding: const EdgeInsets.all(16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 16.0),
          alignment: Alignment.center,
          child: SignInButtonBuilder(
            text: "Sign In Anonymously",
            icon: Icons.person_outline,
            backgroundColor: Colors.green,
            onPressed: () async {
              try {
                final User user = (await _auth.signInAnonymously()).user;

                setLoginInformation(user);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              } catch (e) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(e.message),
                ));
              }
            },
          ),
        ),
        Visibility(
          visible: _success == null ? false : true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? 'Successfully signed in, uid: ' + _userID
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text(
                  'Sign in with Email and Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
              FormBuilderTextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ],
                attribute: null,
              ),
              FormBuilderTextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                  FormBuilderValidators.maxLength(36)
                ],
                obscureText: true,
                attribute: null,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.email,
                  backgroundColor: Colors.blue,
                  text: "Sign In with Email",
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      setLoginInformation(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Email & Password " + e.message),
        duration: Duration(seconds: 5),
      ));
    }
  }
}

class _GoogleSignIn extends StatefulWidget {
  _GoogleSignIn();

  @override
  State<StatefulWidget> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<_GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16.0),
            alignment: Alignment.center,
            child: SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              onPressed: () async {
                _signInWithGoogle();
              },
            ),
          ),
        ],
      ),
    );
  }

  //Example code of how to sign in with Google.
  void _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);

      final user = userCredential.user;

      setLoginInformation(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: $e"),
      ));
    }
  }
}

/// Entrypoint example for registering via Email/Password.
class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = false;
  String _userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Register with Email and Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
              FormBuilderTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ],
                attribute: null,
              ),
              FormBuilderTextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                  FormBuilderValidators.maxLength(36)
                ],
                obscureText: true,
                attribute: null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.person_add,
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _register();
                    }
                  },
                  text: 'Register',
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Text(
              //     _success == null
              //         ? ''
              //         : (_success
              //             ? 'Successfully registered ' + _userEmail
              //             : 'Registration failed'),
              //     style: TextStyle(
              //       color: Colors.grey,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    User user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
    } catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.message),
      ));
    }

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });

      setLoginInformation(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      _success = false;
    }
  }
}
