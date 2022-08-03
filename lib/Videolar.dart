import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'VideoPage.dart';

class Videolar extends StatefulWidget {
  const Videolar({Key? key, required this.videoItemList}) : super(key: key);

  final List<VideoItem> videoItemList;

  @override
  State<Videolar> createState() => _VideolarState();
}

class _VideolarState extends State<Videolar> {
  Future<void> goToVideoPage(VideoItem item) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");
    var snapshot = await ref.child(item.id).child("view").get();

    ref.child(item.id).update({"view": (snapshot.value as int) + 1});

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => VideoPage(
                  item: item,
                  videoItemList: widget.videoItemList,
                )));
  }

  Widget videoItemWidget(VideoItem item) {
    return GestureDetector(
      onTap: () => goToVideoPage(item),
      child: Container(
        width: 150,
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
              height: 80,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Container(
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Videolar",
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
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.videoItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return videoItemWidget(widget.videoItemList[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
