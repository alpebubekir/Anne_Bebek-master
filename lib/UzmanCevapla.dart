import 'package:anne_bebek/SoruCevapla.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UzmanCevapla extends StatefulWidget {
  const UzmanCevapla({Key? key}) : super(key: key);

  @override
  State<UzmanCevapla> createState() => _UzmanCevaplaState();
}

class _UzmanCevaplaState extends State<UzmanCevapla> {
  List<Kullanici> senders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSorular();
  }

  void getSorular() {
    senders = [];
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");

    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Users");

    ref.onValue.listen((event) {
      if (event.snapshot.children.isNotEmpty) {
        for (DataSnapshot snapshot in event.snapshot.children) {
          String uid = snapshot.key.toString();
          print(uid);
          ref1.child(uid).onValue.listen((event) {
            print("girdi");
            senders.add(Kullanici(
                uid,
                event.snapshot.child("isim").value.toString(),
                event.snapshot.child("soyisim").value.toString(),
                event.snapshot.child("gebelik haftasi").value.toString()));
            setState(() {});
          });
        }
      }
      print("----------->" + senders.length.toString());
    });
  }

  Widget itemWidget(Kullanici item) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (route) => SoruCevapla(uid: item.uid))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Ad"),
                  Text(
                    item.isim + " ",
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Soyad"),
                  Text(
                    item.soyisim,
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Gebelik Haftası"),
                  Text(
                    item.gebelikHaftasi,
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: senders.length,
          itemBuilder: (BuildContext context, int index) {
            return itemWidget(senders[index]);
          },
        ),
      ),
    );
  }
}

class Kullanici {
  final String uid, isim, soyisim, gebelikHaftasi;

  Kullanici(this.uid, this.isim, this.soyisim, this.gebelikHaftasi);
}
