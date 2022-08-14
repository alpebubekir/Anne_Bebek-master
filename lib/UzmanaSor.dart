import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    super.initState();
    getMesajlar();
  }

  Future<void> send() async {
    if (textController.text.isNotEmpty) {
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
        "text": textController.text.trim()
      });

      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final response = await http.post(url,
          headers: {
            "origin": "https://localhost",
            "Content-type": "application/json"
          },
          body: json.encode({
            "service_id": "service_jrhtfrc",
            "template_id": "template_582fvgd",
            "user_id": "q1EnVdTaxcUZlGOId",
            "template_params": {
              "username": widget.name,
              "message": textController.text
            }
          }));
      textController.text = "";
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
                  .toString()));
        }
      }
      print(mesajlar.length);
      setState(() {});
    });
  }

  Widget item(Mesaj item, double margin) {
    bool isUzman = item.sender == "Özge Karakaya Suzan" ? true : false;
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              item.sender,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
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
        ],
      ),
    );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 18,
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Soru-Cevap",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
