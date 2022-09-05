import 'package:flutter/material.dart';

import 'BottomNavigation.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.user}) : super(key: key);

  final AppUser user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kullanıcı Profili",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "(" + widget.user.name + ")",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              leading: Image.asset("images/profile_girl.png"),
              title: Text(widget.user.name + " " + widget.user.surname),
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
                      widget.user.boy != null
                          ? Text(
                              widget.user.boy!.toInt().toString() + "cm",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18),
                            )
                          : Text(
                              "?",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18),
                            ),
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
                      widget.user.kilo != null
                          ? Text(
                              widget.user.kilo!.toInt().toString() + "kg",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18),
                            )
                          : Text("?",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18)),
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
                      widget.user.yas != null
                          ? Text(
                              widget.user.yas.toString() + "y",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18),
                            )
                          : Text("?",
                              style: TextStyle(
                                  color: Color(0xff92A3FD), fontSize: 18)),
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
                    "Hesap Bilgileri",
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
                      widget.user.name + " " + widget.user.surname,
                      null),
                ),
                hesapItem(
                    Image.asset(
                      "images/icon_privacy.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    widget.user.email,
                    null),
                hesapItem(
                    Image.asset(
                      "images/icon_activity.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    widget.user.creation == null
                        ? "Katılım tarihi bilinmiyor."
                        : (widget.user.creation!.day < 10 ? "0" : "") +
                            widget.user.creation!.day.toString() +
                            "." +
                            (widget.user.creation!.month < 10 ? "0" : "") +
                            widget.user.creation!.month.toString() +
                            "." +
                            widget.user.creation!.year.toString() +
                            "'de katılmıştır.",
                    null),
                hesapItem(
                    Image.asset(
                      "images/icon_workout.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    widget.user.version != null
                        ? widget.user.version!
                        : "Versiyon bilinmiyor",
                    null),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
