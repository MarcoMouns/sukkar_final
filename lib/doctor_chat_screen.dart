import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:health/api_provider.dart';
import 'package:flutter_picker_view/flutter_picker_view.dart';

import 'api_provider.dart';
import 'chat.dart';
import 'const.dart';
import 'doctor_chat_model.dart';
import 'shared-data.dart';

class DoctorChatScreen extends StatefulWidget {
  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
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
  }

  @override
  void initState() {
    super.initState();
    getData();
    _initData();
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == SharedData.customerData['fuid'] ||
        document['isDoctor'] == isDoctor) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
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
                            'http://104.248.168.117${document['photoUrl']}',
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
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              PickerController pickerController =
                  PickerController(count: 1);
              PickerViewPopup.showMode(
                  PickerShowMode.BottomSheet, // AlertDialog or BottomSheet
                  controller: pickerController,
                  context: context,
                  title: Text(
                    'AlertDialogPicker',
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
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text('AlertDialogPicker.selected:$selectedItems')));
                  },
                  builder: (context, popup) {
                    return Container(
                      height: 150,
                      child: popup,
                    );
                  },
                  itemExtent: 40,
                  numberofRowsAtSection: (section) {
                    return _specoalists.length;
                  },
                  itemBuilder: (section, row) {
                    return Text(
                      '${_specoalists[row].titleEn}',
                      style: TextStyle(fontSize: 12),
                    );
                  });
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
