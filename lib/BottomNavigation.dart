import 'package:anne_bebek/MainPage.dart';
import 'package:anne_bebek/Profile.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTab = 0;
  final List<Widget> widgetList = [MainPage(), Profile()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          gradient: LinearGradient(
            begin: Alignment(-0.95, 0.0),
            end: Alignment(1.0, 0.0),
            colors: [
              const Color(0xff92A3FD),
              const Color(0xff9DCEFF),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          onPressed: () {},
          child: Image.asset(
            "images/search.png",
            fit: BoxFit.contain,
            width: 25,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 0;
                    currentScreen = MainPage();
                  });
                },
                child: Image.asset("images/home.png")),
            Spacer(),
            GestureDetector(
                onTap: () {}, child: Image.asset("images/activity.png")),
            Spacer(),
            Spacer(),
            GestureDetector(
                onTap: () {}, child: Image.asset("images/camera.png")),
            Spacer(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 1;
                    currentScreen = Profile();
                  });
                },
                child: Image.asset("images/profile.png")),
          ],
        ),
      ),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
    );
  }
}
