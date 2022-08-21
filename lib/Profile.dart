import 'package:anne_bebek/LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> deleteAccount() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabını sil'),
        content: Text(
            'Hesabınızı silmek istediğinizden emin misiniz? Bu bütün verilerinizi kalıcı olarak silecek!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(false),
              delete(),
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );

    return Future.value(false);
  }

  Future<void> delete() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    try {
      await FirebaseAuth.instance.currentUser!.delete();
      await ref.remove();
      Fluttertoast.showToast(
          msg: "Hesabınız başarılı bir şekilde silindi!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(context, MaterialPageRoute(builder: (route) => LogIn()));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Hesabınız silinemedi lütfen daha sonra tekrar deneyiniz!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg:
              "Not: Yeni oluşturuluan hesapların silinmesi için belirli bir süre geçmesi gerekir.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                  child: Text("Hesabımı sil"),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    deleteAccount();
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
