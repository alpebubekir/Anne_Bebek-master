import 'package:anne_bebek/Makaleler.dart';
import 'package:anne_bebek/UzmanSec.dart';
import 'package:anne_bebek/Videolar.dart';
import 'package:anne_bebek/service/locale_push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'TextPage.dart';
import 'Uzman.dart';
import 'VideoPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.videoItemList}) : super(key: key);

  final List<VideoItem> videoItemList;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String name = "", surname = "";

  var textController = TextEditingController();

  //List<Item> itemList = [];
  List<Item> newsList = [];
  List<Person> personList = [];

  List<Makale> makaleFilterList = [];
  List<VideoItem> videoFilterList = [];

  bool isFilter = false;
  bool keybordOpen = false;

  List<Makale> makaleList = [];

  Future<void> getName() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    var snapshot1 = await ref.child("isim").get();
    var snapshot2 = await ref.child("soyisim").get();

    name = snapshot1.value.toString();
    surname = snapshot2.value.toString();
    setState(() {});
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    getName();
    getItems();
    getMakale();
    //getVideo();
    getToken();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    super.initState();
  }

  getToken() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
    String? token = await FirebaseMessaging.instance.getToken();
    var snapshot = await ref.child("token").get();

    if (!snapshot.exists ||
        (snapshot.exists && token != snapshot.value.toString())) {
      ref.update({"token": token});
    }

    tz.initializeTimeZones();

    var snapshotgebelik = await ref.child("gebelik haftasi").get();

    DateTime creation =
        FirebaseAuth.instance.currentUser!.metadata.creationTime!;

    String gebelik = snapshotgebelik.value.toString();
    int initial = int.parse(gebelik.substring(0, gebelik.indexOf(".")));

    var fark = DateTime.now().difference(creation);

    int haftaFark = (fark.inDays / 7).toInt();

    int guncel = initial + haftaFark > 36 ? 36 : initial + haftaFark;

    DateTime date =
        DateTime.now().add(Duration(days: (36 - guncel) * 7, minutes: 15));

    FlutterLocalNotificationsPlugin fl = FlutterLocalNotificationsPlugin();
    var android = AndroidNotificationDetails("mychannel", "mychannel",
        importance: Importance.high, priority: Priority.max, playSound: true);
    var ios = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(android: android, iOS: ios);

    fl.zonedSchedule(
        25,
        "Anne Bebek Bağlanması",
        "Sizin için bir anket var",
        tz.TZDateTime.from(date, tz.getLocation("Europe/Istanbul")),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void getItems() {
    newsList.add(Item("Anne Çocuk Bağlanması", 'images/makale_first.png', 50000,
        "Özge Karakaya Suzan", "1 hafta önce", "Text"));

    newsList.add(Item("Bebeği Nasıl Bekleyelim?", 'images/makale.second.png',
        50000, "Özge Karakaya Suzan", "1 hafta önce", "Text"));

    personList.add(Person("images/ozge_karakaya_suzan.png",
        "Özge Karakaya Suzan", "Arş.Görevlisi", "Uzman Hemşire", 4.5));
    personList.add(Person("images/ozge_karakaya_suzan.png",
        "Özge Karakaya Suzan", "Arş.Görevlisi", "Uzman Hemşire", 4.6));
  }

  void getMakale() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Makaleler");

    ref.onValue.listen((event) {
      for (DataSnapshot snapshot in event.snapshot.children) {
        makaleList.add(Makale(
            snapshot.key.toString(),
            snapshot.child("title").value.toString(),
            snapshot.child("text").value.toString(),
            snapshot.child("view").value as int));
      }
    });
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

  Future<void> goToTextPage(Makale item) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);

    ref.child("okunan").update({item.title: ""});

    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref("Makaleler/" + item.id);
    var snapshot = await ref1.child("view").get();

    ref1.update({"view": (snapshot.value as int) + 1});

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => TextPage(
                  item: item,
                  makaleList: makaleList,
                )));
  }

  Future<void> goToVideoPage(VideoItem item) async {
    DatabaseReference ref1 = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
    ref1.child("izlenen").update({item.title: ""});
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");
    var snapshot = await ref.child(item.id).child("view").get();
    try {
      ref
          .child(item.id)
          .update({"view": int.parse(snapshot.value.toString()) + 1});
    } catch (e) {
      print(e);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => VideoPage(
                  item: item,
                  videoItemList: widget.videoItemList,
                )));
  }

  Widget itemWidget(Makale item, LinearGradient gradient) {
    return GestureDetector(
      onTap: () => goToTextPage(item),
      child: Container(
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
              width: 90,
              height: 90,
              margin: EdgeInsets.all(5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Image.asset(
                    'images/' + item.id + '.jpg',
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                item.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              "Özge Karakaya Suzan",
              style: TextStyle(fontSize: 11),
            ),
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
                  onPressed: () => goToTextPage(item),
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
      ),
    );
  }

  void filter(String text) {
    videoFilterList = [];
    makaleFilterList = [];

    if (text != null && text != "") {
      isFilter = true;
      keybordOpen = true;

      for (Makale m in makaleList) {
        print(m.title + " " + text);
        if ((m.title.toUpperCase().contains(text.toUpperCase()) ||
            m.title.toLowerCase().contains(text.toLowerCase()) &&
                !makaleFilterList.contains(m))) {
          makaleFilterList.add(m);
        }
      }

      for (VideoItem v in widget.videoItemList) {
        if ((v.title.toUpperCase().contains(text.toUpperCase()) ||
                v.title.toLowerCase().contains(text.toLowerCase())) &&
            !videoFilterList.contains(v)) {
          videoFilterList.add(v);
        }
      }
    } else {
      keybordOpen = false;
      isFilter = false;
      textController.text = "";
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      keybordOpen = false;
      videoFilterList = [];
      makaleFilterList = [];
    }
    setState(() {});
  }

  Widget videoItemWidget(VideoItem item) {
    return GestureDetector(
      onTap: () => goToVideoPage(item),
      child: Container(
        width: 300,
        height: 180,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
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
              ),
              child: Image.asset(
                'images/video_banner.png',
              ),
            ),
            Container(
              width: 300,
              height: 80,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.title,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.writer.length > 16
                                ? item.writer.substring(0, 15) + "..."
                                : item.writer,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff1A1A1A)),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item1Widget(Makale item) {
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
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: Image.asset(
                          "images/" + item.id + ".jpg",
                          fit: BoxFit.cover,
                        )),
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
                        /*Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff7B6F72)),
                          ),
                        ),*/
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
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: Image.asset(
                          "images/" + item.id + ".jpg",
                          fit: BoxFit.cover,
                        )),
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
                        /*Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.writer,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff7B6F72)),
                          ),
                        ),*/
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

  Widget withFilter() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 43, left: 20),
          child: Row(
            children: [
              Text(
                "Makaleler",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
        makaleFilterList.length == 0
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text("Aramanızla eşleşen bir makale bulunamadı."),
                ),
              )
            : Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: makaleFilterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return item1Widget(makaleList[index]);
                  },
                ),
              ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 43, left: 20),
          child: Row(
            children: [
              Text(
                "Videolar",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        videoFilterList.length == 0
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text("Aramanızla eşleşen bir video bulunamadı."),
                ),
              )
            : Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: videoFilterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return videoItemWidget2(videoFilterList[index]);
                  },
                ),
              )
      ],
    );
  }

  Widget videoItemWidget2(VideoItem item) {
    return GestureDetector(
      onTap: () => goToVideoPage(item),
      child: Container(
        width: double.infinity,
        height: 120,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset("images/square_banner_video.png"),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    item.writer,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    item.view.toString() + " görüntü - 1 hafta önce",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noFilter() {
    return Column(children: [
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
      Container(
        width: double.infinity,
        height: 300,
        child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: makaleList.isEmpty ? 0 : 3,
          itemBuilder: (BuildContext context, int index) {
            if (index % 2 == 0) {
              return itemWidget(
                  makaleList[index],
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
                  makaleList[index],
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
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 43, left: 20, right: 10),
        child: Row(
          children: [
            Text(
              "Yeni eklenen yazılar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (route) => Makaleler(makaleList: makaleList))),
              child: Text(
                "hepsi",
                style: TextStyle(color: Color(0xffF2994A)),
              ),
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
        alignment: Alignment.topCenter,
        width: double.infinity,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: makaleList.isEmpty ? 0 : 2,
          itemBuilder: (BuildContext context, int index) {
            return item1Widget(makaleList[makaleList.length - 1 - index]);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.25,
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
                width: MediaQuery.of(context).size.width * 0.5,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Uzmanlarımız",
                          style: TextStyle(
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Sohbet İçin Hazır!",
                            style: TextStyle(
                              fontSize: 18, color: Color(0xff92A3FD),
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (route) => UzmanSec(
                                            name: name, surname: surname)));
                              },
                              child: Center(
                                child: Text(
                                  'Simdi Sor',
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
                width: MediaQuery.of(context).size.width * 0.4,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset('images/girl_banner.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      //Buradan
      Container(
        width: double.infinity,
        height: 250,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Color(0xffCCAFFF).withOpacity(0.15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "images/ozge_karakaya_suzan.png",
                  width: 100,
                  height: 100,
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
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text("4.5"),
                      )
                    ],
                  ),
                )
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Özge Karakaya Suzan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Spacer(),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Arş.Görevlisi",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Uzman Hemşire",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Spacer(),
            Spacer(),
            Container(
              height: 60,
              child: Align(
                  child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Container(
                    width: 200,
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
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (route) => Uzman()));
                      },
                      child: Center(
                        child: Text(
                          'Araştırmacı hakkında',
                          style: TextStyle(
                            fontSize: 15,
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
      ),
      //Buraya
      /*Container(
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
              ),*/
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
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (route) => Videolar(
                            videoItemList: widget.videoItemList,
                          ))),
              child: Text(
                "hepsi",
                style: TextStyle(color: Color(0xffF2994A)),
              ),
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
        height: 230,
        child: widget.videoItemList.length == 0
            ? Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.videoItemList.length == 0 ? 0 : 3,
                itemBuilder: (BuildContext context, int index) {
                  return videoItemWidget(widget.videoItemList[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
              ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Spacer(),
                      Text(
                        "Ana Sayfa",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 34, left: 20, right: 20),
                child: TextField(
                  controller: textController,
                  onChanged: (text) {
                    filter(text);
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Color(0xFF898182),
                      fontSize: 12.0,
                    ),
                    prefixIcon: Image.asset("images/search_bar.png"),
                    suffixIcon: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          keybordOpen
                              ? GestureDetector(
                                  onTap: () {
                                    textController.text = "";
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    filter("");
                                    keybordOpen = false;
                                  },
                                  child: Icon(
                                    Icons.close,
                                  ),
                                )
                              : Container(),
                          Image.asset("images/filter.png"),
                        ],
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "Arama yap",
                    hintStyle: TextStyle(color: Color(0xffDDDADA)),
                    fillColor: Color(0xFFFFFFFF),
                    filled: true,
                  ),
                ),
              ),
              isFilter ? withFilter() : noFilter()
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
  final String title, videoUrl, photoUrl, writer, unvan, id;
  final int view;
  final List<Viewer> viewerList;

  VideoItem(this.id, this.title, this.videoUrl, this.photoUrl, this.view,
      this.writer, this.unvan, this.viewerList);
}

class Viewer {
  final String hafta, name;

  Viewer(this.hafta, this.name);
}

class Makale {
  final String title, text, id;
  final int view;

  Makale(this.id, this.title, this.text, this.view);
}
