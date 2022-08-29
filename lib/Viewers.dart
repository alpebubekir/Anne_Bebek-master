import 'package:flutter/material.dart';

class Viewers extends StatefulWidget {
  const Viewers({Key? key, required this.viewerList}) : super(key: key);

  final List<String> viewerList;

  @override
  State<Viewers> createState() => _ViewersState();
}

class _ViewersState extends State<Viewers> {
  Widget item(String name) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60), color: Colors.grey),
      child: Text(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
            itemCount: widget.viewerList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.viewerList[index]),
              );
            }),
      ),
    );
  }
}
