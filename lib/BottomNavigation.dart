import 'package:anne_bebek/Etkinlikler.dart';
import 'package:anne_bebek/MainPage.dart';
import 'package:anne_bebek/Profile.dart';
import 'package:anne_bebek/UzmanSec.dart';
import 'package:anne_bebek/Uzmanlar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'UzmanCevapla.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTab = 0;
  final List<Widget> widgetList = [
    MainPage(),
    Etkinlikler(),
    Uzmanlar(),
    Profile()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainPage();
  bool isUzman = false;
  late String name = "", surname = "";

  @override
  void initState() {
    getName();
    super.initState();
    getIsUzman();
  }

  Future<void> getName() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot1 = await ref.child("isim").get();
    var snapshot2 = await ref.child("soyisim").get();

    name = snapshot1.value.toString();
    surname = snapshot2.value.toString();
    setState(() {});
  }

  void getIsUzman() {
    isUzman = FirebaseAuth.instance.currentUser!.uid ==
                "ivkJYTY6fccl4LdGnYkxFCvUokL2" ||
            FirebaseAuth.instance.currentUser!.uid ==
                "z5MhoCKtOjV8yGfQfySRBfjdn1y1"
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          if (isUzman) {
            Navigator.push(
                context, MaterialPageRoute(builder: (route) => UzmanCevapla()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (route) =>
                        UzmanSec(name: name, surname: surname)));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.height * 0.1,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            gradient: LinearGradient(
              begin: Alignment(-0.95, 0.0),
              end: Alignment(1.0, 0.0),
              colors: [
                const Color(0xff9DCEFF),
                const Color(0xff92A3FD),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/floatingButton.png"),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  isUzman ? "Cevapla" : "Sor",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 0;
                    currentScreen = MainPage();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/home.png"),
                    Text(
                      "İçerikler",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                )),
            Spacer(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 1;
                    currentScreen = Etkinlikler();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/activity.png"),
                    Text(
                      "Etkinlikler",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                )),
            Spacer(),
            Spacer(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 2;
                    currentScreen = Uzmanlar();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/camera.png"),
                    Text(
                      "Uzmanlarımız",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                )),
            Spacer(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 3;
                    currentScreen = Profile();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/profile.png"),
                    Text(
                      "Profil",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                )),
          ],
        ),
      ),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
    );
  }
}
