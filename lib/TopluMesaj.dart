import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TopluMesaj extends StatefulWidget {
  const TopluMesaj({Key? key}) : super(key: key);

  @override
  State<TopluMesaj> createState() => _TopluMesajState();
}

class _TopluMesajState extends State<TopluMesaj> {
  List<String> uidList = [];
  var controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUids();
  }

  getUids() {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref("Users");

    usersRef.onValue.listen((event) {
      for (DataSnapshot user in event.snapshot.children) {
        uidList.add(user.key.toString());
      }
    });
  }

  Future<void> send() async {
    DatabaseReference uzmanRef =
        FirebaseDatabase.instance.ref("Uzman/ivkJYTY6fccl4LdGnYkxFCvUokL2");

    for (String uid in uidList) {
      int count = 0;
      var snapshot = await uzmanRef.child(uid).once(DatabaseEventType.value);

      snapshot.snapshot.exists
          ? count = snapshot.snapshot.children.length
          : null;

      uzmanRef.child(uid).update({
        (count).toString(): {
          "isSeen": false,
          "sender": "Özge Karakaya Suzan",
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "text": controller.text
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Toplu Mesaj Gönder"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 2)),
                height: MediaQuery.of(context).size.height * 0.4,
                child: TextField(
                  controller: controller,
                  maxLines: 30,
                  decoration: InputDecoration(
                      hintText: "Mesajınız", border: InputBorder.none),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
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
                    onPressed: send,
                    child: Center(
                      child: Text(
                        'Gönder',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
