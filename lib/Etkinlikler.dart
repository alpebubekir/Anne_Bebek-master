import 'package:flutter/material.dart';

class Etkinlikler extends StatefulWidget {
  const Etkinlikler({Key? key}) : super(key: key);

  @override
  State<Etkinlikler> createState() => _EtkinliklerState();
}

class _EtkinliklerState extends State<Etkinlikler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 50,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Etkinlikler",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            width: 200,
            child: Column(
              children: [
                Image.asset("images/zil.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Gösterilecek bildiriminiz bulunmamaktadır.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(color: Color(0xff7B6F72), fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}