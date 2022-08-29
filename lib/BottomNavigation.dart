import 'package:anne_bebek/Etkinlikler.dart';
import 'package:anne_bebek/MainPage.dart';
import 'package:anne_bebek/Profile.dart';
import 'package:anne_bebek/UzmanSec.dart';
import 'package:anne_bebek/Uzmanlar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'UzmanCevapla.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTab = 0;
  int? kilo, boy, yas;
  bool shouldShow = false;
  List<Bildirim> bildirimList = [];
  final List<Widget> widgetList = [
    MainPage(),
    Etkinlikler(shouldShow: false),
    Uzmanlar(),
    Profile(
      name: "",
      surname: "",
      kilo: null,
      boy: null,
      yas: null,
      isUzman: false,
      bildirimList: [],
    )
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainPage();
  bool isUzman = false;
  late String name = "", surname = "";

  @override
  void initState() {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    getData();
    getBildirim();
    super.initState();
    getIsUzman();
    checkVersion();
  }

  Future<void> getBildirim() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");

    ref.onValue.listen((event) {
      bildirimList = [];
      for (DataSnapshot snapshot in event.snapshot.children) {
        if (snapshot.child("dislike").exists) {
          for (DataSnapshot dislike in snapshot.child("dislike").children) {
            bildirimList.add(Bildirim(
                dislike.child("isim").value.toString(),
                dislike.child("timestamp").value as int,
                snapshot.child("title").value.toString(),
                false));
          }
        }

        if (snapshot.child("like").exists) {
          for (DataSnapshot like in snapshot.child("like").children) {
            bildirimList.add(Bildirim(
                like.child("isim").value.toString(),
                like.child("timestamp").value as int,
                snapshot.child("title").value.toString(),
                true));
          }
        }
      }
      bildirimList.sort((a, b) => -1 * a.time.compareTo(b.time));
      setState(() {});
    });
  }

  getData() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
    var kiloSnapshot = await ref.child("kilo").get();
    var boySnapshot = await ref.child("boy").get();
    var dogumSnapshot = await ref.child("dogum tarihi").get();

    kilo = kiloSnapshot.value as int;
    boy = boySnapshot.value as int;

    yas = DateTime.now().year -
        int.parse(dogumSnapshot.value.toString().substring(0, 4));

    getName();
  }

  Future<void> goToWebsite() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.fureb.annebebek.anne_bebek';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkVersion() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("AppInfo");

    var snapshot = await ref.child("version").get();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (snapshot.value.toString() != packageInfo.version) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: const Text('Yeni sürüm mevcut!'),
            content: const Text('Lütfen uygulamayı güncelleyiniz.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {goToWebsite()},
                child: const Text('Güncelle'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> getName() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot1 = await ref.child("isim").get();
    var snapshot2 = await ref.child("soyisim").get();
    var snapshot3 = await ref.child("gebelik haftasi guncel").get();

    name = snapshot1.value.toString();
    surname = snapshot2.value.toString();
    widgetList[3] = Profile(
      name: name,
      surname: surname,
      kilo: kilo,
      boy: boy,
      yas: yas,
      isUzman: isUzman,
      bildirimList: bildirimList,
    );

    if (snapshot3.value.toString() == "36.hafta") {
      widgetList[1] = Etkinlikler(shouldShow: true);
      shouldShow = true;
    }
    setState(() {});
  }

  void getIsUzman() {
    isUzman = FirebaseAuth.instance.currentUser!.uid ==
                "ivkJYTY6fccl4LdGnYkxFCvUokL2" ||
            FirebaseAuth.instance.currentUser!.uid ==
                "z5MhoCKtOjV8yGfQfySRBfjdn1y1"
        ? true
        : false;

    widgetList[3] = Profile(
      name: name,
      surname: surname,
      kilo: kilo,
      boy: boy,
      yas: yas,
      isUzman: isUzman,
      bildirimList: bildirimList,
    );
    setState(() {});
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
                    currentScreen = Etkinlikler(shouldShow: shouldShow);
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
                    currentScreen = Profile(
                      name: name,
                      surname: surname,
                      kilo: kilo,
                      boy: boy,
                      yas: yas,
                      isUzman: isUzman,
                      bildirimList: bildirimList,
                    );
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
