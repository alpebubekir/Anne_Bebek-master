import 'package:anne_bebek/GoToMain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreInformation extends StatefulWidget {
  const MoreInformation({Key? key}) : super(key: key);

  @override
  State<MoreInformation> createState() => _MoreInformationState();
}

class _MoreInformationState extends State<MoreInformation> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _date = TextEditingController();
  late String hafta;
  var kiloController = TextEditingController();
  var boyController = TextEditingController();
  late String name;

  @override
  void initState() {
    getName();
    super.initState();
  }

  Future<void> getName() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot = await ref.child("isim").get();

    name = snapshot.value.toString();

    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("moreInformation", false);

    prefs.setString("uid", FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void dispose() {
    kiloController.dispose();
    boyController.dispose();
    _date.dispose();

    super.dispose();
  }

  Future<void> nextPage() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    print("dadasd");

    if (!hafta.isEmpty) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

      ref.update({
        "gebelik haftasi": hafta,
        "dogum tarihi": _date.text,
        "kilo": double.parse(kiloController.text),
        "boy": double.parse(boyController.text)
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (route) => GoToMain(
                    name: name,
                  )));
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("moreInformation", true);
    } else {
      Fluttertoast.showToast(
          msg: "Gebelik haftasını seçiniz.",
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
        const Locale('en', 'US'),
      ],
      locale: Locale('tr'),
      home: Scaffold(
        body: Container(
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxHeight < 760) {
              return Container(
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  alignment: Alignment.bottomCenter,
                                  image: AssetImage(
                                    "images/more_information.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.75,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 50,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 315,
                                      height: 48,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4F4F4),
                                            border: Border.all(
                                              color: Color(0xFFF4F4F4),
                                              width: 3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.people),
                                            ),
                                            hint: Text(
                                              "Gebelik Haftası",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            iconSize: 14,
                                            items: <String>[
                                              '1.hafta',
                                              '2.hafta',
                                              '3.hafta',
                                              '4.hafta',
                                              '5.hafta',
                                              '6.hafta',
                                              '7.hafta',
                                              '8.hafta',
                                              '9.hafta',
                                              '10.hafta',
                                              '11.hafta',
                                              '12.hafta',
                                              '13.hafta',
                                              '14.hafta',
                                              '15.hafta',
                                              '16.hafta',
                                              '17.hafta',
                                              '18.hafta',
                                              '19.hafta',
                                              '20.hafta',
                                              '21.hafta',
                                              '22.hafta',
                                              '23.hafta',
                                              '24.hafta',
                                              '25.hafta',
                                              '26.hafta',
                                              '27.hafta',
                                              '28.hafta',
                                              '29.hafta',
                                              '30.hafta',
                                              '31.hafta',
                                              '32.hafta',
                                              '33.hafta',
                                              '34.hafta',
                                              '35.hafta',
                                              '36.hafta',
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (week) {
                                              hafta = week!;
                                            },
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: SizedBox(
                                        width: 315,
                                        height: 48,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4F4F4),
                                            border: Border.all(
                                              color: Color(0xFFF4F4F4),
                                              width: 3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) => value !=
                                                        null &&
                                                    value.length < 1
                                                ? 'Bu kısım boş bırakılamaz!'
                                                : null,
                                            controller: _date,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons
                                                    .calendar_today_rounded),
                                                labelText: "Doğum Tarihi"),
                                            onTap: () async {
                                              DateTime? pickeddate =
                                                  await showDatePicker(
                                                context: context,
                                                locale: Locale('tr'),
                                                initialDate: DateTime(
                                                    DateTime.now().year - 18),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2005),
                                              );
                                              if (pickeddate != null) {
                                                setState(() {
                                                  _date.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickeddate);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 315,
                                      height: 70,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 252,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 1
                                                  ? 'Bu kısım boş bırakılamaz!'
                                                  : null,
                                              controller: kiloController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF898182),
                                                  fontSize: 12.0,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.scale,
                                                  size: 15.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Kilonuz",
                                                fillColor: Color(0xFFF4F4F4),
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFFF4F4F4)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.95, 0.0),
                                                end: Alignment(1.0, 0.0),
                                                colors: [
                                                  const Color(0xffC58BF2),
                                                  const Color(0xffEEA4CE),
                                                ],
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'KG',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xffffffff),
                                                  letterSpacing:
                                                      -0.3858822937011719,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 315,
                                      height: 70,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 252,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 1
                                                  ? 'Bu kısım boş bırakılamaz!'
                                                  : null,
                                              controller: boyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF898182),
                                                  fontSize: 12.0,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.height,
                                                  size: 15.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Boyunuz",
                                                fillColor: Color(0xFFF4F4F4),
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFFF4F4F4)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.95, 0.0),
                                                end: Alignment(1.0, 0.0),
                                                colors: [
                                                  const Color(0xffC58BF2),
                                                  const Color(0xffEEA4CE),
                                                ],
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'CM',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xffffffff),
                                                  letterSpacing:
                                                      -0.3858822937011719,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 30,
                                      ),
                                      child: Container(
                                        width: 316,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(99.0),
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
                                          onPressed: () {
                                            nextPage();
                                          },
                                          child: Center(
                                            child: Text(
                                              'İleri',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: const Color(0xffffffff),
                                                letterSpacing:
                                                    -0.3858822937011719,
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
                          ),
                        ],
                      ),
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
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                alignment: Alignment.bottomCenter,
                                image: AssetImage(
                                  "images/more_information.png",
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.55,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 315,
                                      height: 48,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4F4F4),
                                            border: Border.all(
                                              color: Color(0xFFF4F4F4),
                                              width: 3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.people),
                                            ),
                                            hint: Text(
                                              "Gebelik Haftası",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            iconSize: 14,
                                            items: <String>[
                                              '1.hafta',
                                              '2.hafta',
                                              '3.hafta',
                                              '4.hafta',
                                              '5.hafta',
                                              '6.hafta',
                                              '7.hafta',
                                              '8.hafta',
                                              '9.hafta',
                                              '10.hafta',
                                              '11.hafta',
                                              '12.hafta',
                                              '13.hafta',
                                              '14.hafta',
                                              '15.hafta',
                                              '16.hafta',
                                              '17.hafta',
                                              '18.hafta',
                                              '19.hafta',
                                              '20.hafta',
                                              '21.hafta',
                                              '22.hafta',
                                              '23.hafta',
                                              '24.hafta',
                                              '25.hafta',
                                              '26.hafta',
                                              '27.hafta',
                                              '28.hafta',
                                              '29.hafta',
                                              '30.hafta',
                                              '31.hafta',
                                              '32.hafta',
                                              '33.hafta',
                                              '34.hafta',
                                              '35.hafta',
                                              '36.hafta',
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (week) {
                                              hafta = week!;
                                            },
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: SizedBox(
                                        width: 315,
                                        height: 48,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4F4F4),
                                            border: Border.all(
                                              color: Color(0xFFF4F4F4),
                                              width: 3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) => value !=
                                                        null &&
                                                    value.length < 1
                                                ? 'Bu kısım boş bırakılamaz!'
                                                : null,
                                            controller: _date,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons
                                                    .calendar_today_rounded),
                                                labelText: "Doğum Tarihi"),
                                            onTap: () async {
                                              DateTime? pickeddate =
                                                  await showDatePicker(
                                                locale: Locale('tr'),
                                                context: context,
                                                initialDate: DateTime(
                                                    DateTime.now().year - 18),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2005),
                                              );
                                              if (pickeddate != null) {
                                                setState(() {
                                                  _date.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickeddate);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 315,
                                      height: 70,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 252,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 1
                                                  ? 'Bu kısım boş bırakılamaz!'
                                                  : null,
                                              controller: kiloController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF898182),
                                                  fontSize: 12.0,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.scale,
                                                  size: 15.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Kilonuz",
                                                fillColor: Color(0xFFF4F4F4),
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFFF4F4F4)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.95, 0.0),
                                                end: Alignment(1.0, 0.0),
                                                colors: [
                                                  const Color(0xffC58BF2),
                                                  const Color(0xffEEA4CE),
                                                ],
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'KG',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xffffffff),
                                                  letterSpacing:
                                                      -0.3858822937011719,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 315,
                                      height: 70,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 252,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 1
                                                  ? 'Bu kısım boş bırakılamaz!'
                                                  : null,
                                              controller: boyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF898182),
                                                  fontSize: 12.0,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.height,
                                                  size: 15.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Boyunuz",
                                                fillColor: Color(0xFFF4F4F4),
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFFF4F4F4)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.95, 0.0),
                                                end: Alignment(1.0, 0.0),
                                                colors: [
                                                  const Color(0xffC58BF2),
                                                  const Color(0xffEEA4CE),
                                                ],
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'CM',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xffffffff),
                                                  letterSpacing:
                                                      -0.3858822937011719,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 30,
                                      ),
                                      child: Container(
                                        width: 316,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(99.0),
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
                                          onPressed: () {
                                            nextPage();
                                          },
                                          child: Center(
                                            child: Text(
                                              'İleri',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: const Color(0xffffffff),
                                                letterSpacing:
                                                    -0.3858822937011719,
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
