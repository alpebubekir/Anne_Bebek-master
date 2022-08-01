import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'MainPage.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key? key, required this.item}) : super(key: key);
  VideoItem item;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/anne-bebek.appspot.com/o/anne_cocuk_baglanmas%C4%B1.mp4?alt=media&token=0bd55016-5262-4b74-918b-fb0ca7942dab')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  // TODO: implement widget
  VideoPage get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment(-0.95, 0.0),
              end: Alignment(1.0, 0.0),
              colors: [
                const Color(0xff92A3FD),
                const Color(0xff9DCEFF),
              ],
              stops: [0.0, 1.0],
            )),
            margin: EdgeInsets.all(10),
            child: Column(children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 33,
                      height: 33,
                      margin: EdgeInsets.only(top: 30, left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF7F8F8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    widget.item.writer,
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 33,
                      height: 33,
                      margin: EdgeInsets.only(top: 30, left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF7F8F8).withOpacity(0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _controller.value.isInitialized
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
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
