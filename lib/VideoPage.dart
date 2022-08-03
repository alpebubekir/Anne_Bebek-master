import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'MainPage.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key? key, required this.item, required this.videoItemList})
      : super(key: key);
  final VideoItem item;
  final List<VideoItem> videoItemList;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  List<VideoItem> videoList = [];

  @override
  void initState() {
    getVideo();
    super.initState();
    _controller = VideoPlayerController.network(widget.item.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.setLooping(true);
  }

  Future<void> getVideo() async {
    int videoLength = widget.videoItemList.length;

    var rng = Random();
    int item1Index = rng.nextInt(videoLength);

    while (item1Index == widget.item.id) {
      item1Index = rng.nextInt(videoLength);
    }
    int item2Index = rng.nextInt(videoLength);
    while (item2Index == item1Index || item2Index == widget.item.id) {
      item2Index = rng.nextInt(videoLength);
    }
    int i = 0;
    for (VideoItem item in widget.videoItemList) {
      if (i == item2Index || i == item1Index) {
        videoList.add(item);
      }
      i++;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
  // TODO: implement widget
  VideoPage get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Image.asset(
                              "images/ozge_karakaya_suzan.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              color: Colors.pinkAccent),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Özge Karakaya Suzan"),
                            Text(
                              "Uzman Hemşire",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Image.asset("images/kalp.png"),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  _controller.value.isInitialized
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : Container(
                          child: CircularProgressIndicator(),
                        ),
                  Container(
                    color: Color(0xff92a3fd),
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, top: 30),
              child: Text(
                widget.item.title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 30),
              child: Row(
                children: [
                  Image.asset("images/goz.png"),
                  Text(
                    "  " + widget.item.view.toString() + " görüntülenme",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                "Benzer İçerikler",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return videoItemWidget(videoList[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*_controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      child: CircularProgressIndicator(),
                    ),
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow))
                  ],
                ),
              )*/

/*Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.black,
                child: Column(
                  children: [
                    _controller.value.isInitialized
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        : Container(
                            child: CircularProgressIndicator(),
                          ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )*/
