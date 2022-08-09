import 'package:flutter/material.dart';

class Uzman extends StatefulWidget {
  const Uzman({Key? key}) : super(key: key);

  @override
  State<Uzman> createState() => _UzmanState();
}

class _UzmanState extends State<Uzman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
            ),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffF7F8F8),
                        ),
                        alignment: Alignment.center,
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
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Özge Karakaya Suzan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text("Uzman Hemşire")
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Icon(Icons.favorite_border)),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(300)),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.asset(
                      "images/ozge_karakaya_suzan.png",
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
                "Ben Özge Karakaya Suzan.\n\nÇocuk Sağlığı ve Hastalıkları Hemşireliği alanında doktora eğitimi alan uzman hemşireyim. Balıkesir Üniveristesi Sağlık Bilimleri Fakültesinden 2015 yıllarında mezun oldum, ardindan 2018 yılında aynı alanda yüksek lisans egitimimi tamamladım. Sakarya Üniversitesi Sağlık Bilimleri Enstitüsünde doktora eğitimine devam etmekteyim. 2015-2017 yılları arasında Karabük Medikar Hastanesi  Yenidoğan Yoğun Bakım Ünitesinde Hemşire olarak görev yaptım. 2017 yılından itibaren Sakarya Üniversitesi Sağlık Bilimleri Fakültesinde Araştırma Görevlisi olarak görev yapmaktayım. Uluslararası ve ulusal yayınlar, kitap bölümleri, ödüller ve projelerim bulunmaktadır. Birçok ulusal ve uluslararasi kongrelere ve mesleki eğitimlere katıldım. Evli ve 1 çocuk annesiyim."),
          )
        ],
      ),
    );
  }
}
