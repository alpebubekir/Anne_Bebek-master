import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _passwordVisible = false;
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorText = "", errorText1 = "";

  var cred;
  Future<void> changePassword() async {
    bool validate = formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    if (passwordController1.text != passwordController2.text) {
      errorText = "Şifre tekrarı farklı olamaz!";
      setState(() {});
      return;
    }

    if (passwordController.text == passwordController1.text) {
      Fluttertoast.showToast(
          msg: "Yeni şifreniz eski şifreniz ile aynı olamaz!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    final user = await FirebaseAuth.instance.currentUser;
    cred = EmailAuthProvider.credential(
        email: user!.email!, password: passwordController.text);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(passwordController1.text).then((_) {
        Fluttertoast.showToast(
            msg: "Şifreniz başarılı bir şekilde değiştirildi.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }).catchError((err) {
      errorText1 = "Lütfen şifrenizi doğru girdiğinizden emin olunuz!";
      setState(() {});
      return;
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void dispose() {
    passwordController1.dispose();
    passwordController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Şifre değiştir",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 316,
                height: 70,
                child: TextField(
                  onChanged: (value) {
                    errorText1 = "";
                    setState(() {});
                  },
                  obscureText: true,
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    helperText: " ",
                    errorText: errorText1,
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 15.0,
                    ),
                    border: InputBorder.none,
                    labelText: "Şuanki şifre",
                    labelStyle: TextStyle(
                      color: Color(0xFF898182),
                      fontSize: 12.0,
                    ),
                    fillColor: Color(0xFFF4F4F4),
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 316,
                height: 70,
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    helperText: " ",
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 15.0,
                    ),
                    border: InputBorder.none,
                    labelText: "Yeni şifre",
                    labelStyle: TextStyle(
                      color: Color(0xFF898182),
                      fontSize: 12.0,
                    ),
                    fillColor: Color(0xFFF4F4F4),
                    filled: true,
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'En az 6 karakter içermelidir'
                      : null,
                ),
              ),
              SizedBox(
                width: 316,
                height: 70,
                child: TextFormField(
                  onChanged: (value) {
                    errorText = "";
                    setState(() {});
                  },
                  controller: passwordController2,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    helperText: " ",
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 15.0,
                    ),
                    border: InputBorder.none,
                    errorText: errorText,
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Yeni şifre tekrarı",
                    labelStyle: TextStyle(
                      color: Color(0xFF898182),
                      fontSize: 12.0,
                    ),
                    fillColor: Color(0xFFF4F4F4),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFFF4F4F4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
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
                  onPressed: changePassword,
                  child: Center(
                    child: Text(
                      'Şifre değiştir',
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
            ],
          ),
        ),
      ),
    );
  }
}
