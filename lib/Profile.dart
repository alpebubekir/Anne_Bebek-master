import 'package:anne_bebek/LogIn.dart';
import 'package:anne_bebek/UzmanCevapla.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isUzman = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIsUzman();
  }

  void getIsUzman() {
    isUzman = FirebaseAuth.instance.currentUser!.uid ==
                "ivkJYTY6fccl4LdGnYkxFCvUokL2" ||
            FirebaseAuth.instance.currentUser!.uid ==
                "z5MhoCKtOjV8yGfQfySRBfjdn1y1"
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.95, 0.0),
                end: Alignment(1.0, 0.0),
                colors: [
                  const Color(0xff9DCEFF),
                  const Color(0xff92A3FD),
                ],
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: ElevatedButton(
              child: Text("Çıkış Yap"),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (route) => LogIn()));
              },
            ),
          ),
        ),
        isUzman
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.95, 0.0),
                      end: Alignment(1.0, 0.0),
                      colors: [
                        const Color(0xff9DCEFF),
                        const Color(0xff92A3FD),
                      ],
                      stops: [0.0, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    child: Text("Soruları cevapla"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (route) => UzmanCevapla()));
                    },
                  ),
                ),
              )
            : SizedBox(),
      ],
    ));
  }
}
