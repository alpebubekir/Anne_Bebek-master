import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'Makaleler.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key, required this.item, required this.makaleList})
      : super(key: key);

  final List<Makale> makaleList;
  final Makale item;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  List<Makale> newsList = [];

  @override
  void initState() {
    getBenzer();
    super.initState();
  }

  Future<void> getBenzer() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Makaleler");
    var snapshot = await ref.get();
    int makaleLength = snapshot.children.length;

    var rng = Random();
    int item1Index = rng.nextInt(makaleLength);
    while (item1Index == widget.item.id) {
      item1Index = rng.nextInt(makaleLength);
    }
    int item2Index = rng.nextInt(makaleLength);
    while (item2Index == item1Index || item2Index == widget.item.id) {
      item2Index = rng.nextInt(makaleLength);
    }
    int i = 0;
    for (Makale item in widget.makaleList) {
      if (i == item2Index || i == item1Index) {
        newsList.add(item);
      }
      i++;
    }
    setState(() {});
  }

  Future<void> goToTextPage(Makale item) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
    ref.child("okunan").update({item.title: ""});

    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref("Makaleler/" + item.id);
    var snapshot = await ref1.child("view").get();

    ref1.update({"view": (snapshot.value as int) + 1});

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => TextPage(
                  item: item,
                  makaleList: widget.makaleList,
                )));
  }

  Widget item1Widget(Makale item) {
    return GestureDetector(
      onTap: () => goToTextPage(item),
      child: LayoutBuilder(
        builder: (context, constarints) {
          if (constarints.maxHeight < 760) {
            return Container(
              width: double.infinity,
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset("images/makale_first.png"),
                  ),
                  Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        /*Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff7B6F72)),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffC58BF2)),
                          borderRadius: BorderRadius.circular(360)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xffC58BF2),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset("images/makale_first.png"),
                  ),
                  Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        /*Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff7B6F72)),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffC58BF2)),
                          borderRadius: BorderRadius.circular(360)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xffC58BF2),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String stringFormatter(String s) {
    return s.replaceAll("/*", "\n");
  }

  @override
  // TODO: implement widget
  TextPage get widget => super.widget;

  void goToMakaleler() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => Makaleler(makaleList: widget.makaleList)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.95, 0.0),
                end: Alignment(1.0, 0.0),
                colors: [
                  const Color(0xff92A3FD),
                  const Color(0xff9DCEFF),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("images/" + widget.item.id + ".jpg"),
                          fit: BoxFit.cover)),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 33,
                          height: 33,
                          margin: EdgeInsets.only(top: 30, left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF7F8F8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.item.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      text: "by ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Özge Karakaya Suzan",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF92A3FD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Etiketler",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Anne",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Bağlanma",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Bebek",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Açıklama",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40, right: 30),
                        child: Text(
                          stringFormatter(widget.item.text),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 30, top: 40, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Benzer İçerikler",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: goToMakaleler,
                              child: Text(
                                "hepsi",
                                style: TextStyle(color: Color(0xffF2994A)),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xffF2994A),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsList.length == 0 ? 0 : 2,
                          itemBuilder: (BuildContext context, int index) {
                            return item1Widget(newsList[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        child: Container(
                          width: 316,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99.0),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Colors.transparent,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Center(
                              child: Text(
                                'Ana Sayfaya Geri Dön',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xffffffff),
                                  letterSpacing: -0.3858822937011719,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
