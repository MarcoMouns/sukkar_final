import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart' as settings;
import 'package:shared_preferences/shared_preferences.dart';
import '../../scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/foods_model.dart';
import '../../Models/medicine_model.dart';

class ItemList extends StatefulWidget {
  final MainModel model;
  final int mealId;
  final bool isfood;
  ItemList({this.model, this.mealId, this.isfood});
  @override
  createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<String> items;
  List<bool> values;
  Map<String, dynamic> user;
  List<Foods> _selectedFoods = [];
  FocusNode _focusNode = FocusNode();
  String filter = "";

  List<Foods> foods = [];
  List<Medicine> medicines = [];

  Dio dio = new Dio();
  Response response;

  final String baseUrl = 'http://api.sukar.co/api';

  Future<Void> getMedicine() async {
    // get user token
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));

    print("authUser => $authUser");
    print("authUserToken => ${authUser['authToken']}");

    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };

    response =
        await dio.get("$baseUrl/medicine", options: Options(headers: authUser));
    print(response.data);
    for (int i = 0; i < response.data['medicines'].length; i++) {
      Medicine md = new Medicine();

      md.id = response.data['medicines'][i]['id'];
      md.name = response.data['medicines'][i]['name'];
      md.createdAt = response.data['medicines'][i]['created_at'];
      md.updatedAt = response.data['medicines'][i]["updated_at"];
      md.isSelected = 0;
      medicines.add(md);
    }
    setState(() {});
  }

  Future<Void> getMeals() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get("$baseUrl/foods?category=${widget.mealId}",
        options: Options(headers: headers));

    for (int i = 0; i < response.data['foods'].length; i++) {
      Foods fd = new Foods();
      fd.id = response.data['foods'][i]['id'];
      fd.titleAr = response.data['foods'][i]['title_ar'];
      fd.titleEn = response.data['foods'][i]['title_en'];
      fd.calories = response.data['foods'][i]['calories'];
      fd.createdAt = response.data['foods'][i]['created_at'];
      fd.updatedAt = response.data['foods'][i]["updated_at"];
      fd.userId = response.data['foods'][i]["user_id"];
      fd.isselected = 0;
      foods.add(fd);
      print(i);
    }

    setState(() {});
  }

  Future<Void> addTakenMed(int id, int mealID) async {
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.post("$baseUrl/medicine/$id?category=$mealID",
        options: Options(headers: headers));
    print(response.data);

    setState(() {});
  }

  Future<Void> addNewFood(String ar, String en, int cal, int mealID) async {
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.post(
        "$baseUrl/add-new-food?title_ar=$ar&title_en=$en&calories=$cal&eat_category_id=$mealID",
        options: Options(headers: headers));
    print(response.data);

    setState(() {});
  }

  List<Medicines> _selectedMedicines = [];

  void _saveUserFoods() async {
    bool ok =
        await widget.model.addSelectedFoods(_selectedFoods, widget.mealId);
    if (ok) {
      Navigator.pop(context, true);
      print("Selected foods added successfully");
    } else {
      // Show Error
      print("Selected foods not added");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isfood == false) {
      getMedicine();
    } else {
      getMeals();
    }

    SharedPreferences.getInstance().then((storage) {
      setState(() {
        user = jsonDecode(storage.getString("authUser"));
      });

      print("user 8888888888 $user");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.isfood
                        ? allTranslations.text("Add Food")
                        : allTranslations.text("add midecne"),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return widget.isfood
                                ? BottomSheet(
                                    model: widget.model,
                                    categoryId: widget.mealId,
                                    addSlider: widget.isfood,
                                    min: 0,
                                    max: 2000,
                                    title: "Add Food",
                                    subtitle: "add Item not in menu",
                                    image: "ic_list_food",
                                    onSave: (String foodName, String calories) {
                                      print(
                                          "***************** ${double.parse(calories.trim()).toInt()}");
                                      setState(() {
                                        Foods foodItem = Foods.fromJson({
                                          'title_ar': foodName,
                                          'title_en': foodName,
                                          'calories':
                                              double.parse(calories.trim())
                                                  .toInt(),
                                          'eat_category_id': widget.mealId,
                                          'isselected': 0,
                                        });
                                        print(
                                            "------------- ${foodItem.titleAr}");
                                        print("]]]]]]]]]]]]]]> $foods");
                                        foods.add(foodItem);
                                        addNewFood(
                                            foodItem.titleAr,
                                            foodItem.titleEn,
                                            foodItem.calories,
                                            widget.mealId);
                                        foods.clear();
                                        getMeals();
                                        setState(() {});
                                      });
                                    },
                                  )
                                : settings.BottomSheet(
                                    image: "ic_med",
                                    addSlider: false,
                                    title: "add medicne",
                                    subtitle: "add Item not in menu",
                                    onSave: (String value) async {
                                      widget.model.addNewMedicine({
                                        "name": value,
                                        "user_id": user['id'],
                                      }).then((result) {
                                        medicines.clear();
                                        getMedicine();
                                      });
                                    });
                          });
                      setState(() {});
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: ShapeDecoration(
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.all(
                                    Radius.elliptical(10, 10)))),
                        child: TextField(
                          onChanged: (String value) {
                            filter = value;
                            setState(() {});
                          },
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: allTranslations.text("Search"),
                              prefixIcon:
                                  Image.asset("assets/icons/ic_search.png")),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              widget.isfood ? foods.length : medicines.length,
                          itemBuilder: (context, index) {
                            Widget result;
                            bool isRight = widget.isfood
                                ? foods[index].titleAr.contains(filter)
                                : medicines[index].name.contains(filter);
                            isRight
                                ? result = Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              widget.isfood
                                                  ? foods[index].titleAr
                                                  : medicines[index].name,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blueGrey),
                                            ),
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              child: InkWell(
                                                child: widget.isfood
                                                    ? Image.asset(foods[index]
                                                                .isselected ==
                                                            0
                                                        ? "assets/icons/ic_radio_off.png"
                                                        : "assets/icons/ic_radio_on.png")
                                                    : Image.asset(medicines[
                                                                    index]
                                                                .isSelected ==
                                                            1
                                                        ? "assets/icons/ic_radio_on.png"
                                                        : "assets/icons/ic_radio_off.png"),
                                                onTap: () {
                                                  setState(() {
                                                    if (widget.isfood) {
                                                      if (foods[index]
                                                              .isselected ==
                                                          0) {
                                                        foods[index]
                                                            .isselected = 1;
                                                        _selectedFoods
                                                            .add(foods[index]);
                                                      } else {
                                                        foods[index]
                                                            .isselected = 0;
                                                        _selectedFoods.remove(
                                                            foods[index]);
                                                      }

                                                      print(
                                                          "selected food $_selectedFoods");
                                                    } else {
                                                      if (medicines[index]
                                                              .isSelected ==
                                                          0) {
                                                        medicines[index]
                                                            .isSelected = 1;

                                                        //TODO:add meal id dialog
                                                        int meal;

                                                        showCupertinoModalPopup(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CupertinoActionSheet(
                                                            title: Text(
                                                                allTranslations
                                                                    .text(
                                                                        "medicineMeal")),
                                                            actions: <Widget>[
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                    allTranslations
                                                                        .text(
                                                                            "breakfast")),
                                                                onPressed: () {
                                                                  meal = 1;
                                                                  addTakenMed(
                                                                      medicines[
                                                                              index]
                                                                          .id,
                                                                      meal);
                                                                  medicines[
                                                                          index]
                                                                      .isSelected = 0;
                                                                  setState(
                                                                      () {});

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                    allTranslations
                                                                        .text(
                                                                            "lunch")),
                                                                onPressed: () {
                                                                  meal = 2;
                                                                  addTakenMed(
                                                                      medicines[
                                                                              index]
                                                                          .id,
                                                                      meal);
                                                                  medicines[
                                                                          index]
                                                                      .isSelected = 0;
                                                                  setState(
                                                                      () {});

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                    allTranslations
                                                                        .text(
                                                                            "dinner")),
                                                                onPressed: () {
                                                                  meal = 3;
                                                                  addTakenMed(
                                                                      medicines[
                                                                              index]
                                                                          .id,
                                                                      meal);
                                                                  medicines[
                                                                          index]
                                                                      .isSelected = 0;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                    allTranslations
                                                                        .text(
                                                                            "cancel")),
                                                                onPressed: () {
                                                                  medicines[
                                                                          index]
                                                                      .isSelected = 0;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          indent: 2,
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  )
                                : result = Container();
                            return result;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      !widget.isfood
                          ? Container()
                          : SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: FlatButton(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Text(
                                  allTranslations.text("Add"),
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: _saveUserFoods,
                              ),
                            )
                    ],
                  ),
                ))));
  }
}

