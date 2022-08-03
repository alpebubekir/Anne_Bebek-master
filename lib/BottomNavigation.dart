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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.only(left: 30, right: 30),
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
