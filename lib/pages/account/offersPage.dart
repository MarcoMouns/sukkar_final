import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/pages/others/adDetails.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  Response response;
  Dio dio = new Dio();

  bool isLoading = true;
  List<String> ads = new List();
  List<String> adTexts = new List();
  List<String> link = new List();
  List<Widget> adsCards = new List();

  getOffers() async {
    response = await dio.get("${Settings.baseApilink}/ads");
    for (int i = 0; i < response.data["ads"].length; i++) {
      ads.add(response.data["ads"][i]["image"].toString());
      link.add(response.data["ads"][i]["link"].toString());
      adTexts.add(response.data["ads"][i]["text"].toString());
    }
    isLoading = false;
    setState(() {});
  }

  List<Widget> displayAds() {
    List<Widget> list = new List();
    for (int i = 0; i < ads.length; i++) {
      list.add(SizedBox(
        height: 20,
      ));
      list.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AdDetailsScreen(ads[i], adTexts[i], link[i])));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            decoration: ShapeDecoration(
                image: DecorationImage(
                    image: NetworkImage('http://api.sukar.co/${ads[i]}'),
                    fit: BoxFit.cover),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.4,
          )));
    }
    adsCards = list;
    return list;
  }

  @override
  void initState() {
    super.initState();
    getOffers();
    displayAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("offers")),
      ),
      body: isLoading == true
          ? Loading()
          : ListView(
              children: ads.isEmpty
                  ? <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(allTranslations.text("noOffers")),
                      )
                    ]
                  : displayAds(),
            ),
    );
  }
}
