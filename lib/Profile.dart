import 'package:anne_bebek/ChangePassword.dart';
import 'package:anne_bebek/LogIn.dart';
import 'package:anne_bebek/UserProfile.dart';
import 'package:anne_bebek/Web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'BottomNavigation.dart';
import 'MainPage.dart';

class Profile extends StatefulWidget {
  const Profile(
      {Key? key,
      required this.name,
      required this.surname,
      required this.kilo,
      required this.boy,
      required this.yas,
      required this.isUzman,
      required this.bildirimList,
      required this.videoItemList,
      required this.userList})
      : super(key: key);

  final String name, surname;
  final int? yas;
  final double? kilo, boy;
  final bool isUzman;
  final List<Bildirim> bildirimList;
  final List<VideoItem> videoItemList;
  final List<AppUser> userList;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool status = true;
  int selected = 0;
  String baslik = "Profil";
  List<VideoItem> videoItemList = [];

  @override
  void initState() {
    super.initState();
    videoItemList = widget.videoItemList;
  }

  Future<void> refreshVideo() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");

    ref.onValue.listen((event) async {
      videoItemList = [];
      DatabaseReference refUser = FirebaseDatabase.instance.ref("Users");
      for (DataSnapshot snapshot in event.snapshot.children) {
        List<Viewer> viewerList = [];

        for (DataSnapshot viewer in snapshot.child("viewer").children) {
          String uid = viewer.key.toString();
          var gebelik =
              await refUser.child(uid).child("gebelik haftasi guncel").get();

          if (!gebelik.exists) {
            gebelik = await refUser.child(uid).child("gebelik haftasi").get();
          }

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
    });
  }

  Future<void> deleteAccount() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabını sil'),
        content: Text(
            'Hesabınızı silmek istediğinizden emin misiniz? Bu bütün verilerinizi kalıcı olarak silecek!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(false),
              delete(),
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );

    return Future.value(false);
  }

