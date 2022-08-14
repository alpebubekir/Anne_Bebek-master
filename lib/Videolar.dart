import 'package:firebase_auth/firebase_auth.dart';
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
    DatabaseReference ref1 = FirebaseDatabase.instance
        .ref("Users/" + FirebaseAuth.instance.currentUser!.uid);
    ref1.child("izlenen").update({item.title: ""});
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videolar");
    //var snapshot = await ref.child(item.id).child("view").get();

    //ref.child(item.id).update({"view": (snapshot.value as int) + 1});

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
                                Icons.arrow_back,
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
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.transparent,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.videoItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return videoItemWidget(widget.videoItemList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
