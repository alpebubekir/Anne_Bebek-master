import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      getMesajlar();
      textController.text = "";
    }
  }

  void getMesajlar() {
    mesajlar = [];
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    ref.onValue.listen((event) {
      if (event.snapshot.child(uid).exists) {
        print("dsadsadsad");
        for (int i = 0; i < event.snapshot.child(uid).children.length; i++) {
          print("------------------------------>");
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

  Widget item(Mesaj item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
                color: Colors.pinkAccent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mesajlar.length,
              itemBuilder: (BuildContext context, int index) {
                return item(mesajlar[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