  Future<void> delete() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    try {
      await FirebaseAuth.instance.currentUser!.delete();
      await ref.remove();
      Fluttertoast.showToast(
          msg: "Hesabınız başarılı bir şekilde silindi!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(context, MaterialPageRoute(builder: (route) => LogIn()));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Hesabınız silinemedi lütfen daha sonra tekrar deneyiniz!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg:
              "Not: Yeni oluşturuluan hesapların silinmesi için belirli bir süre geçmesi gerekir.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget hesapItem(Image image, String title, Widget? goTo) {
    return GestureDetector(
      onTap: () {
        if (goTo != null) {
          Navigator.push(context, MaterialPageRoute(builder: (route) => goTo));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            image,
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: Color(0xff7B6F72)),
              ),
            ),
            Spacer(),
            goTo == null ? Container() : Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }

  Widget navigationBar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              selected = 0;
              baslik = "Profil";
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.19,
              child: Column(
                children: [
                  Text(
                    "Profil",
                    style: TextStyle(fontSize: 14, color: Color(0xff555B6A)),
                  ),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selected == 0
                            ? Color(0xffF28F8F)
                            : Colors.transparent),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              selected = 1;
              baslik = "Log Yönetimi";
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.19,
              child: Column(
                children: [
                  Text(
                    "Log Yönetimi",
                    style: TextStyle(fontSize: 14, color: Color(0xff555B6A)),
                  ),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selected == 1
                            ? Color(0xffF28F8F)
                            : Colors.transparent),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              selected = 2;
              baslik = "Video İzlenme";
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.19,
              child: Column(
                children: [
                  Text(
                    "Video İzlenme",
                    style: TextStyle(fontSize: 14, color: Color(0xff555B6A)),
                  ),
                  Container(
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selected == 2
                              ? Color(0xffF28F8F)
                              : Colors.transparent))
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              selected = 3;
              baslik = "Kullanıcılar";
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 0.19,
              child: Column(
                children: [
                  Text(
                    "Kullanıcılar",
                    style: TextStyle(fontSize: 14, color: Color(0xff555B6A)),
                  ),
                  Container(
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selected == 3
                              ? Color(0xffF28F8F)
                              : Colors.transparent))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemUser(AppUser user) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (route) => UserProfile(user: user))),
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 60,
                  alignment: Alignment.center,
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.hafta == null
                              ? "?"
                              : user.hafta!
                                      .substring(0, user.hafta!.indexOf(".")) +
                                  ".",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Haf",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(360)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 80,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        user.name + " " + user.surname,
                        style: TextStyle(fontSize: 18),
                        maxLines: 2,
                      ),
                      Text(
                        user.creation != null
                            ? (user.creation!.day < 10 ? "0" : "") +
                                user.creation!.day.toString() +
                                "." +
                                (user.creation!.month < 10 ? "0" : "") +
                                user.creation!.month.toString() +
                                "." +
                                user.creation!.year.toString()
                            : "",
                        style: TextStyle(color: Color(0xff7B6F72)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }

  Widget selected_3() {
    return Container(
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.userList.length,
            itemBuilder: (context, index) {
              return itemUser(widget.userList[index]);
            }));
  }

  Widget selected_0() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            leading: Image.asset("images/profile_girl.png"),
            title: Text(widget.name + " " + widget.surname),
            subtitle: Text("Uygulama katılımcısı"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 80,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    widget.boy != null
                        ? Text(
                            widget.boy!.toInt().toString() + "cm",
                            style: TextStyle(
                                color: Color(0xff92A3FD), fontSize: 18),
                          )
                        : CircularProgressIndicator(),
                    Spacer(),
                    Text("Boy"),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 80,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    widget.kilo != null
                        ? Text(
                            widget.kilo!.toInt().toString() + "kg",
                            style: TextStyle(
                                color: Color(0xff92A3FD), fontSize: 18),
                          )
                        : CircularProgressIndicator(),
                    Spacer(),
                    Text("Kilo"),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 80,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    widget.yas != null
                        ? Text(
                            widget.yas.toString() + "y",
                            style: TextStyle(
                                color: Color(0xff92A3FD), fontSize: 18),
                          )
                        : CircularProgressIndicator(),
                    Spacer(),
                    Text("Yaş"),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(22)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hesap",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: hesapItem(
                    Image.asset(
                      "images/icon_profile.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    "Kişisel Veri",
                    Web(url: "http://cetinkaraca.com.tr/kvkk.html")),
              ),
              hesapItem(
                  Image.asset(
                    "images/icon_privacy.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  "Şifre Değiştir",
                  ChangePassword()),
              /*hesapItem(
                  Image.asset(
                    "images/icon_activity.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  "Etkinlik Geçmişi",
                  null),
              hesapItem(
                  Image.asset(
                    "images/icon_workout.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  "Katılım Geçmişi",
                  null),*/
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (route) => LogIn()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 30,
                        color: Color(0xff92A3FD),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Çıkış yap",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff7B6F72)),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  deleteAccount();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_forever,
                        size: 30,
                        color: Color(0xff92A3FD),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Hesabımı sil",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff7B6F72)),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(22)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bildirimler",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/icon_notify.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Bildirim Gönder",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff7B6F72)),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-0.95, 0.0),
                              end: Alignment(1.0, 0.0),
                              colors: [
                                const Color(0xffC58BF2),
                                const Color(0xffEEA4CE),
                              ],
                              stops: [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: FlutterSwitch(
                          value: status,
                          activeColor: Colors.transparent,
                          borderRadius: 30.0,
                          onToggle: (val) {
                            setState(() {
                              status = val;
                            });
                            /*Fluttertoast.showToast(
                                      msg: "Çok yakında!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0);*/
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(22)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Yetkili İletişim",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: hesapItem(
                    Image.asset(
                      "images/icon_message.png",
                      color: Colors.transparent,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    "Özge Karakaya Suzan",
                    null),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/icon_message.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "ozgekarakayasuzan@sakarya.edu.tr",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff7B6F72)),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget itemViewer(String name, String gebelik) {
    print("-------->" + name + " " + gebelik);
    return Column(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 60,
                alignment: Alignment.center,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-0.95, 0.0),
                        end: Alignment(1.0, 0.0),
                        colors: [
                          const Color(0xffC58BF2),
                          const Color(0xffEEA4CE),
                        ],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(360)),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        gebelik.substring(0, gebelik.indexOf(".")) + ".",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Haf",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
          indent: 10,
          endIndent: 10,
        )
      ],
    );
  }

