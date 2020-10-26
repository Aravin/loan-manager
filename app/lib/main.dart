// Import the firebase_core plugin
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/constants.dart';
import 'package:loan_manager/screens/login.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics;

main() {
  analytics = FirebaseAnalytics();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return Center(child: Text('error'));
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Loan Manager',
            theme: ThemeData(
              fontFamily: 'Rubik',
              // This is the theme of your application.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: primaryColor,
              accentColor: accentColor,
              // backgroundColor: themeWhite,
            ),
            home: Login(), // AppDrawer(),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
