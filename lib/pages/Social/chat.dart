import 'package:flutter/material.dart';
import 'package:health/Models/doctor_tab/doctor_chat.dart';
import 'package:health/pages/Social/profileMeasuresDetails.dart';
import 'package:health/scoped_models/main.dart';
import 'package:health/languages/all_translations.dart';

class Chat extends StatefulWidget {
  bool isDoctor = false;
  final userId;
  final String name;
  final String image;
  final MainModel model;

  Chat({this.isDoctor, this.userId, this.model, this.image, this.name});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FocusNode _focusNode = FocusNode();
  bool loading = false;
  bool _isLoading = false;
  List<DataListBean> doctorChat = List<DataListBean>();
  var message;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  void initState() {
    print('userID => ${widget.userId}');
    print('image => ${widget.image}');
    setState(() {
      loading = true;
    });
    getChat();
    super.initState();
  }
  getChat(){
    widget.model.fetchDoctorChat(widget.userId).then((result) {
      if (result != null) {
        setState(() {
          doctorChat = result.chat.data;
          print(doctorChat);
          setState(() {
            loading = false;
          });
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
  //Submit Send
  void submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      _isLoading = false;
      return;
    }
    _formKey.currentState.save();
    widget.model.sendMessage(message, widget.userId).then((result) {
      if (result != null) {
        setState(() {
          print(result);
          message = '';
          getChat();
          setState(() {
            _isLoading = false;
          });
        });
      } else {}
    }).catchError((err) {
      print(err);
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
                body: SafeArea(
              child: Column(
                children: <Widget>[
                  new Card(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Image.asset(
                            "assets/icons/ic_back.png",
                            width: 25,
                            height: 25,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        ClipOval(
                            child: Image.network(
                          widget.image == 'Null'
                              ? "https://images.vexels.com/media/users/3/151709/isolated/preview/098c4aad185294e67a3f695b3e64a2ec-doctor-avatar-icon-by-vexels.png"
                              : 'http://api.sukar.co/ ${widget.image}',
                          width: 40,
                          height: 40,
                        )),
                        Container(
                          child: Text(
                            '${widget.name.toString()}',
                            style: TextStyle(
                                color: Color.fromRGBO(12, 163, 214, 1)),
                          ),
                          padding: EdgeInsetsDirectional.only(start: 5),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 0,
                          ),
                        ),
                        widget.isDoctor
                            ? SizedBox(
                                height: 0,
                                width: 0,
                              )
                            : InkWell(
                                child: Image.asset(
                                  "assets/icons/ic_chart.png",
                                  width: 40,
                                  height: 40,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfileMeasurementDetails(widget.userId)));
                                },
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: new ListView.builder(
                        itemCount: doctorChat.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return new Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.fromLTRB(
                                doctorChat[index].userRecieve != widget.userId
                                    ? 0
                                    : 50,
                                0,
                                doctorChat[index].userRecieve != widget.userId
                                    ? 50
                                    : 0,
                                20),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: doctorChat[index].userRecieve !=
                                        widget.userId
                                    ? Color.fromRGBO(232, 244, 251, 1)
                                    : Color.fromRGBO(0, 159, 208, 1)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    doctorChat[index].body,
                                    style: TextStyle(
                                        color: doctorChat[index].userRecieve !=
                                                widget.userId
                                            ? Color.fromRGBO(136, 142, 158, 1)
                                            : Colors.white),
                                  ),
                                ),
//                                 new Align(
//                                    child: Text(
//                                      "10 :35 AM",
//                                      style: TextStyle(
//                                          color: index % 2 == 0
//                                              ? Color.fromRGBO(181, 190, 202, 1)
//                                              : Color.fromRGBO(14, 14, 14, 1)),
//                                    ),
//                                    alignment: index % 2 == 0
//                                        ? Alignment.centerLeft
//                                        : Alignment.centerRight,
//                                  )
                              ],
                            ),
                            alignment:
                                doctorChat[index].userRecieve != widget.userId
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  Form(
                      key: _formKey,
                      child: new Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 5),
//                            child: Image.asset(
//                              "assets/icons/ic_emoticon.png",
//                              width: 25,
//                              height: 25,
//                            ),
//                          ),
                              Expanded(
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    hintText: allTranslations
                                        .text("Write message ..."),
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (String value) {
                                    message = value;
                                  },
                                  focusNode: _focusNode,
                                  controller:
                                      TextEditingController(text: message),
                                  validator: (String value) {
                                    if (value.isEmpty ||
                                        value.trim().length == 0) {
                                      return allTranslations.currentLanguage ==
                                              "ar"
                                          ? 'برجاء عدم ترك الحقل فارغ'
                                          : "Please don't leave the field blank";
                                    }
                                  },
                                ),
//                            TextField(
//                              focusNode: _focusNode,
//                              decoration: InputDecoration(
//                                  border: InputBorder.none,
//                                  hintText: allTranslations
//                                      .text("Write message ...")),
//                            ),
                              ),
//                          Padding(
//                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
//                            child: Image.asset(
//                              "assets/icons/ic_send_button.png",
//                              width: 25,
//                              height: 25,
//                            ),
//                          ),
                              Container(
                                  child: new FlatButton(
                                      child: _isLoading == true
                                          ? new Center(
                                              child: new SizedBox(
                                                height: 20.0,
                                                width: 20.0,
                                                child:
                                                    new CircularProgressIndicator(
                                                  value: null,
                                                  backgroundColor: Colors.blue,
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              allTranslations.text("send"),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                      onPressed: submitForm))
                            ],
                          ))),
                ],
              ),
            ))));
  }
}
