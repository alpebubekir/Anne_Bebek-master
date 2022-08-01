import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'TextPage.dart';
import 'VideoPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String name = "", surname;
  List<Item> itemList = [];
  List<VideoItem> videoItemList = [];
  List<Item> newsList = [];
  List<Person> personList = [];

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    getName();
    getItems();

    super.initState();
  }

  void getItems() {
    itemList.add(Item(
        "Anne Çocuk Bağı",
        "https://i.picsum.photos/id/225/200/200.jpg?hmac=52EiCj00RHCtvmOTzd1OIWV0prXw1EISWtV8iI65NL4",
        50000,
        "Özge Karakaya Suzan",
        "1 hafta önce",
        "Text"));
    itemList.add(Item(
        "Anne Çocuk Bağı",
        "https://i.picsum.photos/id/192/200/200.jpg?hmac=ADFozPC7IeAOBiVxD2ZbHYkpCVEa8Xj_tZE_Dm7yFuo",
        656226,
        "Özge Karakaya Suzan",
        "1 hafta önce",
        "Text"));
    itemList.add(Item(
        "Anne Çocuk Bağı",
        "https://i.picsum.photos/id/225/200/200.jpg?hmac=52EiCj00RHCtvmOTzd1OIWV0prXw1EISWtV8iI65NL4",
        50000,
        "Özge Karakaya Suzan",
        "1 hafta önce",
        "Text"));

    newsList.add(Item("Anne Çocuk Bağlanması", 'images/makale_first.png', 50000,
        "Özge Karakaya Suzan", "1 hafta önce", "Text"));

    newsList.add(Item("Bebeği Nasıl Bekleyelim?", 'images/makale.second.png',
        50000, "Özge Karakaya Suzan", "1 hafta önce", "Text"));

    videoItemList.add(VideoItem(
        "Güvenli Bağlanma",
        "https://www.youtube.com/watch?v=oHg5SJYRHA0",
        "https://i.picsum.photos/id/192/200/200.jpg?hmac=ADFozPC7IeAOBiVxD2ZbHYkpCVEa8Xj_tZE_Dm7yFuo",
        50,
        "Özge Suzan",
        "Araştırmacı"));

    personList.add(Person("images/girl_banner_second.png",
        "Özge Karakaya Suzan", "Arş.Görevlisi", "Uzman Hemşire", 4.5));
    personList.add(Person("images/girl_banner_second.png",
        "Özge Karakaya Suzan", "Prof.Dr.", "Hemşire", 4.6));
  }

  Widget personWidget(Person person, Color color, bool x) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: color,
          border: x ? Border.all(color: Color(0xffD9D9D9)) : null),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                person.url,
                width: 60,
                height: 60,
              ),
              Spacer(),
              Container(
                alignment: Alignment.topRight,
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xffF8D048),
                    ),
                    Text(person.puan.toString())
                  ],
                ),
              )
            ],
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              person.isim,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Spacer(),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(person.unvan),
          ),
          Spacer(),
          Row(
            children: [
              Icon(
                Icons.hourglass_full,
                size: 13,
              ),
              Text(person.meslek)
            ],
          ),
          Spacer(),
          Spacer(),
          Container(
            width: 200,
            height: 50,
            child: Align(
                child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Container(
                  width: 100,
                  height: 34,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99.0),
                      color: Color(0xffCCAFFF)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        'Şimdi Sor',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xffffffff),
                          letterSpacing: -0.3858822937011719,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset("images/vector.png"),
                ),
              ),
            ])),
          ),
        ],
      ),
    );
  }

  Future<void> getName() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot1 = await ref.child("isim").get();
    var snapshot2 = await ref.child("soyisim").get();

    name = snapshot1.value.toString();
    surname = snapshot2.value.toString();
    setState(() {});
  }

  void goToTextPage(Item item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (route) => TextPage(item: item)));
  }

  void goToVideoPage(VideoItem item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (route) => VideoPage(item: item)));
  }

  Widget itemWidget(Item item, LinearGradient gradient) {
    return Container(
      width: 200,
      height: 239,
      margin: EdgeInsets.only(
        top: 40,
        left: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), gradient: gradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: Image.asset('images/card_first.png'),
          ),
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(item.writer),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Container(
              width: 110,
              height: 38,
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
                onPressed: () {},
                child: Center(
                  child: Text(
                    'Görüntüle',
                    style: TextStyle(
                      fontSize: 12,
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
    );
  }

  Widget videoItemWidget(VideoItem item) {
    return Container(
      width: 300,
      height: 180,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                color: Color(0xff92A3FD)),
            child: Image.asset(
              'images/video_banner.png',
            ),
          ),
          Container(
            width: 300,
            height: 65,
            padding: EdgeInsets.only(left: 15, right: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          item.writer,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff1A1A1A)),
                        ),
                        Text(
                          item.unvan,
                          style: TextStyle(
                              color: Color(0xff1A1A1A).withOpacity(0.4)),
                        ),
                      ],
                    ),
                    Spacer(),
                    Image.asset("images/youtube_logo.png")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget item1Widget(Item item) {
    return GestureDetector(
      onTap: () => goToTextPage(item),
      child: LayoutBuilder(
        builder: (context, constarints) {
          if (constarints.maxHeight < 760) {
            return Container(
              width: double.infinity,
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(item.url),
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
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff7B6F72)),
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
                          border: Border.all(color: Color(0xffC58BF2)),
                          borderRadius: BorderRadius.circular(360)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xffC58BF2),
                          size: 30,
                        ),
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(item.url),
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
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff7B6F72)),
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
                          border: Border.all(color: Color(0xffC58BF2)),
                          borderRadius: BorderRadius.circular(360)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xffC58BF2),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {}, child: Image.asset("images/home.png")),
              Spacer(),
              GestureDetector(
                  onTap: () {}, child: Image.asset("images/activity.png")),
              Spacer(),
              Spacer(),
              GestureDetector(
                  onTap: () {}, child: Image.asset("images/camera.png")),
              Spacer(),
              GestureDetector(
                  onTap: () {}, child: Image.asset("images/profile.png")),
            ],
          ),
        ),
      ),*/

      /*BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("images/home.png"), label: ""),
          BottomNavigationBarItem(
              icon: Image.asset("images/activity.png"), label: ""),
          BottomNavigationBarItem(
              icon: Image.asset("images/camera.png"), label: ""),
          BottomNavigationBarItem(
              icon: Image.asset("images/profile.png"), label: ""),
        ],
      ),*/

      /*Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {}, child: Image.asset("images/home.png")),
            Spacer(),
            GestureDetector(
                onTap: () {}, child: Image.asset("images/activity.png")),
            Spacer(),
            Spacer(),
            GestureDetector(
                onTap: () {}, child: Image.asset("images/camera.png")),
            Spacer(),
            GestureDetector(
                onTap: () {}, child: Image.asset("images/profile.png")),
          ],
        ),
      ),*/
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                ),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF7F8F8),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Ana Sayfa",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 34, left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Color(0xFF898182),
                      fontSize: 12.0,
                    ),
                    prefixIcon: Image.asset("images/search_bar.png"),
                    suffixIcon: Image.asset("images/filter.png"),
                    border: InputBorder.none,
                    hintText: "Arama yap",
                    hintStyle: TextStyle(color: Color(0xffDDDADA)),
                    fillColor: Color(0xFFFFFFFF),
                    filled: true,
                  ),
                ),
              ),
              //searchbar
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: 43,
                  left: 20,
                ),
                child: Text(
                  "En Çok Görüntülenen İçerikler",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              //TEXT
              Container(
                width: double.infinity,
                height: 250,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index % 2 == 0) {
                      return itemWidget(
                          itemList[index],
                          LinearGradient(
                            begin: Alignment(-0.95, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              const Color(0xff92A3FD).withOpacity(0.2),
                              const Color(0xff9DCEFF).withOpacity(0.2),
                            ],
                            stops: [0.0, 1.0],
                          ));
                    } else {
                      return itemWidget(
                          itemList[index],
                          LinearGradient(
                            begin: Alignment(-0.95, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              const Color(0xffC58BF2).withOpacity(0.2),
                              const Color(0xffEEA4CE).withOpacity(0.2),
                            ],
                            stops: [0.0, 1.0],
                          ));
                    }
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 43, left: 20),
                child: Text(
                  "Yeni eklenen yazılar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return item1Widget(newsList[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.95, 0.0),
                      end: Alignment(1.0, 0.0),
                      colors: [
                        const Color(0xff9DCEFF).withOpacity(0.2),
                        const Color(0xff92A3FD).withOpacity(0.2),
                      ],
                      stops: [0.0, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 23.0),
                                  child: Text(
                                    "Uzmanlarımız",
                                    style: TextStyle(
                                      fontSize: 20,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Sohbet İçin Hazır!",
                                    style: TextStyle(
                                      fontSize: 20, color: Color(0xff92A3FD),
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: Container(
                                    width: 95,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(99.0),
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
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.transparent,
                                        onSurface: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () {},
                                      child: Center(
                                        child: Text(
                                          'Daha fazla',
                                          style: TextStyle(
                                            fontSize: 12,
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
                      Spacer(),
                      Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset('images/girl_banner.png'),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 230,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: personList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index % 2 == 0) {
                      return personWidget(personList[index],
                          Color(0xffCCAFFF).withOpacity(0.15), false);
                    } else {
                      return personWidget(
                          personList[index], Color(0xffFFFFFF), true);
                    }
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Videolar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "hepsi",
                      style: TextStyle(color: Color(0xffF2994A)),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Color(0xffF2994A),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: videoItemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return videoItemWidget(videoItemList[index]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Person {
  final String url, isim, unvan, meslek;
  final double puan;

  Person(this.url, this.isim, this.unvan, this.meslek, this.puan);
}

class Item {
  final String title, url, writer, date, text;
  final int view;

  Item(this.title, this.url, this.view, this.writer, this.date, this.text);
}

class VideoItem {
  final String title, videoUrl, photoUrl, writer, unvan;
  final int view;

  VideoItem(this.title, this.videoUrl, this.photoUrl, this.view, this.writer,
      this.unvan);
}
