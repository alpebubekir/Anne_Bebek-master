import 'dart:async';

import 'package:anne_bebek/MoreInformation.dart';
import 'package:anne_bebek/OnBoarding.dart';
import 'package:anne_bebek/service/locale_push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigation.dart';
import 'LogIn.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalNotificationService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('tr', 'TR'),
        const Locale('en', 'US'),
      ],
      locale: Locale('tr'),
      debugShowCheckedModeBanner: false,
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool? isFirstLook;
  late bool? moreInformation;
  late bool? isSignedIn;

  @override
  void initState() {
    getShared();
    super.initState();
  }

  Future<void> getShared() async {
    var prefs = await SharedPreferences.getInstance();
    isSignedIn = FirebaseAuth.instance.currentUser == null ? false : true;
    if (prefs.getBool("isFirstLook") == null) {
      isFirstLook = true;
    } else {
      isFirstLook = false;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

      var snapshot = await ref.child("boy").get();

      if (snapshot.exists) {
        moreInformation = true;
      } else {
        moreInformation = false;
      }
    } else {
      moreInformation = false;
    }

    if (isSignedIn!) {
      if (moreInformation!) {
        if (isFirstLook!) {
          Navigator.push(
              context, MaterialPageRoute(builder: (route) => OnBoarding()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (route) => BottomNavigation()));
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (route) => MoreInformation()));
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (route) => LogIn()));
    }

    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Emin misiniz?'),
            content: const Text('Uygulamadan ????kmak istiyor musunuz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hay??r'),
              ),
              TextButton(
                onPressed: () => {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                },
                child: const Text('Evet'),
              ),
            ],
          ),
        )) ??
        false;
  }

  onChanged(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/" + uid);

    var snapshot1 = await ref.child("boy").get();

    if (snapshot1.exists) {
      moreInformation = true;
    } else {
      moreInformation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )
          /*StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Somethings went wrong!"));
                } else if (snapshot.hasData) {
                  //onChanged(snapshot.data!.uid);
                  if (isFirstLook == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (isFirstLook! & moreInformation!) {
                    return OnBoarding();
                  } else {
                    if (moreInformation == null) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!moreInformation!) {
                      return MoreInformation();
                    } else {
                      return BottomNavigation();
                    }
                  }
                } else {
                  return LogIn();
                }
              },
            ),*/
          ),
    );
  }
}
