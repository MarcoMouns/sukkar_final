import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:health/api_provider.dart';
import 'package:flutter_picker_view/flutter_picker_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'DocInfo_screen.dart';
import 'api_provider.dart';
import 'chat.dart';
import 'const.dart';
import 'doctor_chat_model.dart';
import 'shared-data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DoctorChatScreen extends StatefulWidget {
  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  bool arrowFlip = false;
  bool isLoading=true;
  int specialityId = 0;
  int indexSpeciality =0;
  double starRating=3;
  String specialityName = "عيون";
  List<SpecialityDoc> _specoalists = List<SpecialityDoc>();
  bool isDoctor = false;

  Future getData() async {
    var document = await Firestore.instance
        .document('users/${SharedData.customerData['fuid']}');
    document.get().then((document) {
      isDoctor = document['isDoctor'];
      setState(() {});
    });
  }

  _initData() async {
    _specoalists = await ApiProvider().getSpecialists();
    if (mounted) setState(() {});
    print('1111111111111111111==========>${_specoalists[1].titleEn}');
    isLoading=false;
    specialityId=_specoalists[0].id;
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _initData();
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if(isDoctor){
      if (document['id'] == SharedData.customerData['fuid'] ||
          document['isDoctor'] == isDoctor) {
        return Container();
      } else {
        return Column(
          children: <Widget>[
            Container(
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 15),
                            child:  Material(
                              child: document['photoUrl'] != null
                                  ? CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                imageUrl:
                                'http://api.sukar.co${document['photoUrl']}',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              )
                                  : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: greyColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Container(
                              child: Text(
                                '${document['nickname']}',
                                style: TextStyle(color: primaryColor, height: 0),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/icons/ic_message.png',
                          scale: 2.5,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            peerId: document.documentID,
                            peerAvatar: document['photoUrl'],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                color: greyColor2,
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Divider(),
            )
          ],
        );
      }
    }
    else{
      if (document['id'] == SharedData.customerData['fuid'] ||
          document['isDoctor'] == isDoctor ||
          document['specialistId'] != specialityId) {
        return Container();
      } else {
        return Column(
          children: <Widget>[
            Container(
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 15),
                            child:  Material(
                              child: document['photoUrl'] != null
                                  ? CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                imageUrl:
                                'http://api.sukar.co${document['photoUrl']}',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              )
                                  : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: greyColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${document['nickname']}',
                                      style: TextStyle(color: primaryColor, height: 0),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    "${_specoalists[indexSpeciality].titleAr}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  RatingBar(
                                    initialRating: starRating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DocInfo(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                          dId: document['dId'],
                        ),
                        ));
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/icons/ic_message.png',
                          scale: 2.5,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            peerId: document.documentID,
                            peerAvatar: document['photoUrl'],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                color: greyColor2,
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Divider(),
            )

          ],
        );
      }
    }
  }

  void DropDownMenu() {
    arrowFlip = true;
    setState(() {});
    PickerController pickerController = PickerController(count: 1);
    PickerViewPopup.showMode(
        PickerShowMode.BottomSheet, // AlertDialog or BottomSheet
        controller: pickerController,
        context: context,
        title: Text(
          'التخصص',
          style: TextStyle(fontSize: 14),
        ),
        cancel: Text(
          'cancel',
          style: TextStyle(color: Colors.grey),
        ),
        onCancel: () {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('AlertDialogPicker.cancel')));
        },
        confirm: Text(
          'confirm',
          style: TextStyle(color: Colors.blue),
        ),
        onConfirm: (controller) {
          List<int> selectedItems = [];
          selectedItems.add(controller.selectedRowAt(section: 0));

          indexSpeciality = selectedItems.first;
          specialityId = _specoalists[indexSpeciality].id;
          specialityName = _specoalists[selectedItems.first].titleAr;
          print('**********************=>speciality-Id=$specialityId');
          arrowFlip = false;
          setState(() {});
        },
        builder: (context, popup) {
          return Container(
            height: 200,
            child: popup,
          );
        },
        itemExtent: 40,
        numberofRowsAtSection: (section) {
          return _specoalists.length;
        },
        itemBuilder: (section, row) {

          return Text(
            '${_specoalists[row].titleAr}',
            style: TextStyle(fontSize: 12),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading?
      Center(
        child: SpinKitWave(
          size: 30,
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.blue : Colors.white,
              ),
            );
          },
        ),
      ):
      Column(
        children: <Widget>[
          isDoctor == true
              ? Container()
              : Directionality(
            textDirection: TextDirection.ltr,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: RotatedBox(
                        quarterTurns: arrowFlip ? 90 : 0,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        children: <Widget>[
                          Text("$specialityName"),
                          Padding(padding: EdgeInsets.only(right: 8)),
                          Image.asset('assets/icons/ic_doctor.png',scale: 4,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => DropDownMenu(),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

