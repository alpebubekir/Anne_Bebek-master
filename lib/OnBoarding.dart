import 'package:anne_bebek/main.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: Container(
        color: Colors.white,
        width: double.infinity,
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < 760) {
                return Container(
                  color: Colors.white,
                  child: Scaffold(
                    body: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 196,
                              child: Image.asset("images/mom_firs.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 59,
                              ),
                              child: SizedBox(
                                width: 257,
                                height: 36,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Anne & Bebek",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: SizedBox(
                                width: 117,
                                height: 21,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Bağlanması",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 134,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 242,
                                height: 238,
                                child: Image.asset("images/mom_firs.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 59,
                                ),
                                child: SizedBox(
                                  width: 257,
                                  height: 36,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Anne & Bebek",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: SizedBox(
                                  width: 117,
                                  height: 21,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Bağlanması",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Container(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < 760) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        "images/onboarding_second.png",
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFBFBFBF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                            "images/onboarding_second.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBFBFBF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < 760) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        "images/onboarding_third.png",
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFBFBFBF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                            "images/onboarding_third.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBFBFBF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Container(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < 760) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        "images/onboarding_second.png",
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFBFBFBF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                            "images/onboarding_second.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBFBFBF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < 760) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(
                        "images/onboarding_third.png",
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFBFBFBF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage(
                            "images/onboarding_third.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anne & Bebek Bağlanması",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "Bu alan bilgi ekleme alanı olarak kullanılacaktır.",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFBFBFBF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  Future<void> goToMain() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove("isFirstLook");
    prefs.setBool("isFirstLook", false);

    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  Widget widget1(void Function(int index) setIndex) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
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
            onPressed: () => setIndex(++index),
            child: Center(
              child: Text(
                'Hadi Başlayalım!',
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
    );
  }

  Widget widget2(void Function(int index) setIndex) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 20),
          child: Container(
            width: 50,
            height: 50,
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
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.only(bottom: 2, left: 5)),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 30,
              ),
              onPressed: () => {
                if (index != onboardingPagesList.length - 1)
                  {setIndex(++index)}
                else
                  {goToMain()}
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return index == 0 ? widget1(setIndex) : widget2(setIndex);

          /*DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(
                width: 0.0,
                color: background,
              ),
            ),
            child: ColoredBox(
              color: background,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.line(
                          lineDesign: LineDesign(
                            lineType: DesignType.line_uniform,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              if (index != pagesLength - 1)
                                {setIndex(++index)}
                              else
                                {goToMain()}
                            },
                        child: Text("Next"))
                  ],
                ),
              ),
            ),
          );*/
        },
      ),
    );
  }
}
