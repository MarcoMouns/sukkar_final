import 'package:flutter/material.dart';
import 'package:health/scoped_models/main.dart';

import '../shared-data.dart';
import 'home.dart';
import 'others/notification.dart';

import '../languages/all_translations.dart';

class Settings {
  static String googleApi = 'AIzaSyCBlmohZdkR7SPHIsQDzIMhKNc_wLaimDs';

  static int currentIndex = 0;
  static Function navigationTapped;

  static mainColor() {
    return Color.fromRGBO(32, 158, 212, 1);
  }

  static Widget appBar({Widget title, BuildContext context, MainModel model}) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 40),
      child: Material(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notifications()));
                  },
                  icon: ImageIcon(AssetImage("assets/icons/ic_bell.png")),
                ),
              ],
            ),
            title,
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editProfile');
              },

              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(SharedData
                    .customerData['image'] ==
                    'Null' ||
                    SharedData.customerData['image'] == null
                    ? 'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png'
                    : 'http://api.sukar.co${SharedData.customerData['image']}'),
              ),
            )
          ],
        ),
      ),
    );
  }

  static onLocaleChanged() async {
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }
}

class LogInInput extends StatefulWidget {
  final String name;
  final Function onSaved;
  final Function validator;
  final TextInputType keyboard;
  final TextEditingController controller;
  final bool isPassword;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final bool enabled;
  final bool autoValidate;
  var initVal;

  LogInInput(
      {Key key,
      this.name,
      this.controller,
      this.onSaved,
      this.validator,
      this.keyboard,
      this.focusNode,
      this.enabled,
      this.autoValidate,
      this.onFieldSubmitted,
      this.initVal,
      this.isPassword = false})
      : super(key: key);

  _LogInInputState createState() => _LogInInputState();
}

class _LogInInputState extends State<LogInInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
      child: TextFormField(
        initialValue: widget.initVal,
        focusNode: widget.focusNode,
        autovalidate: widget.autoValidate,
        enabled: widget.enabled,
        controller: widget.controller,
        decoration:
            new InputDecoration(labelText: allTranslations.text(widget.name)),
        keyboardType: widget.keyboard,
        textInputAction: TextInputAction.done,
        onSaved: widget.onSaved,
        validator: widget.validator,
        obscureText: widget.isPassword,
      ),
    );
  }
}

class LoginType extends StatefulWidget {
  final String svg;
  final IconData icon;
  final Function onPress;
  final bool isActive;

  LoginType({Key key, this.icon, this.svg, this.onPress, this.isActive = false})
      : super(key: key);

  _LoginTypeState createState() => _LoginTypeState();
}

class _LoginTypeState extends State<LoginType> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Opacity(
          opacity: widget.isActive ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
                color: Settings.mainColor(),
                borderRadius: BorderRadius.circular(25.0)),
            child: IconButton(
                onPressed: widget.onPress,
                icon: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 25.0,
                      )
                    : Icon(
                        widget.icon,
                        color: Colors.red,
                        size: 25.0,
                      )
                ),
          ),
        ),
      ),
    );
  }
}

class ConfirmInputWidget extends StatefulWidget {
  final String initValue;
  final Function onSave;
  final TextEditingController controller;
  final FocusNode focus;

  ConfirmInputWidget(
      {this.initValue = '', this.onSave, this.controller, this.focus});

  @override
  _ConfirmInputWidgetState createState() => new _ConfirmInputWidgetState();
}

class _ConfirmInputWidgetState extends State<ConfirmInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: ""),
        controller: widget.controller,
        focusNode: widget.focus,
        onChanged: widget.onSave,
        maxLength: 1,
        maxLengthEnforced: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    ));
  }
}

class MenuListRow extends StatelessWidget {
  final String image;
  final String title;

  final Function onTap;
  var animationController;
  var animationController2;

