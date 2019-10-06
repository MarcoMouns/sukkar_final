import 'package:flutter/material.dart';
import 'package:health/Models/meal.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/measurement/itemList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/meals.dart';
import '../../Models/all_meals_foods.dart';

import 'package:intl/intl.dart' as intl;

import '../../shared-data.dart';

class AddFood extends StatefulWidget {
  final MainModel model;
  AddFood(this.model);
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String now = "";
  List<Meal> _meals = List();
  List<Eatcategories> allMeals = List<Eatcategories>();
  List<UserFoods> allMealsFoods = List<UserFoods>();
  List<int> _calories = [];
  bool loading;
  int Rcalories;

  _getDummyMeals() {
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
    _meals.add(Meal(type: "lanuch", food: "eggs"));
  }

  _mealsWidget(MainModel model) {
//    print('All Meals = > ${allMeals.length}');
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        width: 10,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: allMeals.length,
      itemBuilder: (BuildContext context, int index) {
        print('All allMeals[index] = > ${allMeals[index]}');
        return InkWell(
          onTap: () => _pressOnMeals(model, allMeals[index].id),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    "http://104.248.168.117/${allMeals[index].image}",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(allMeals[index].titleAr,
                  style: TextStyle(color: Colors.blueGrey))
            ],
          ),
        );
      },
    );
  }

  _pressOnMeals(MainModel model, int mealId) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ItemList(model: model, mealId: mealId, isfood: true)),)
        .then((val)=>val?fetchMeals():null);
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    fetchMeals();
    _getDummyMeals();
    _getTime();
  }

  Future<void> fetchMeals() async{
    await widget.model.fetchMeals().then((result) {
      if (result != null) {
        setState(() {
          allMeals = result.eatcategories;
          loading = false;
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
    await widget.model.fetchAllMealsFoods().then((result) {
      print('Result fetch => $result');
      if (result != null) {
        setState(() {
          allMealsFoods = result.userFoods;
          _calories = result.userFoods.map((meal) => meal.calories).toList();
          print('******************************_calories = > $_calories');
          addIntToSF();
          getValuesSF();
          loading = false;
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  addIntToSF() async {
    print(_calories);
    if(_calories.length==0){
      Rcalories=0;
    }
    else{
      Rcalories = _calories.reduce((a, b) => a + b).toInt();
    }
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    // print(a);
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ncal = SharedData.customerData['average_calorie'];
    if(ncal==null){
      ncal=0;
    }

    print(ncal);

    print(Rcalories);

    int calTarget=0;

    if(Rcalories>ncal && ncal!=0){
      calTarget=Rcalories-ncal;
    }
    prefs.setInt('calTarget', calTarget);
    int x;
    x= prefs.getInt('calTarget');

    print('++++++++++++++++++++++++++++++++++++++++++++++++++');
    print(x);
    print('++++++++++++++++++++++++++++++++++++++++++++++++++');

  }

  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(DateTime.now());
    setState(() {});
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
          body:
//          new Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.all(20),
//                  margin: EdgeInsets.only(bottom: 20),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                      color: Colors.redAccent
//                  ),
//                  child: Icon(
//                    Icons.developer_mode,
//                    size: 60,
//                    color: Colors.white,
//                  ),
//                ),
//                Text('Under Development',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
//              ],
//            ),
//          )
          new ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return loading == true ? Loading() : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              now,
                              style:
                              TextStyle(color: Colors.red, fontSize: 25.0),
                            ),
                            subtitle: Text(
                              intl.DateFormat("h:m a",
                                  allTranslations.locale.languageCode)
                                  .format(DateTime.now()),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 140,
                            padding: EdgeInsets.only(top: 30),
                            child: _mealsWidget(model),
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
                                  _calories.isEmpty ? '0':
                                  "${_calories.reduce((a, b) => a + b).toString()}",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: LinearProgressIndicator(
                                value: _calories.isEmpty ? 1 : 0.9,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70,),
                                backgroundColor: Colors.blue,
                              )),
                          Text(
                            allTranslations.text(
                              "food menu",
                            ),
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          new Column(
                              children: allMealsFoods.map((meal) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        meal.eatcategories.titleAr,
                                        style: TextStyle(
                                            color: Colors.blue[300], fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        meal.titleAr,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.blueGrey),
                                      ),
//                                  trailing: InkWell(
//                                    child: ImageIcon(
//                                      AssetImage("assets/icons/ic_trash.png"),
//                                      color: Colors.red,
//                                    ),
//                                    onTap: () {
//                                      allMealsFoods.remove(meal);
//                                      _calories.remove(meal.calories);
//                                      setState(() {});
//                                    },
//                                  ),
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
              );
            },
          ),

        ));
  }
}
