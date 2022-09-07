import 'dart:convert';
import 'dart:io';

import 'package:anne_bebek/Etkinlikler.dart';
import 'package:anne_bebek/MainPage.dart';
import 'package:anne_bebek/Profile.dart';
import 'package:anne_bebek/UzmanSec.dart';
import 'package:anne_bebek/Uzmanlar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  int? yas;
  double? kilo, boy;
  bool shouldShow = false;
  List<Bildirim> bildirimList = [];
  List<VideoItem> videoItemList = [];
  List<AppUser> userList = [];
  final List<Widget> widgetList = [
    MainPage(
      videoItemList: [],
    ),
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
      videoItemList: [],
      userList: [],
    )
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainPage(
    videoItemList: [],
  );
  bool isUzman = false;
  late String name = "", surname = "";

  void getVideo() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");

    ref.onValue.listen((event) async {
      DatabaseReference refUser = FirebaseDatabase.instance.ref("Users");
      for (DataSnapshot snapshot in event.snapshot.children) {
        List<Viewer> viewerList = [];

        for (DataSnapshot viewer in snapshot.child("viewer").children) {
          String uid = viewer.key.toString();
          var gebelik = await refUser.child(uid).child("gebelik haftasi").get();

          viewerList
              .add(Viewer(gebelik.value.toString(), viewer.value.toString()));
        }

        videoItemList.add(VideoItem(
            snapshot.key.toString(),
            snapshot.child("title").value.toString(),
            snapshot.child("link").value.toString(),
            "images/video_banner.png",
            snapshot.child("viewer").children.length,
            snapshot.child("writer").value.toString(),
            snapshot.child("appellation").value.toString(),
            viewerList));
      }

      if (currentTab == 0) {
        currentScreen = MainPage(videoItemList: videoItemList);
      } else if (currentTab == 3) {
        currentScreen = Profile(
          name: name,
          surname: surname,
          kilo: kilo,
          boy: boy,
          yas: yas,
          isUzman: isUzman,
          bildirimList: bildirimList,
          videoItemList: videoItemList,
          userList: userList,
        );
      }
      widgetList[0] = MainPage(videoItemList: videoItemList);
      widgetList[3] = Profile(
        name: name,
        surname: surname,
        kilo: kilo,
        boy: boy,
        yas: yas,
        isUzman: isUzman,
        bildirimList: bildirimList,
        videoItemList: videoItemList,
        userList: userList,
      );
      setState(() {});
    });
  }

  Future<void> haftaArttir() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("AppInfo");
    DatabaseReference refUsers = FirebaseDatabase.instance.ref("Users");
    bool first = true;
    var date = DateTime.now();
    if (date.weekday == DateTime.monday) {
      String dateString = date.year.toString() +
          " " +
          date.month.toString() +
          " " +
          date.day.toString();

      refUsers.onValue.listen((event) async {
        var snapshot = await ref.child("updates").child(dateString).get();
        if (!snapshot.exists && first) {
          for (DataSnapshot user in event.snapshot.children) {
            var gebelik = await user.child("gebelik haftasi").ref.get();

            if (gebelik.value.toString() != "") {
              int hafta = int.parse(gebelik.value
                  .toString()
                  .substring(0, gebelik.value.toString().indexOf(".")));

              first = false;
              user.ref.update(
                  {"gebelik haftasi": "${hafta + 1}.hafta"}).whenComplete(() {
                ref.child("updates").update({dateString: ""});
              });
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    haftaArttir();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    getIsUzman();
    if (isUzman) {
      getUsers();
    }
    getVideo();
    getData();
    getBildirim();
    super.initState();
    checkVersion();
  }

  void getUsers() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users");

    ref.onValue.listen((event) {
      userList = [];
      for (DataSnapshot snapshot in event.snapshot.children) {
        int? yasUser;

        yasUser = snapshot.child("dogum tarihi").value.toString() != ""
            ? DateTime.now().year -
                int.parse(snapshot
                    .child("dogum tarihi")
                    .value
                    .toString()
                    .substring(0, 4))
            : null;

        userList.add(AppUser(
            snapshot.child("isim").value.toString(),
            snapshot.child("soyisim").value.toString(),
            snapshot.child("gebelik haftasi").value.toString() != ""
                ? snapshot.child("gebelik haftasi").value.toString()
                : null,
            snapshot.child("creation").exists
                ? DateTime.fromMillisecondsSinceEpoch(
                    snapshot.child("creation").value as int)
                : null,
            yasUser,
            snapshot.child("email").value.toString(),
            snapshot.child("boy").value.toString() != ""
                ? (snapshot.child("boy").value is int
                    ? (snapshot.child("boy").value as int).toDouble()
                    : snapshot.child("boy").value as double)
                : null,
            snapshot.child("kilo").value.toString() != ""
                ? (snapshot.child("kilo").value is int
                    ? (snapshot.child("kilo").value as int).toDouble()
                    : snapshot.child("kilo").value as double)
                : null,
            snapshot.child("version").exists
                ? snapshot.child("version").value.toString()
                : null));
      }
      setState(() {});
    });
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

    kilo = kiloSnapshot.value is int
        ? (kiloSnapshot.value as int).toDouble()
        : kiloSnapshot.value as double;
    boy = boySnapshot.value is int
        ? (boySnapshot.value as int).toDouble()
        : boySnapshot.value as double;

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
    DatabaseReference ref1 = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot = await ref.child("version").get();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      ref1.update({"version": "Google Play " + packageInfo.version});
    } else {
      ref1.update({"version": "App Store " + packageInfo.version});
    }

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

    DatabaseReference refUzman =
        FirebaseDatabase.instance.ref("Users/ivkJYTY6fccl4LdGnYkxFCvUokL2");

    var snapshot1 = await ref.child("isim").get();
    var snapshot2 = await ref.child("soyisim").get();
    var snapshot3 = await ref.child("gebelik haftasi").get();

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
      videoItemList: videoItemList,
      userList: userList,
    );

    if (snapshot3.value.toString() == "36.hafta") {
      var snapshotBildirim = await ref.child("36haftaBildirim").get();

      widgetList[1] = Etkinlikler(shouldShow: true);
      shouldShow = true;

      if (!snapshotBildirim.exists) {
        var snapshotToken = await refUzman.child("token").get();

        sendNotification(snapshotToken.value.toString());
      }
    }
    setState(() {});
  }

  sendNotification(String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '36',
      'status': 'done',
      'message': "${name} ${surname} 36. gebelik haftasına girmiştir.",
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAABjSZRmg:APA91bHtoJHoE-syEJV-VWJO52mEaEUuBUCykmyrq8nojd_2WKNGPK3gA85p_AbKsM9AzuGLl-LjlcoJiyB-oG9UsExyOn5VEU50ktJ5yQWxqeJVb12ZAk_OrVm6MJegUzlZe-WknnF0'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'body': "${name} ${surname} 36. gebelik haftasına girmiştir.",
                  'title':
                      "${name} ${surname} 36. gebelik haftasına girmiştir.",
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");

        DatabaseReference ref = FirebaseDatabase.instance
            .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
        ref.update({"36haftaBildirim": true});
      } else {
        print("Error");
      }
    } catch (e) {}
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
      videoItemList: videoItemList,
      userList: userList,
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
                    currentScreen = MainPage(
                      videoItemList: videoItemList,
                    );
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
                      videoItemList: videoItemList,
                      userList: userList,
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

class AppUser {
  final String name, surname, email;
  final String? hafta, version;
  final int? yas;
  final double? boy, kilo;
  final DateTime? creation;

  AppUser(this.name, this.surname, this.hafta, this.creation, this.yas,
      this.email, this.boy, this.kilo, this.version);
}
