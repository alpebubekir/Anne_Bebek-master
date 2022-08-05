import 'package:anne_bebek/UzmanaSor.dart';
import 'package:flutter/material.dart';

class UzmanSec extends StatefulWidget {
  const UzmanSec({Key? key, required this.name, required this.surname})
      : super(key: key);
  final String name, surname;

  @override
  State<UzmanSec> createState() => _UzmanSecState();
}

class _UzmanSecState extends State<UzmanSec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 50,
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Uzmana Sor",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (route) => UzmanaSor(
                            name: widget.name, surname: widget.surname))),
                child: LayoutBuilder(
                  builder: (context, constarints) {
                    if (constarints.maxHeight < 760) {
                      return Container(
                        width: double.infinity,
                        height: 80,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              child:
                                  Image.asset("images/ozge_karakaya_suzan.png"),
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
                                      "Özge Karakaya Suzan",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
                                    border:
                                        Border.all(color: Color(0xffC58BF2)),
                                    borderRadius: BorderRadius.circular(360)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset("images/sor.png"),
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                gradient: LinearGradient(
                                  begin: Alignment(-0.95, 0.0),
                                  end: Alignment(1.0, 0.0),
                                  colors: [
                                    const Color(0xff9DCEFF).withOpacity(0.3),
                                    const Color(0xff92A3FD).withOpacity(0.3),
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                              margin: EdgeInsets.all(20),
                              child:
                                  Image.asset("images/ozge_karakaya_suzan.png"),
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
                                      "Özge Karakaya Suzan",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
                                    border:
                                        Border.all(color: Color(0xffC58BF2)),
                                    borderRadius: BorderRadius.circular(360)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset("images/sor.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
