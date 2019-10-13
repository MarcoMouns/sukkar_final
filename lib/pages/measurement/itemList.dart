import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart' as settings;
import 'package:shared_preferences/shared_preferences.dart';
import '../../scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Models/foods_model.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Foods> foods = [];
  List<Medicines> medicines = [];
  List<Medicines> _selectedMedicines = [];
  // _getDummyData() {
  //   items = List();
  //   values = List();
  //   for (int i = 0; i < 3; i++) {
  //     items.add("aboseed");
  //     values.add(false);
  //   }
  // }

  // Map<String, dynamic> _mealData = {
  //   "name":null,
  //   "categoryId":null,
  //   "calories":null,
  // };

  void _saveUserFoods() async {
    bool ok =
        await widget.model.addSelectedFoods(_selectedFoods, widget.mealId);
    if (ok) {
      Navigator.pop(context,true);
      print("Selected foods added successfully");
    } else {
      // Show Error
      print("Selected foods not added");
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((storage) {
      setState(() {
        user = jsonDecode(storage.getString("authUser"));
      });

      print("user 8888888888 $user");
    });

    // SharedPreferences.getInstance().then((storage) {
    //   setState(() {
    //     medicines = storage
    //         .getStringList("savedMedicines")
    //         .map<Map<String, dynamic>>((String item) => jsonDecode(item))
    //         .toList();
    //   });

    //   print("user 8888888888 $medicines");
    // });

//    if (widget.isfood) {
//      widget.model.fetchUserFoods().then((result) {
//        print("***************************** -----> ${result.foods}");
//        if (result != null) {
//          print("===============> $result");
//          setState(() {
//            foods.addAll(result.foods);
//          });
//        }
//      });
//    } else {
//      widget.model.fetchUserMedicines().then((result) {
//        print("***************************** -----> ${result.medicines}");
//        if (result != null) {
//          print("===============> $result");
//          setState(() {
//            medicines.addAll(result.medicines);
//          });
//        }
//      });
//    }

    //-------------- local notification setup --------------//
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var ios = new IOSInitializationSettings();
//    var initSettings = new InitializationSettings(android, ios);
//    flutterLocalNotificationsPlugin.initialize(initSettings,
//        onSelectNotification: (dynamic payload) {
//      return null;
//    });

    //------------------------------------------------------//
    super.initState();
  }

  // showNotification(DateTime dateTime) async {
  //   var time = new Time(dateTime.hour,dateTime.minute, dateTime.second);
  //   var android = new AndroidNotificationDetails(
  //       "channelId", "channelName", "channelDescription",
  //       sound: "medicine",
  //       priority: Priority.High,
  //       importance: Importance.Max);
  //   var iOS = new IOSNotificationDetails(sound: "medicine.mp3");

  //   var platform = new NotificationDetails(android, iOS);

  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //       0, ' سكر', 'ميعاد الدوا يابرنس', time, platform,
  //       payload: "");
  // }

//  showNotification(DateTime dateTime) async {
//    var scheduledNotificationDateTime = dateTime;
//    var android = new AndroidNotificationDetails(
//        "channelId", "channelName", "channelDescription",
//        sound: "medicine", priority: Priority.High, importance: Importance.Max);
//    var iOS = new IOSNotificationDetails(sound: "medicine.mp3");
//
//    var platform = new NotificationDetails(android, iOS);
//
//    await flutterLocalNotificationsPlugin.schedule(
//        0,
//        'الرفيق الصوتى',
//        'لديك تسجيل تم جدولته لكى تستمع اليه الان اضغط للاستماع',
//        scheduledNotificationDateTime,
//        platform,
//        payload: "");
//  }

//  Future<void> _showDailyAtTime(DateTime dateTime) async {
//    var time = Time(dateTime.hour, dateTime.minute, dateTime.second);
//    print("time ==> $time");
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'repeatDailyAtTime channel id',
//        'repeatDailyAtTime channel name',
//        'repeatDailyAtTime description');
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        'show daily title',
//        'Daily notification shown at approximately ${time.hour}:${time.minute}:${time.second}',
//        time,
//        platformChannelSpecifics);
//  }

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
                                        // values.add(false);
                                      });
                                    },
                                  )
                                : settings.BottomSheet(
                                    image: "ic_med",
                                    addSlider: false,
                                    title: "add medicne",
                                    subtitle: "add Item not in menu",
                                    onSave: (String value) async {
                                      // print("$value ====== > ${user['id']}");
                                      // setState(() {
                                      //   medicines.add({
                                      //     "name": value,
                                      //     "user_id": user['id'],
                                      //     "isSelected": false,
                                      //   });

                                      //   print("$value ====== > ${user['id']}");
                                      //   // values.add(false);
                                      // });

                                      widget.model.addNewMedicine({
                                        "name": value,
                                        "user_id": user['id'],
                                      }).then((result) {
                                        if (result) {
                                          widget.model
                                              .fetchUserMedicines()
                                              .then((result) {
                                            print(
                                                "***************************** -----> ${result.medicines}");
                                            if (result != null) {
                                              print("===============> $result");
                                              setState(() {
                                                medicines = result.medicines;
                                              });
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      });

                                      // SharedPreferences storage =
                                      //     await SharedPreferences.getInstance();

                                      // storage.setStringList(
                                      //     "savedMedicines",
                                      //     medicines
                                      //         .map<String>(
                                      //             (Map<String, dynamic> item) =>
                                      //                 jsonEncode(item))
                                      //         .toList());
                                    });
                          });
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context,true);
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
                            // print(value);
                            // medicines = medicines.map((item) {
                            //   print(item['name'].contains(value));
                            //   if (item['name'].contains(value)) {
                            //     return item;
                            //   } else {
                            //     return null;
                            //   }
                            // }).toList();

                            // print(medicines);
                            // setState(() {});
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
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      widget.isfood
                                          ? foods[index].titleAr
                                          : medicines[index].medicine.name,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.blueGrey),
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
                                            : Image.asset(medicines[index]
                                                        .medicine
                                                        .isSelected ==
                                                    1
                                                ? "assets/icons/ic_radio_on.png"
                                                : "assets/icons/ic_radio_off.png"),
                                        onTap: () {
                                          setState(() {
                                            if (widget.isfood) {
                                              if (foods[index].isselected ==
                                                  0) {
                                                foods[index].isselected = 1;
                                                _selectedFoods
                                                    .add(foods[index]);
                                              } else {
                                                foods[index].isselected = 0;
                                                _selectedFoods
                                                    .remove(foods[index]);
                                              }

                                              print(
                                                  "selected food $_selectedFoods");
                                            } else {
                                              if (medicines[index]
                                                      .medicine
                                                      .isSelected ==
                                                  0) {
                                                medicines[index]
                                                    .medicine
                                                    .isSelected = 1;
                                                _selectedMedicines
                                                    .add(medicines[index]);

                                                //-----------
                                                DatePicker.showTimePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    onChanged: (time) {
                                                  print('change $time');
                                                }, onConfirm: (time) {
                                                  print('confirm $time');
//                                                  _showDailyAtTime(time);
                                                  // showNotification(time);
                                                },
                                                    currentTime: DateTime.now(),
                                                    locale: LocaleType.en);
                                              } else {
                                                medicines[index]
                                                    .medicine
                                                    .isSelected = 0;
                                                _selectedMedicines
                                                    .remove(medicines[index]);
                                              }

                                              print(
                                                  "_selectedMedicines $_selectedMedicines");
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
                            );
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
                                  //    focusNode: focusNode,
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
                            Navigator.of(context).pop();
                            // model.addNewFood({
                            //   "name": _controllerName.text,
                            //   "categoryId": widget.categoryId,
                            //   "calories": _controller.text,
                            // }).then((resutl) {
                            //   if (resutl) {
                            //     Navigator.pop(context);
                            //   } else {
                            //     print("errooooooooooooooooooooorrrrrrrrrr");
                            //   }
                            // });
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
