import 'package:flutter/material.dart';
import 'package:health/Models/meal.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/measurement/itemList.dart';


import 'package:intl/intl.dart' as intl;

class AddFood extends StatefulWidget {
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String now = "";
  List<Meal> _meals = List();
  _getDummyMeals() {
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
  }

  _mealsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(onTap: _pressOnMeals,child:    Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
             
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/icons/ic_breakfast.png",width: 50,height: 50,),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(allTranslations.text("breakfast"), style: TextStyle(color: Colors.blueGrey))
          ],
        ) ,)
    ,
        InkWell(onTap: _pressOnMeals,child:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
      
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/icons/ic_luanch.png",
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              allTranslations.text("lunch"),
              style: TextStyle(color: Colors.blueGrey),
            )
          ],
        ) ,)
        ,
        InkWell(onTap: _pressOnMeals,child:   Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
           
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/icons/ic_dinner.png",
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(allTranslations.text("dinner"), style: TextStyle(color: Colors.blueGrey))
          ],
        ) ,)
     ,
        InkWell(onTap: _pressOnMeals,child:    Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
        
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/icons/ic_light_breakfast.png",
                  height: 50,
                  
                  width: 50,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(allTranslations.text("light breakfast"), style: TextStyle(color: Colors.blueGrey))
          ],
        ) ,)
    
      ],
    );
  }

  _pressOnMeals() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemList(isfood:true)),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDummyMeals();
    _getTime();
  }

  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(DateTime.now());
    setState(() {
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(allTranslations.text("Add Food")),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          now,
                          style: TextStyle(color: Colors.red, fontSize: 25.0),
                        ),
                        subtitle: Text(
                          intl.DateFormat("h:m a",allTranslations.locale.languageCode).format(DateTime.now()),
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: _mealsWidget(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                             allTranslations.text("calories"),
                              style: TextStyle(color: Colors.blue[300]),
                            ),
                            Text(
                              "50/100",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: LinearProgressIndicator(
                            value: 0.4,
                            backgroundColor: Colors.blue,
                          )),
                      Text(
                        allTranslations.text("food menu",),
                        style: TextStyle(color: Colors.blueGrey, fontSize: 24,fontWeight: FontWeight.bold),
                      ),
                      Column(
                          children: _meals.map((meal) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                meal.type,
                                style: TextStyle(
                                    color: Colors.blue[300], fontSize: 20),
                              ),
                              subtitle: Text(
                                meal.food,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.blueGrey),
                              ),
                              trailing: InkWell(
                                child: ImageIcon(AssetImage("assets/icons/ic_trash.png"),color: Colors.red,),onTap: (){

                                  _meals.remove(meal);
                                  setState(() {
                                    
                                  });
                                },
                              ),
                            ),
                            Divider(
                              height: 16,
                              color: Colors.blueGrey,
                            )
                          ],
                        );
                      }).toList())
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: FlatButton(
                    color: Color(0xff009DDC),
                    child: Text(
                      allTranslations.text("save"),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