  void bottomSheet(List<Viewer> viewerList) {
    print(viewerList.length);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Görüntüleyenler",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Image.asset("images/bottom_close.png"))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: viewerList.length,
                      itemBuilder: (context, index) {
                        return itemViewer(
                            viewerList[index].name, viewerList[index].hafta);
                      },
                    ),
                  ),
                ],
              ));
        });
  }

  Widget itemVideo(VideoItem item) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            bottomSheet(item.viewerList);
          },
          child: Container(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 80,
                  alignment: Alignment.center,
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    child: Image.asset("images/video_izlenme.png"),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.95, 0.0),
                          end: Alignment(1.0, 0.0),
                          colors: [
                            const Color(0xff92A3FD).withOpacity(0.2),
                            const Color(0xff9DCEFF).withOpacity(0.2),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(360)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 80,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        item.id + "-" + item.title,
                        style: TextStyle(fontSize: 18),
                        maxLines: 2,
                      ),
                      Text(
                        item.view.toString() + " görüntülenme",
                        style: TextStyle(color: Color(0xff7B6F72)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Widget itemBildirim(
      String title, String subtitle, String time, bool faydali) {
    return Container(
      height: 90,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        '"${title}" Değerlendirildi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                            color: faydali ? Colors.green : Colors.red),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 70,
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8), child: Text(time)),
              ),
            ],
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }

  Widget selected_2() {
    return Container(
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: videoItemList.length,
            itemBuilder: (context, index) {
              return itemVideo(videoItemList[index]);
            }));
  }

  Widget selected_1() {
    print(widget.bildirimList.length);
    return Container(
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.bildirimList.length,
            itemBuilder: (context, index) {
              DateTime date = DateTime.fromMillisecondsSinceEpoch(
                  widget.bildirimList[index].time);

              String faydali = widget.bildirimList[index].like
                  ? "videoyu faydalı buldu."
                  : "videoyu faydalı bulmadı.";
              return itemBildirim(
                  widget.bildirimList[index].video,
                  widget.bildirimList[index].kisi + " " + faydali,
                  timeago.format(date, locale: 'tr'),
                  widget.bildirimList[index].like);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selected == 2
          ? RefreshIndicator(
              onRefresh: refreshVideo,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                baslik,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      widget.isUzman ? navigationBar() : Container(),
                      selected == 0
                          ? selected_0()
                          : selected == 1
                              ? selected_1()
                              : selected == 2
                                  ? selected_2()
                                  : selected_3()
                    ],
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              baslik,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    widget.isUzman ? navigationBar() : Container(),
                    selected == 0
                        ? selected_0()
                        : selected == 1
                            ? selected_1()
                            : selected == 2
                                ? selected_2()
                                : selected_3()
                  ],
                ),
              ),
            ),
    );
  }
}

class Bildirim {
  final String kisi, video;
  final int time;
  final bool like;

  Bildirim(this.kisi, this.time, this.video, this.like);
}

/*Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.95, 0.0),
                    end: Alignment(1.0, 0.0),
                    colors: [
                      const Color(0xff9DCEFF),
                      const Color(0xff92A3FD),
                    ],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ElevatedButton(
                  child: Text("Çıkış Yap"),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (route) => LogIn()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.95, 0.0),
                      end: Alignment(1.0, 0.0),
                      colors: [
                        const Color(0xff9DCEFF),
                        const Color(0xff92A3FD),
                      ],
                      stops: [0.0, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    child: Text("Hesabımı sil"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      deleteAccount();
                    },
                  ),
                ),
              )*/
