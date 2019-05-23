import 'package:flutter/material.dart';

import '../../languages/all_translations.dart';

class OffersPage extends StatefulWidget {
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
    void initState() {

      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("adsAndOffers"),style: TextStyle(color:Colors.grey),),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions:<Widget>[
          FlatButton(
            onPressed:Navigator.of(context).pop,
            child: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: ListView.builder(
          padding: EdgeInsets.all(20.0),
          itemCount: 30,
          itemBuilder: (BuildContext context,index){
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.only(bottom:20),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height:170,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/imgs/landpage_bk.jpg")
                  )
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}