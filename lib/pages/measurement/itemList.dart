import 'package:flutter/material.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/Settings.dart' as settings;

class ItemList extends StatefulWidget {
  final bool isfood;
  ItemList({this.isfood});
  @override
  createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<String> items;
  List<bool> values;
  FocusNode _focusNode=FocusNode();
  _getDummyData() {
    items = List();
    values = List();
    for (int i = 0; i < 3; i++) {
      items.add("aboseed");
      values.add(false);
    }
  }

  @override
  void initState() {
    
    _getDummyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(onTap: (){
          _focusNode.unfocus();
      
        },child:  Scaffold(
            appBar: AppBar(
              title: Text(widget.isfood
                  ? allTranslations.text("Add Food")
                  : allTranslations.text("add midecne")),
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
                                addSlider: widget.isfood,
                                min: 0,
                                max: 2000,
                                title: "Add Food",
                                subtitle: "add Item not in menu",
                                image: "ic_list_food",
                                onSave: (String value) {
                                  setState(() {
                                    items.add(value);
                                    values.add(false);
                                  });
                                },
                              )
                            : settings.BottomSheet(
                                image: "ic_med",addSlider: false,
                                title: "add medicne",
                                subtitle:"add Item not in menu",
                                    onSave: (String value) {
                                  setState(() {
                                    items.add(value);
                                    values.add(false);
                                  });
                                }
                              );
                      });
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  items[index],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blueGrey),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: InkWell(
                                    child: Image.asset(values[index]
                                        ? "assets/icons/ic_choose_on.png"
                                        : "assets/icons/ic_radio_off.png"),
                                    onTap: () {
                                      setState(() {
                                        values[index] = !values[index];
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
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: FlatButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        allTranslations.text("Add"),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        //get all the check items
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ))));
  }
}

class BottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final double min;
  final double max;
 final bool addSlider;
  final onSave;
  BottomSheet(
      {Key key,
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
                            child: TextField()),
                        Container(
                            width: 100,
                            child:  Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            TextField(
          //    focusNode: focusNode,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.number,controller: _controller,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
            Text(
            allTranslations.text(  "cal"),
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
                            widget.onSave(_controllerName.text);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
