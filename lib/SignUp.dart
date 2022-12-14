import 'package:anne_bebek/LogIn.dart';
import 'package:anne_bebek/MoreInformation.dart';
import 'package:anne_bebek/Web.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  bool _passwordVisible = false;
  late TapGestureRecognizer tapGestureRecognizer;
  late TapGestureRecognizer tapGestureRecognizer1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (route) =>
                    Web(url: "https://cetinkaraca.com.tr/kvkk.html")));
      };
    tapGestureRecognizer1 = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (route) => Web(
                    url:
                        "https://cetinkaraca.com.tr/tibbi-sorumluluk-reddi.html")));
      };
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    tapGestureRecognizer.dispose();
    tapGestureRecognizer1.dispose();

    super.dispose();
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (!isChecked) {
      Fluttertoast.showToast(
          msg: "Hesap olu??turmak i??in ayd??nlatma metnini okuyup onaylay??n??z.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text
              .trim()); //Girilen bilgilere g??re bir kullan??c?? olu??turuldu

      await FirebaseAuth.instance
          .signOut(); //??nceden giri?? yap??lm???? ise ????k???? yap??ld??

      var firebase = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text
              .trim()); //Kay??t yap??lan hesaba giri?? yap??ld??

      DatabaseReference ref = FirebaseDatabase.instance.ref("Users");

      await ref.child(firebase.user!.uid).set({
        "isim": nameController.text.trim(),
        "soyisim": surnameController.text.trim(),
        "email": firebase.user!.email,
        "gebelik haftasi": "",
        "dogum tarihi": "",
        "kilo": "",
        "boy": ""
      });

      Fluttertoast.showToast(
          msg: "Hesap ba??ar??l?? bir ??ekilde olu??turuldu.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MoreInformation()));
    } on FirebaseAuthException catch (e) {
      print(e);

      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: e.message.toString(),
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
      width: double.infinity,
      color: Colors.white,
      child: Scaffold(
        body: Container(
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxHeight < 760) {
              return Container(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40.0,
                          ),
                          child: SizedBox(
                            child: Text(
                              "Merhaba",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 6.0,
                            bottom: 29,
                          ),
                          child: SizedBox(
                            child: Text(
                              "Hesap olu??tur",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 316,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 316,
                                  height: 70,
                                  child: TextFormField(
                                    controller: nameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      helperText: " ",
                                      labelStyle: TextStyle(
                                        color: Color(0xFF898182),
                                        fontSize: 12.0,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 15.0,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Ad??n",
                                      fillColor: Color(0xFFF4F4F4),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFF4F4F4)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.length < 1
                                            ? 'Ad k??sm?? bo?? b??rak??lamaz!'
                                            : null,
                                  ),
                                ),
                                SizedBox(
                                  width: 316,
                                  height: 70,
                                  child: TextFormField(
                                    controller: surnameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      helperText: " ",
                                      labelStyle: TextStyle(
                                        color: Color(0xFF898182),
                                        fontSize: 12.0,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 15.0,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Soyad??n",
                                      fillColor: Color(0xFFF4F4F4),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFF4F4F4)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.length < 1
                                            ? 'Soyad k??sm?? bo?? b??rak??lamaz!'
                                            : null,
                                  ),
                                ),
                                SizedBox(
                                  width: 316,
                                  height: 70,
                                  child: TextFormField(
                                    controller: emailController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      helperText: " ",
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
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFF4F4F4)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? 'Ge??erli bir email adresi giriniz!'
                                        : null,
                                  ),
                                ),
                                SizedBox(
                                  width: 316,
                                  height: 70,
                                  child: TextFormField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      helperText: " ",
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 15.0,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                        color: Color(0xFF898182),
                                        fontSize: 12.0,
                                      ),
                                      fillColor: Color(0xFFF4F4F4),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFF4F4F4)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.length < 6
                                            ? 'En az 6 karakter i??ermelidir'
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                    width: 1.0,
                                    color: Color(0xFFBFBFBF),
                                  ),
                                ),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() => isChecked = value!);
                                },
                                activeColor: Color(0xFF92A3FD),
                                checkColor: Color(0xFFF4F4F4),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: "Gizlilik ve G??venlik ",
                                          recognizer: tapGestureRecognizer,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFBFBFBF),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "ve ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFBFBFBF),
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: "T??bbi sorumluluk reddi ",
                                          recognizer: tapGestureRecognizer1,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFBFBFBF),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "'ni okudum ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFBFBFBF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "ve kabul ediyorum ",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFBFBFBF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            width: 316,
                            height: 40,
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
                              onPressed: signUp,
                              child: Center(
                                child: Text(
                                  'Kay??t ol',
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
                            bottom: 40,
                          ),
                          child: SizedBox(
                            width: 210,
                            height: 40,
                            child: Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Kay??tl?? kullan??c?? m??s??n?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => LogIn()));
                                  },
                                  child: Text("Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFC58BF2))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
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
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 6.0,
                              bottom: 29,
                            ),
                            child: SizedBox(
                              width: 142,
                              height: 30,
                              child: Text(
                                "Hesap olu??tur",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 316,
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 316,
                                    height: 70,
                                    child: TextFormField(
                                      controller: nameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        helperText: " ",
                                        labelStyle: TextStyle(
                                          color: Color(0xFF898182),
                                          fontSize: 12.0,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          size: 15.0,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Ad??n",
                                        fillColor: Color(0xFFF4F4F4),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xFFF4F4F4)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 1
                                              ? 'Ad k??sm?? bo?? b??rak??lamaz!'
                                              : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 316,
                                    height: 70,
                                    child: TextFormField(
                                      controller: surnameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        helperText: " ",
                                        labelStyle: TextStyle(
                                          color: Color(0xFF898182),
                                          fontSize: 12.0,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          size: 15.0,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Soyad??n",
                                        fillColor: Color(0xFFF4F4F4),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xFFF4F4F4)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 1
                                              ? 'Soyad k??sm?? bo?? b??rak??lamaz!'
                                              : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 316,
                                    height: 70,
                                    child: TextFormField(
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        helperText: " ",
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
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xFFF4F4F4)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? 'Ge??erli bir eposta adresi giriniz'
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 316,
                                    height: 70,
                                    child: TextFormField(
                                      controller: passwordController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        helperText: " ",
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 15.0,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          color: Color(0xFF898182),
                                          fontSize: 12.0,
                                        ),
                                        fillColor: Color(0xFFF4F4F4),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xFFF4F4F4)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 6
                                              ? 'En az 6 karakter i??ermelidir'
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: SizedBox(
                              width: 316,
                              child: Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFFBFBFBF),
                                      ),
                                    ),
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() => isChecked = value!);
                                    },
                                    activeColor: Color(0xFF92A3FD),
                                    checkColor: Color(0xFFF4F4F4),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: "Gizlilik ve G??venlik ",
                                              recognizer: tapGestureRecognizer,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFFBFBFBF),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "ve ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFBFBFBF),
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: "T??bbi sorumluluk reddi ",
                                              recognizer: tapGestureRecognizer1,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFFBFBFBF),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "'ni okudum ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFBFBFBF),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "ve kabul ediyorum ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFBFBFBF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 147,
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
                                onPressed: signUp,
                                child: Center(
                                  child: Text(
                                    'Kay??t ol',
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
                              width: 210,
                              height: 40,
                              child: Row(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    "Kay??tl?? kullan??c?? m??s??n?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => LogIn()));
                                    },
                                    child: Text("Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFC58BF2))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
