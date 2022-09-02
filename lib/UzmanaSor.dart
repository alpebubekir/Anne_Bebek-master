import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

import 'SoruCevapla.dart';

class UzmanaSor extends StatefulWidget {
  const UzmanaSor({Key? key, required this.name, required this.surname})
      : super(key: key);

  final String name, surname;

  @override
  State<UzmanaSor> createState() => _UzmanaSorState();
}

class _UzmanaSorState extends State<UzmanaSor> {
  List<Mesaj> mesajlar = [];
  var textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    super.initState();
    getMesajlar();
  }

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 'sor',
      'status': 'done',
      'message': "Bir soru soruldu.",
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
                  'title': "Anne Bebek Bağlanması",
                  'body': "Bir soru soruldu"
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  Future<void> send() async {
    if (textController.text.isNotEmpty) {
      String text = textController.text;
      textController.text = "";
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");

      String uid = FirebaseAuth.instance.currentUser!.uid;
      var snapshot = await ref.child(uid).get();
      int count = 0;
      if (snapshot.exists) {
        count = snapshot.children.length;
      }

      await ref.child(uid).child(count.toString()).set({
        "sender": widget.name + " " + widget.surname,
        "text": text.trim(),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "isSeen": false
      });

      DatabaseReference ref1 =
          FirebaseDatabase.instance.ref("Users/ivkJYTY6fccl4LdGnYkxFCvUokL2");

      var snapshot1 = await ref1.child("token").get();

      if (snapshot1.exists) {
        sendNotification("Anne Bebek Bağlanması", snapshot1.value.toString());
      }

      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final response = await http.post(url,
          headers: {
            "origin": "https://localhost",
            "Content-type": "application/json"
          },
          body: json.encode({
            "service_id": "service_c7duzj6",
            "template_id": "template_xdsjfgs",
            "user_id": "t4ni3-o8owmw2C4ge",
            "template_params": {"username": widget.name, "message": text}
          }));
      getMesajlar();
    }
  }

  void getMesajlar() {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    ref.onValue.listen((event) {
      mesajlar = [];
      if (event.snapshot.child(uid).exists) {
        for (int i = 0; i < event.snapshot.child(uid).children.length; i++) {
          mesajlar.add(Mesaj(
              event.snapshot
                  .child(uid)
                  .child(i.toString())
                  .child("sender")
                  .value
                  .toString(),
              event.snapshot
                  .child(uid)
                  .child(i.toString())
                  .child("text")
                  .value
                  .toString(),
              event.snapshot
                      .child(uid)
                      .child(i.toString())
                      .child("timestamp")
                      .exists
                  ? DateTime.fromMillisecondsSinceEpoch((event.snapshot
                      .child(uid)
                      .child(i.toString())
                      .child("timestamp")
                      .value as int))
                  : DateTime.utc(2022),
              event.snapshot
                      .child(uid)
                      .child(i.toString())
                      .child("isSeen")
                      .exists
                  ? event.snapshot
                      .child(uid)
                      .child(i.toString())
                      .child("isSeen")
                      .value as bool
                  : true));
        }
      }
      print(mesajlar.length);
      setState(() {});
    });
  }

  Widget item(Mesaj item, double margin) {
    bool isUzman = item.sender == "Özge Karakaya Suzan" ? true : false;
    return Container(
      width: double.infinity,
      alignment: isUzman ? Alignment.centerLeft : Alignment.centerRight,
      margin: EdgeInsets.only(bottom: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              item.sender,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isUzman ? Colors.blueAccent : Colors.pinkAccent),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item.text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          item.timestamp == DateTime.utc(2022)
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    timeago.format(item.timestamp, locale: 'tr'),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffE1E1E1))),
                padding: EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                      hintText: "Mesaj yaz",
                      hintStyle: TextStyle(color: Color(0xffB1A7A7)),
                      border: InputBorder.none),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      color: Colors.green),
                  child: IconButton(
                      onPressed: () {
                        send();
                      },
                      icon: Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      )))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 18,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Soru-Cevap",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mesajlar.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == mesajlar.length - 1) {
                  return item(mesajlar[index], 80);
                }
                return item(mesajlar[index], 20);
              },
            ),
          ),
        ),
      ),
    );
  }
}
