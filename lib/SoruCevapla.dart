import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class SoruCevapla extends StatefulWidget {
  const SoruCevapla(
      {Key? key,
      required this.uid,
      required this.email,
      required this.mesajlar,
      required this.token})
      : super(key: key);

  final String uid, email;
  final String? token;
  final List<Mesaj> mesajlar;

  @override
  State<SoruCevapla> createState() => _SoruCevaplaState();
}

class _SoruCevaplaState extends State<SoruCevapla> {
  List<Mesaj> mesajlar = [];
  var textController = TextEditingController();
  bool set = false;
  late DatabaseReference ref;

  late StreamSubscription onValue;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    super.initState();
    ref = FirebaseDatabase.instance
        .ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2/" + widget.uid);
    mesajlar = widget.mesajlar;
    setSeen();
    setState(() {});
  }

  void setSeen() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2/" + widget.uid);

    onValue = ref.onValue.listen((event) {
      for (DataSnapshot snapshot in event.snapshot.children) {
        if (snapshot.child("isSeen").exists &&
            !(snapshot.child("isSeen").value as bool && !set)) {
          set = true;
          snapshot.ref.update({"isSeen": true});
        }
      }
    });
  }

  void getMesajlar() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2/" + widget.uid);

    ref.onValue.listen((event) {
      mesajlar = [];
      for (DataSnapshot snapshot in event.snapshot.children) {
        print("sender Girdi");
        mesajlar.add(Mesaj(
            snapshot.child("sender").value.toString(),
            snapshot.child("text").value.toString(),
            snapshot.child("timestamp").exists
                ? DateTime.fromMillisecondsSinceEpoch(
                    snapshot.child("timestamp").value as int)
                : DateTime.utc(2022),
            snapshot.child("isSeen").exists
                ? snapshot.child("isSeen").value as bool
                : true));
      }
      setState(() {});
    });
  }

  Widget item(Mesaj item, double margin) {
    print(item.timestamp);
    bool isUzman = item.sender == "Özge Karakaya Suzan" ? true : false;
    return Container(
      width: double.infinity,
      alignment: isUzman ? Alignment.centerRight : Alignment.centerLeft,
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

  sendNotification(String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 'cevap',
      'status': 'done',
      'message': "Sorunuza cevap verildi.",
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
                  'body': "Sorunuza cevap verildi."
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

      String uid = widget.uid;
      var snapshot = await ref.child(uid).get();
      int count = 0;
      if (snapshot.exists) {
        count = snapshot.children.length;
      }

      await ref.child(uid).child(count.toString()).set({
        "sender": "Özge Karakaya Suzan",
        "text": text.trim(),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "isSeen": false
      });

      if (widget.token != null) {
        sendNotification(widget.token!);
      }

      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final response = await http.post(url,
          headers: {
            "origin": "https://localhost",
            "Content-type": "application/json"
          },
          body: json.encode({
            "service_id": "service_c7duzj6",
            "template_id": "template_z22oc1v",
            "user_id": "t4ni3-o8owmw2C4ge",
            "template_params": {
              "userEmail": widget.email,
            }
          }));
      getMesajlar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: textController,
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.2,
              child: ElevatedButton(
                  onPressed: () {
                    send();
                  },
                  child: Icon(Icons.send)))
        ],
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

class Mesaj {
  final String sender, text;
  final DateTime timestamp;
  bool isSeen;

  Mesaj(this.sender, this.text, this.timestamp, this.isSeen);
}