class BottomSheet extends StatefulWidget {
  final MainModel model;
  final int categoryId;
  final String title;
  final String subtitle;
  final String image;
  final double min;
  final double max;
  final bool addSlider;
  final onSave;
  BottomSheet(
      {Key key,
      this.model,
      this.categoryId,
      this.title,
      this.subtitle,
      this.image,
      this.min,
      this.max,
      this.addSlider,
      this.onSave})
      : super(key: key);
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  final _controller = TextEditingController();
  final _controllerName = TextEditingController();
  double _value = 0;

  Map<String, dynamic> _mealData = {
    "name": null,
    "categoryId": null,
    "calories": null,
  };

  @override
  void initState() {
    super.initState();

    _controller.text = "0";
    _controller.addListener(() {
      if (double.parse(_controller.text) > widget.max) {
        _value = widget.max;
        _controller.text = widget.max.toString();
      } else if (double.parse(_controller.text) < widget.min) {
        _controller.text = widget.min.toString();
        _value = widget.min;
      } else {
        _value = double.parse(_controller.text);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(_value);
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image.asset(
                          "assets/icons/${widget.image}.png",
                          height: 50,
                          width: 50,
                          color: Colors.red,
                        ),
                        Text(
                          allTranslations.text(widget.title),
                          style:
                              TextStyle(fontSize: 20, color: Colors.redAccent),
                        ),
                        Text(
                          allTranslations.text(widget.subtitle),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                            width: 150,
                            child: TextField(
                              controller: _controllerName,
                            )),
                        Container(
                            width: 100,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                TextField(
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.number,
                                  controller: _controller,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  allTranslations.text("cal"),
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            )),
                        Slider(
                          inactiveColor: Colors.grey,
                          value: _value,
                          min: widget.min,
                          max: widget.max,
                          divisions: (widget.max - widget.min).toInt(),
                          label: '${_value.round()}',
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                              _controller.text = _value.toString();
                            });
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            allTranslations.text("save"),
                          ),
                          onPressed: () {
                            widget.onSave(
                                _controllerName.text, _controller.text);
                                setState(() {});
                            Navigator.of(context).pop();
                            
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
