import 'package:anne_bebek/Uzman.dart';
import 'package:flutter/material.dart';

class Uzmanlar extends StatefulWidget {
  const Uzmanlar({Key? key}) : super(key: key);

  @override
  State<Uzmanlar> createState() => _UzmanlarState();
}

class _UzmanlarState extends State<Uzmanlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
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
                    Spacer(),
                    Text(
                      "Uzmanlarımız",
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (route) => Uzman()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEBEFF8)),
                padding: EdgeInsets.all(10),
                height: 250,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Color(0xffEBEFF8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Özge Karakaya Suzan",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Uzman Hemşire",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Icon(Icons.favorite_border)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Colors.white),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: Text(
                                "Ben Özge Karakaya Suzan. Çocuk Sağlığı ve Hastalıkları Hemşireliği alanında doktora eğitimi alan uzman hemşireyim. Balıkesir Üniveristesi Sağlık Bilimleri Fakültesinden 2015 yıllarında mezun oldum, ardindan 2018 yılında aynı alanda yüksek lisans egitimimi tamamladım. Sakarya Üniversitesi Sağlık Bilimleri Enstitüsünde doktora eğitimine devam etmekteyim. 2015-2017 yılları arasında Karabük Medikar Hastanesi  Yenidoğan Yoğun Bakım Ünitesinde Hemşire olarak görev yaptım. 2017 yılından itibaren Sakarya Üniversitesi Sağlık Bilimleri Fakültesinde Araştırma Görevlisi olarak görev yapmaktayım. Uluslararası ve ulusal yayınlar, kitap bölümleri, ödüller ve projelerim bulunmaktadır. Birçok ulusal ve uluslararasi kongrelere ve mesleki eğitimlere katıldım. Evli ve 1 çocuk annesiyim.",
                                maxLines: 8,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(bottom: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(300),
                                  child: Image.asset(
                                    "images/ozge_karakaya_suzan.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
