import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'TextPage.dart';

class Makaleler extends StatefulWidget {
  const Makaleler({Key? key, required this.makaleList}) : super(key: key);

  final List<Makale> makaleList;

  @override
  State<Makaleler> createState() => _MakalelerState();
}

class _MakalelerState extends State<Makaleler> {
  void goToTextPage(Makale item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (route) => TextPage(
                  item: item,
                  makaleList: widget.makaleList,
                )));
  }

  Widget makaleWidget(Makale item, String asset) {
    return GestureDetector(
      onTap: () => goToTextPage(item),
      child: Container(
        width: double.infinity,
        height: 120,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset(asset),
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
                    "Özge Karakaya Suzan",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    "125.547 görüntü - 1 hafta önce",
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
                      "Makaleler",
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
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.makaleList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 == 0) {
                    return makaleWidget(
                        widget.makaleList[index], "images/makale_image_1.png");
                  } else {
                    return makaleWidget(
                        widget.makaleList[index], "images/makale_image_2.png");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
