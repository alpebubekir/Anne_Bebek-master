import 'package:anne_bebek/Web.dart';
import 'package:flutter/material.dart';

class Etkinlikler extends StatefulWidget {
  const Etkinlikler({Key? key, required this.shouldShow}) : super(key: key);

  final bool shouldShow;

  @override
  State<Etkinlikler> createState() => _EtkinliklerState();
}

class _EtkinliklerState extends State<Etkinlikler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shouldShow
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          "Etkinlikler",
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListTile(
                    title: Text("Ankete git"),
                    leading: Icon(Icons.book),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (route) => Web(
                                url:
                                    "https://docs.google.com/forms/d/e/1FAIpQLSdaXmfzW7G3RTrzBM7yHTTdpa0GNKZEb0kqXsCcGO7iEjfgIA/viewform"))),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          "Etkinlikler",
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
                          style:
                              TextStyle(color: Color(0xff7B6F72), fontSize: 16),
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
