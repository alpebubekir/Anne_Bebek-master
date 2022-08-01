import 'package:flutter/material.dart';

import 'MainPage.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  List<Item> newsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsList.add(Item("Anne Duyarlılığı", 'images/benzer_icerik_1.png', 50000,
        "Özge Karakaya Suzan", "1 hafta önce", "Text"));

    newsList.add(Item("Güvenli Bağlanma", 'images/benzer_icerik_2.png', 50000,
        "Nursan Çınar", "1 hafta önce", "Text"));
  }

  Widget item1Widget(Item item) {
    return Container(
      width: double.infinity,
      height: 100,
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
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Image.asset(item.url),
          ),
          Spacer(),
          Container(
            height: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    item.writer,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            height: double.infinity,
            width: 70,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.chevron_right,
                color: Color(0xffC58BF2),
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement widget
  TextPage get widget => super.widget;

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
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
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
                      Container(
                        width: 300,
                        height: 200,
                        child: Image.asset("images/text_page_picture.png"),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(
                            children: const [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Anne Çocuk Bağlanması Nedir?",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      text: "by ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Özge Karakaya Suzan",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF92A3FD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Etiketler",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Anne",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Bağlanma",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.95, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    colors: [
                                      const Color(0xff92A3FD).withOpacity(0.30),
                                      const Color(0xff9DCEFF).withOpacity(0.30),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                              child: Text(
                                "Bebek",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Açıklama",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40, right: 30),
                        child: Text(
                          "Annelik nedir? Anne olunur mu? Yoksa içgüdüsel midir? Bütün kadınlarda annelik söz konusu mudur? Kadın olmak eşittir annelik midir? Gibi pek çok soruya anneliğe adaptasyondan bahsederek açıklık getirmeye çalışacağım.\nAnne olma süreci kadının hayat döngüsünde en önemli gelişimsel geçişlerden birisidir. Bu süreç, aileye yeni bir üyenin katılması ile çoğu zaman mutluluk verici bir olay olmaktadır. Her kadının anneliğe geçiş deneyimi eşsizdir. Bu eşsiz deneyim anneye, bebeğe ve çevreye ait değişkenlerden etkilenebilmektedir. Annenin doğum süreci, bebeğin sağlığı ve sosyal destek varlığı bu değişkenlere örnek olarak verilebilir. Bebeğin doğumu ile aile yaşantısında büyük değişiklikler meydana gelmekte ve çiftlerin her biri yeni roller edinmektedirler.  Anne her çocukla birlikte yeni bir annelik kimliği geliştirmek zorundadır. Anneliğe adaptasyonun sağlanması için bazı evrelerden geçilmesi gerekmektedir.\n⦁	İlk olarak annelik rolünün başarabilmesi için gebeliği kabul etmesi ve gebeliğin yaşam stiline entegre edilmesi gereklidir. Öncelikle anne adayının gebeliği kabul edip etmediği, herhangi bir ön yargısının olup olmadığının konuşulması gerekmektedir. Daha sonrasında annelik rolünü ait tanımlamalar yapabilmesi ve karnındaki bebeği ile ilişki kurabilmesi sağlanmalıdır. Ayrıca bebek doğmadan önce eş ve çevre ilişkilerinin yeniden düzenlenmesi, sosyal destek kaynaklarının belirlenmesi, doğum için gerekli hazırlıkların yapılması da önemlidir gerekmektedir.\n\n⦁	İkinci evre, annenin çocuğunu dünyaya getirmesi ile başlar. Bu aşamada annenin bebeğinin bakımını yapabilmesi önem taşır. Anne bebeğinin bakımını yaparken hemşiresi tarafından kendisine öğretilen bakım becerilerini tamamen aynı şekilde yapmaya çalışır. Anne, tamamen rol modellerini taklit eder. Bu evrede anne bebeğinin bakımını yapabildikçe mutluluk ve memnuniyet sağlayarak annelik rol yeteneği kazanımını ilerletmeye başlar.\n\n⦁	Üçüncü evre, Anne, bebeğine bakım verirken bu evrede artık kendi annelik ve bakım stillerini oluşturmaya ve kendi tercihlerini yansıtmaya başlamıştır. Bu safhada kadın nasıl bir anne olacağını da belirlemeye çalışır. Annelik deneyimi kazandıkça bebeğin bakımında daha esnek davranmaya ve daha ince ayrıntıları fark etmeye başlar. Bu aşamayı sağlıklı bir şekilde geçirdiğinin önemli göstergelerinden biri annelik rollerini yerine getirirken aynı zamanda eş olma gibi diğer rollerini de sağlıklı bir şekilde yerine getirmesi ve rol çatışması yaşamamasıdır.\n\n⦁	Dördüncü evre, önceki safhaları sağlıklı şekilde yerine getirip bu aşamaya ulaşan anne, artık anne olmanın keyfini çıkarır. Önceki safhalarda bebek bakımını öğrenmiş, kendi stillerini geliştirmiş, rol çatışması sorununu halletmiş, esnek tutum davranışları geliştirmiş, bebeği ile zevkli zamanlar geliştirmeye başlamış ve anneliğe tamamen uyum sağlamıştır. Bebeğin aileye katılması ile bozulan uyum tekrardan bu evrede sağlanmıştır. Bu evre kısaca annenin rolü kazanmasında ustalaştığı ve kendine güven kazandığı aşama olarak açıklanabilir.\nBabanın önemi annelik rolüne uyum sağlamada oldukça önemlidir. Babanın desteği, başka herhangi bir kişi tarafından giderilemeyecek şekilde annelik rolüne katkıda bulunur.",
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Benzer Konular",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return item1Widget(newsList[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        child: Container(
                          width: 316,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99.0),
                            gradient: LinearGradient(
                              begin: Alignment(-0.95, 0.0),
                              end: Alignment(1.0, 0.0),
                              colors: [
                                const Color(0xff9DCEFF),
                                const Color(0xff92A3FD),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Colors.transparent,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Center(
                              child: Text(
                                'Ana Sayfaya Geri Dön',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xffffffff),
                                  letterSpacing: -0.3858822937011719,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
