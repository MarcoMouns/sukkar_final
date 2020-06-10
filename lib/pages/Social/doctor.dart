import 'package:flutter/material.dart';
import 'package:health/Models/doctor_tab/doctor_specialists.dart';
import 'package:health/Models/doctor_tab/specialists.dart';
import 'package:health/helpers/loading.dart';

import 'package:health/pages/Social/chat.dart';
import 'package:health/pages/Social/doctorProfile.dart';
import 'package:health/scoped_models/main.dart';

class Doctor extends StatefulWidget {
  final MainModel model;

  Doctor(this.model);

  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  List<SpecialistsListBean> specialists = List<SpecialistsListBean>();
  List<DataListBean> doctorSpecialists = List<DataListBean>();
  List<DoctorCvListBean> doctorCv = List<DoctorCvListBean>();
  MainModel model;
  String defaultSelect;
  int defaultSelectId;
  bool loading;
  TextEditingController editingController = TextEditingController();
  var items = List<String>();

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    super.initState();
    widget.model.fetchSpecialists().then((result) {
      if (result != null) {
        setState(() {
          specialists = result.specialists;
          defaultSelect = specialists[0].titleAr;
          defaultSelectId = specialists[0].id;
          fetchDoctorSpecialist();
          setState(() {
            loading = false;
          });
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  fetchDoctorSpecialist() {
    widget.model.fetchDoctorSpecialists(defaultSelectId).then((result) {
      if (result != null) {
        setState(() {
          doctorSpecialists = result.doctors.data;
        });
      } else {}
    });
  }

  _showBottomSheet(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Container(
                            height: MediaQuery.of(context).size.height / 1.75,
                            margin: EdgeInsets.fromLTRB(16, 20, 16, 10),
                            child: ListView.builder(
                              itemCount: specialists.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        defaultSelect =
                                            specialists[index].titleAr;
                                        defaultSelectId = specialists[index].id;
                                        fetchDoctorSpecialist();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          specialists[index].titleAr,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  149, 149, 149, 1)),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              color: Colors.grey[200],
                                              height: 20,
                                            ))
                                      ],
                                    ));
                              },
                            )),
                      )
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Loading()
        : new Scaffold(
            appBar: new PreferredSize(
                child: Container(
                    padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: MediaQuery.of(context).padding.top),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 45,
                        child: InkWell(
                            onTap: () {
                              _showBottomSheet(context);
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.grey[200],
                                            width: 2))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: new Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/icons/ic_doctor.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          defaultSelect,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                ))),
                      ),
                    ])),
                preferredSize: Size(40, 60)),
            body: ListView.builder(
                itemCount: doctorSpecialists.length,
                itemBuilder: (BuildContext context, int index) {
                  var t = int.parse(doctorSpecialists[index].rating.toString());
                  return new Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DoctorProfile(
                                    doctorSpecialists: doctorSpecialists[index],
                                    doctorCv: doctorSpecialists[index].doctorCv,
                                    rate: t,
                                    model: widget.model,
                                    userId: doctorSpecialists[index]
                                        .doctorCv[0]
                                        .userId,
                                  )));
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: doctorSpecialists[index].image ==
                                          'Null'
                                      ? NetworkImage(
                                          "https://images.vexels.com/media/users/3/151709/isolated/preview/098c4aad185294e67a3f695b3e64a2ec-doctor-avatar-icon-by-vexels.png")
                                      : NetworkImage(
                                          'http://api.sukar.co/${doctorSpecialists[index].image}'))),
                        ),
                        trailing: InkWell(
                          child: Image.asset(
                            "assets/icons/ic_message.png",
                            width: 60,
                            height: 60,
                          ),
                          onTap: () {
                            doctorSpecialists[index].doctorCv[0] == null
                                ? false
                                : Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                    return Chat(
                                        isDoctor: true,
                                        userId: doctorSpecialists[index]
                                            .doctorCv[0]
                                            .userId,
                                        model: widget.model,
                                        name: doctorSpecialists[index].name,
                                        image:
                                            '${doctorSpecialists[index].image}');
                                  }));
                          },
                        ),
                        title: Text(doctorSpecialists[index].name.toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              doctorSpecialists[index]
                                  .specialist
                                  .titleAr
                                  .toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(243, 140, 142, 1)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < t ? Icons.star : Icons.star_border,
                                  color: Colors.blue,
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 2,
                        indent: 20,
                      )
                    ],
                  );
                }));
  }
}
