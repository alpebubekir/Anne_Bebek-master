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
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");

    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Users");

    ref.onValue.listen((event) {
      senders = [];
      if (event.snapshot.children.isNotEmpty) {
        for (DataSnapshot snapshot in event.snapshot.children) {
          String uid = snapshot.key.toString();

          DateTime sonMesaj = DateTime.utc(2022);

          List<Mesaj> mesajlar = [];

          int gorulmemis = 0;

          for (int i = 0; i < snapshot.children.length; i++) {
            DateTime timestamp;
            if (snapshot.child(i.toString()).child("timestamp").exists) {
              timestamp = DateTime.fromMillisecondsSinceEpoch(
                  snapshot.child(i.toString()).child("timestamp").value as int);

              if (sonMesaj.isBefore(timestamp)) {
                sonMesaj = timestamp;
                print(sonMesaj);
              }
            } else {
              timestamp = DateTime.utc(2022);
            }

            mesajlar.add(Mesaj(
                snapshot.child(i.toString()).child("sender").value.toString(),
                snapshot.child(i.toString()).child("text").value.toString(),
                timestamp,
                snapshot.child(i.toString()).child("isSeen").exists
                    ? snapshot.child(i.toString()).child("isSeen").value as bool
                    : true));
            if (!mesajlar[i].isSeen &&
                mesajlar[i].sender != "Özge Karakaya Suzan") {
              gorulmemis++;
            }
          }

          ref1.child(uid).onValue.listen((event) {
            print("girdi");
            bool exists = false;

            for (Kullanici k in senders) {
              if (k.uid == uid) {
                exists = true;
              }
            }

            if (!exists) {
              Kullanici kullanici = Kullanici(
                  uid,
                  event.snapshot.child("isim").value.toString(),
                  event.snapshot.child("soyisim").value.toString(),
                  event.snapshot.child("gebelik haftasi").value.toString(),
                  event.snapshot.child("email").value.toString(),
                  mesajlar,
                  event.snapshot.child("timestamp").value == null
                      ? DateTime.january.toString()
                      : event.snapshot.child("timestamp").value.toString(),
                  gorulmemis,
                  sonMesaj,
                  event.snapshot.child("token").exists
                      ? event.snapshot.child("token").value.toString()
                      : null);

              senders.add(kullanici);

              setState(() {
                senders.sort((a, b) => a.sonMesaj.compareTo(b.sonMesaj) * -1);
              });
            }
          });
        }
      }

      print("----------->" + senders.length.toString());
    });
  }

  Widget itemWidget(Kullanici item) {
    return GestureDetector(
      onTap: () {
        for (Mesaj m in item.mesajlar) {
          m.isSeen = true;
        }
        item.gorulmemis = 0;
        setState(() {});

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (route) => SoruCevapla(
                      uid: item.uid,
                      email: item.email,
                      mesajlar: item.mesajlar,
                      token: item.token,
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
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
                      item.gebelikHaftasi
                              .substring(0, item.gebelikHaftasi.indexOf(".")) +
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
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60,
              alignment: Alignment.centerLeft,
              child: Text(
                item.isim + " " + item.soyisim,
                style: TextStyle(fontSize: 18),
                maxLines: 2,
              ),
            ),
            Spacer(),
            item.gorulmemis == 0
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 60,
                    alignment: Alignment.center,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 60,
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Text(
                        item.gorulmemis.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: Colors.red),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF7F8F8),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Cevapla",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Colors.transparent,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: senders.length,
                itemBuilder: (BuildContext context, int index) {
                  return itemWidget(senders[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Kullanici {
  final String uid, isim, soyisim, gebelikHaftasi, email, time;
  final String? token;
  final List<Mesaj> mesajlar;
  int gorulmemis;
  final DateTime sonMesaj;

  Kullanici(this.uid, this.isim, this.soyisim, this.gebelikHaftasi, this.email,
      this.mesajlar, this.time, this.gorulmemis, this.sonMesaj, this.token);
}
