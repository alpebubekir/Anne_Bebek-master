import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'SignUp.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          //Giriş yap
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  TapGestureRecognizer goToForgotPassword() {
    //"Şifremi Unuttum" onClick
    return (TapGestureRecognizer()
      ..onTap = () {
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPassword()),
        );*/
      });
  }

  TapGestureRecognizer goToSignUp() {
    //"Hesap oluştur" onClick
    return (TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Scaffold(
        body: Container(
            child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 40.0,
                    ),
                    child: SizedBox(
                      width: 72,
                      height: 24,
                      child: Text(
                        "Merhaba",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 6.0,
                      bottom: 35,
                    ),
                    child: SizedBox(
                      width: 110,
                      height: 30,
                      child: Text(
                        "Hoş Geldin",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 316,
                    height: 48,
                    child: TextField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color(0xFF898182),
                          fontSize: 12.0,
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          size: 15.0,
                        ),
                        border: InputBorder.none,
                        labelText: "Email",
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: SizedBox(
                      width: 316,
                      height: 48,
                      child: TextField(
                        obscureText: !_passwordVisible,
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Color(0xFF898182),
                            fontSize: 12.0,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 15.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                              size: 20,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          labelText: "Password",
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: new Text(
                      "Şifremi Unutum",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFBFBFBF),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 285,
                    ),
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
                        onPressed: signIn,
                        child: Center(
                          child: Text(
                            'Giriş',
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: SizedBox(
                      width: 316,
                      child: Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Text(
                          "&",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1D1617),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                    ),
                    child: SizedBox(
                      width: 246,
                      height: 35,
                      child: Row(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Henüz bir hesabın yok mu? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) => SignUp()));
                            },
                            child: Text(
                                textAlign: TextAlign.center,
                                "Kayıt ol",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFFC58BF2))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
