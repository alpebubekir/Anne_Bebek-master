import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SoruCevapla extends StatefulWidget {
  const SoruCevapla({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<SoruCevapla> createState() => _SoruCevaplaState();
}

class _SoruCevaplaState extends State<SoruCevapla> {
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
    // TODO: implement initState
    super.initState();
    getMesajlar();
  }

  void getMesajlar() {
    mesajlar = [];
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2/" + widget.uid);

    ref.onValue.listen((event) {
      for (DataSnapshot snapshot in event.snapshot.children) {
        print("sender Girdi");
        mesajlar.add(Mesaj(snapshot.child("sender").value.toString(),
            snapshot.child("text").value.toString()));
      }
      setState(() {});
    });
  }

  Widget item(Mesaj item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10, left: 15),
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
    );
  }

  Future<void> send() async {
    if (textController.text.isNotEmpty) {
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
        "text": textController.text.trim()
      });
      getMesajlar();
      textController.text = "";
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
      )),
    );
  }
}

class Mesaj {
  final String sender, text;

  Mesaj(this.sender, this.text);
}
