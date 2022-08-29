import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Widget item(String title, String value, Function fun) {
    return Column(
      children: [
        Text(title),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.orange),
          child: Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    fun(title, value);
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
        ),
      ],
    );
  }

  Future<void> changeText(String title, String value) async {
    var controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Text(title),
          TextField(
            controller: controller,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Düzenle",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              item("İsim", "Fureb", changeText),
              /*item("Soyisim", "Development"),
              item("Doğum Tarihi", "2004-01-01"),
              item("Boy", "155"),
              item("Kilo", "66"),
              item("gebelik haftası", "6. Hafta")*/
            ],
          ),
        ),
      ),
    );
  }
}
