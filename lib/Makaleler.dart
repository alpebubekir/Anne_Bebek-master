import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'TextPage.dart';

class Makaleler extends StatefulWidget {
  const Makaleler({Key? key, required this.makaleList}) : super(key: key);

  final List<Makale> makaleList;

  @override
  State<Makaleler> createState() => _MakalelerState();
}

class _MakalelerState extends State<Makaleler> {
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

  Widget makaleWidget(Makale item) {
    return GestureDetector(
      onTap: () => goToTextPage(item),
      child: Container(
        width: double.infinity,
        height: 120,
        child: Row(
          children: [
            Container(
              height: 80,
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset(
                "images/" + item.id + ".jpg",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "??zge Karakaya Suzan",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    item.view.toString() + " g??r??nt?? - 1 hafta ??nce",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ],
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
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Makaleler",
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
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.makaleList.length,
                itemBuilder: (BuildContext context, int index) {
                  return makaleWidget(widget.makaleList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