  MenuListRow(
      {Key key,
      this.title,
      this.image,
      this.onTap,
      this.animationController,
      this.animationController2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          textDirection: allTranslations.currentLanguage == "ar"
              ? TextDirection.ltr
              : TextDirection.rtl,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animationController2),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(animationController),
                  child: Image.asset(
                    "assets/icons/$image.png",
                    width: 35,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animationController2),
                child: Text(
                  allTranslations.text(title),
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class BottomSheet extends StatefulWidget {
  final String type;
  final String title;
  final String subtitle;
  final String image;
  final double min;
  final double max;
  final bool addSlider;
  final onSave;

  BottomSheet(
      {Key key,
      this.type,
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
  int _value = 0;

  @override
  void initState() {
    super.initState();

    if (widget.addSlider) {
      _controller.text = "0";
      _controller.addListener(() {
        if (double.parse(_controller.text) > widget.max) {
          _value = widget.max ~/ 1;
          _controller.text = widget.max.toString();
        } else if (double.parse(_controller.text) < widget.min) {
          _controller.text = widget.min.toString();
          _value = widget.min ~/ 1;
        } else {
          _value = int.parse(_controller.text);
        }
        if (_controller.text.contains(".")) {

        }

        setState(() {});
      });
    }
  }

  Future<void> pop() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainHome()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
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
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            allTranslations.text(widget.subtitle),
                            style: TextStyle(color: Colors.grey),
                          ),
                          Container(
                            width: 150,
                            child: LogInInput(
                              enabled: true,
                              autoValidate: true,
                              name: "",
                              controller: _controller,
                              keyboard: widget.addSlider
                                  ? TextInputType.numberWithOptions()
                                  : null,
                            ),
                          ),
                          widget.addSlider
                              ? Slider(
                            inactiveColor: Colors.grey,
                            value: double.parse(_value.toString()),
                            min: widget.min,
                            max: widget.max,
                            divisions: (widget.max - widget.min).toInt(),
                            label: '${_value.round()}',
                            onChanged: (value) {
                              setState(() {
                                _value = value ~/ 1;
                                _controller.text = _value.toString();
                              });
                            },
                          )
                              : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                          RaisedButton(
                            child: Text(
                              allTranslations.text("save"),
                            ),
                            onPressed: () {
                              widget.onSave(_controller.text);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )),
      onWillPop: () => pop(),
    );
  }
}

class Search extends StatefulWidget {
  final String hintText;

  Search({this.hintText});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: ShapeDecoration(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(Radius.elliptical(10, 10)))),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: allTranslations.text(widget.hintText),
            prefixIcon: Image.asset("assets/icons/ic_search.png")),
      ),
    );
  }
}

class UpperBarProfile extends StatelessWidget {
  final String title, subTitle;
  final Image image;
  final double height;

  UpperBarProfile({this.title, this.subTitle, this.image, this.height = 210});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height + 23 + 14 + 10,
      color: Color.fromRGBO(17, 158, 212, 1),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          Container(
              width: height / 2,
              height: height / 2,
              padding: EdgeInsets.only(top: 30, bottom: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  image:
                      DecorationImage(image: image.image, fit: BoxFit.cover))),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
          SizedBox(
            height: 5,
          ),
          subTitle == ""
              ? SizedBox(
                  height: 0,
                  width: 0,
                )
              : Text(
                  subTitle,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final navigationTapped;
  final PageController pageController;
  final Color plusColor;

  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();

  CustomBottomNavigationBar(
      {this.navigationTapped, this.pageController, this.plusColor});
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static List<BottomNavigationBarItem> _listItems =
      List<BottomNavigationBarItem>();
  static CustomBottomNavigationBarState c;

  CustomBottomNavigationBarState() {
    c = this;
  }

  _getDate() {
    _listItems.clear();

    _listItems.add(BottomNavigationBarItem(
        icon: Image.asset(
          "assets/icons/ic_home${Settings.currentIndex == 0 ? '_active' : ''}.png",
          height: 25,
          width: 25,
        ),
        title: Text(
          allTranslations.text("home"),
          style: TextStyle(
              color: Settings.currentIndex == 0 ? Colors.blue : Colors.black),
        )));

    _listItems.add(BottomNavigationBarItem(
        icon: Image.asset(
          "assets/icons/ic_article${Settings.currentIndex == 1 ? '_active' : ''}.png",
          height: 25,
          width: 25,
        ),
        title: Text(
          allTranslations.text("articles"),
          style: TextStyle(
              color: Settings.currentIndex == 1 ? Colors.blue : Colors.black),
        )));
    _listItems.add(BottomNavigationBarItem(
        icon: Image.asset(
          "assets/icons/ic_friends${Settings.currentIndex == 2 ? '_active' : ''}.png",
          height: 25,
          width: 25,
        ),
        title: Text(allTranslations.text("friends"),
            style: TextStyle(
                color:
                    Settings.currentIndex == 2 ? Colors.blue : Colors.black))));
    _listItems.add(
      BottomNavigationBarItem(
        icon:  Image.asset(
                "assets/icons/ic_doctor${Settings.currentIndex == 3 ? '_active' : ''}.png",
                height: 25,
                width: 25,
              ),
        title: Text(
          allTranslations.text("doctors"),
          style: TextStyle(
              color: Settings.currentIndex == 3 ? Colors.blue : Colors.black),
        ),
      ),
    );
    _listItems.add(BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("assets/icons/ic_add.png"),
            size: 25, color: widget.plusColor),
        title: Text(allTranslations.text("more"))));
  }

  reload() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    _getDate();
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.white,
            highlightColor: Colors.white,
            textTheme: TextTheme(caption: TextStyle(color: Colors.black))),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: _listItems,
            currentIndex: Settings.currentIndex,
            onTap: widget.navigationTapped),
      ),
    );
  }
}
