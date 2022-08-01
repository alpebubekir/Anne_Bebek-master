import 'dart:async';

import 'package:anne_bebek/MoreInformation.dart';
import 'package:anne_bebek/OnBoarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigation.dart';
import 'LogIn.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool? isFirstLook = null;
  late bool? moreInformation = null;

  @override
  void initState() {
    getShared();
    super.initState();
  }

  Future<void> getShared() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("isFirstLook") == null) {
      isFirstLook = true;
    } else {
      isFirstLook = false;
    }

    if (prefs.getBool("moreInformation") == null) {
      moreInformation = false;
    } else {
      if (prefs.getString("uid") == null) {
        moreInformation = false;
      } else {
        if (prefs.getString("uid") == FirebaseAuth.instance.currentUser!.uid) {
          moreInformation = prefs.getBool("moreInformation");
        } else {
          moreInformation = false;
        }
      }
    }

    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Emin misiniz?'),
            content: const Text('Uygulamadan çıkmak istiyor musunuz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hayır'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('tr', 'TR'),
            const Locale('en', 'US'),
          ],
          locale: Locale('tr'),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Somethings went wrong!"));
                } else if (snapshot.hasData) {
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
            ),
          ),
        ));
  }
}
