import 'package:anne_bebek/main.dart';
import 'package:flutter/material.dart';

class GoToMain extends StatefulWidget {
  const GoToMain({Key? key, required this.name}) : super(key: key);

  final String name;
  @override
  State<GoToMain> createState() => _GoToMainState();
}

class _GoToMainState extends State<GoToMain> {
  @override
  // TODO: implement widget
  GoToMain get widget => super.widget;

  void goToMain() {
    Navigator.push(context, MaterialPageRoute(builder: (route) => MyApp()));
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
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: SizedBox(
                              width: 180,
                              height: 186,
                              child: Image.asset('images/group.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 56),
                            child: SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Hoş Geldin ${widget.name}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: SizedBox(
                              width: 214,
                              height: 54,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Aramıza katıldığınız için çok heyecanlıyız. Hamilelik süreci boyunca birlikteyiz!",
                                style: TextStyle(
                                  color: Color(0xFFBFBFBF),
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50,
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
                                onPressed: () {
                                  goToMain();
                                },
                                child: Center(
                                  child: Text(
                                    'Ana Sayafaya Git',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 102),
                            child: SizedBox(
                              width: 278,
                              height: 292,
                              child: Image.asset('images/group.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 56),
                            child: SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Hoş Geldin ${widget.name}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: SizedBox(
                              width: 214,
                              height: 54,
                              child: Text(
                                textAlign: TextAlign.center,
                                "Aramıza katıldığınız için çok heyecanlıyız. Hamilelik süreci boyunca birlikteyiz!",
                                style: TextStyle(
                                  color: Color(0xFFBFBFBF),
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 173,
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
                                onPressed: () {
                                  goToMain();
                                },
                                child: Center(
                                  child: Text(
                                    'Ana Sayafaya Git',
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
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
