import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
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
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
    ));
  }
}
