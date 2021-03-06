import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/bluetooth/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

import '../Settings.dart';
import '../home.dart';

class BlueToothDevice extends StatefulWidget {
  @override
  _BlueToothDeviceState createState() => _BlueToothDeviceState();
}

class _BlueToothDeviceState extends State<BlueToothDevice> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;
  String resultTime = "";
  String resultData = "";
  String resultTestKind = "";
  String resultUnitType = "";
  int finalMeasure = 0;
  //Uint8List Liste = [  0x68,  0x02,  0x51,  0x53, 0x00 ];

  //  List<int> sampleData = [104,56,161, 0,138,19,5,25,10,46,29,162,2,141,136,194,85,159,224,123];
  // Blood Glucose=[104, 56, 161, 0, 138, 19, 5, 25, 10, 46, 29, 162, 2, 141, 136, 194, 85, 159, 224, 123];
  //TotalCholesterol=[104, 56, 161, 0, 89, 19, 5, 25, 14, 56, 50, 164, 2, 129, 136, 194, 85, 159, 224, 123]

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  Response response;
  Dio dio = new Dio();

  Future<Response> addNewMeasurement(var suger, BuildContext context) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      var now = new DateTime.now();
      var date =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      var formatter = new intl.DateFormat('hh:mm a');
      String formatted = formatter.format(now);
      await dio.post(
          "${Settings.baseApilink}/measurements/sugar?sugar=$suger&date=$date&time=$formatted",
          options: Options(headers: headers));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainHome()));
      _ackAlert(context);
    } catch (e) {
      //print("error =====================");
    }

    return response;
  }

  Future<void> _ackAlert(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: allTranslations.currentLanguage == "ar"
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: AlertDialog(
            title: Text(
              "${allTranslations.text("sugerDialogTitle")} $finalMeasure",
              textAlign: TextAlign.center,
            ),
            content: finalMeasure >= 70 && finalMeasure < 90
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            allTranslations.text("low1SugermgsTitle"),
                            style: TextStyle(
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(allTranslations.text("low1Sugermgsbody")),
                        ],
                      ),
                    ),
                  )
                : finalMeasure >= 90 && finalMeasure <= 200
                    ? Text(
                        allTranslations.text("normalSugermsg"),
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      )
                    : finalMeasure > 200
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.27,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    allTranslations.text("highSugermsgTitle"),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Text(allTranslations.text("highSugerBody")),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    allTranslations.text("lowSugermsgTitle"),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Text(allTranslations.text("lowSugermsgbody")),
                                ],
                              ),
                            ),
                          ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  allTranslations.text("ok"),
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  finalMeasure = 0;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.listen((s) {
      setState(() {
        state = s;
      });
      print('State init: $state');
    });

    // Subscribe to state changes
    _stateSubscription = _flutterBlue.state.listen((s) {
      setState(() {
        state = s;
      });
      print('State updated: $state');
    });
    //_startScan();
  }

  @override
//  void dispose() {
//    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
//    valueChangedSubscriptions.clear();
//    _stateSubscription?.cancel();
//    _stateSubscription = null;
//    _scanSubscription?.cancel();
//    _scanSubscription = null;
//    deviceConnection?.cancel();
//     deviceConnection = null;
//    setState(() {
//      device.disconnect();
//    });
//    super.dispose();
//  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 2),
//      withServices: [
//             new Guid('0000ffe4-0000-1000-8000-00805f9b34fb')
//           ]
    )
        .listen((scanResult) {
      // print('localName: ${scanResult.advertisementData.localName}');
      // print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      //print('serviceData: ${scanResult.advertisementData.serviceData}');
      if (scanResult.device.name == "LBM-1") {
        if (mounted)
          setState(() {
            scanResults[scanResult.device.id] = scanResult;
          });
      }
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    await device.connect(
      timeout: Duration(seconds: 4),
    );

    deviceConnection = _flutterBlue.state.listen((state) async {
      // Update the connection state immediately
      device.state.listen((s) {
        if (mounted)
          setState(() {
            deviceState = s;
          });
      });
      // Subscribe to connection changes
      deviceStateSubscription = device.state.listen(
        (s) {
          if (mounted)
            setState(() {
              deviceState = s;
            });
          if (s == BluetoothDeviceState.connected) {
            device.discoverServices().then((s) {
              var bservice = s
                  .where((r) => r.uuid
                      .toString()
                      .toLowerCase()
                      .contains("0000ffe0-0000-1000-8000-00805f9b34fb"))
                  .first;
              if (bservice != null) {
                var char = bservice.characteristics
                    .where((c) => c.uuid
                        .toString()
                        .toLowerCase()
                        .contains("0000ffe4-0000-1000-8000-00805f9b34fb"))
                    .first;
                if (char != null) {
                  _setNotification(char);
                }
              }
              bservice = s
                  .where((r) => r.uuid
                      .toString()
                      .toLowerCase()
                      .contains("00001808-0000-1000-8000-00805f9b34fb"))
                  .first;
              if (bservice != null) {
                var char = bservice.characteristics
                    .where((c) => c.uuid
                        .toString()
                        .toLowerCase()
                        .contains("00002a18-0000-1000-8000-00805f9b34fb"))
                    .first;
                if (char != null) {
                  _setNotification(char);
                }
              }

              setState(() {
                //Accu-Answer isaw Service UUID="0000ffe0-0000-1000-8000-00805f9b34fb"
                //Accu-Answer isaw Characteristics UUID="0000ffe4-0000-1000-8000-00805f9b34fb"
                //YASEE Service UUID="00001808-0000-1000-8000-00805f9b34fb"
                //YASEE Characteristics UUID="00002a18-0000-1000-8000-00805f9b34fb"

                //var bservice =s.where((r) =>r.uuid.toString().toLowerCase().contains("0000ffe0-0000-1000-8000-00805f9b34fb")).first;//Accu-Answer
                // var bservice=s.where((r) =>r.uuid.toString().toLowerCase().contains("00001808-0000-1000-8000-00805f9b34fb")).first;//YASEE
                for (int i = 0; i < s.length; i++) {
                  var bservice = s[i];
                  var tmpUUID = bservice.uuid.toString().toLowerCase();

                  if (tmpUUID == "0000ffe0-0000-1000-8000-00805f9b34fb") {
                    var char = bservice.characteristics
                        .where((c) => c.uuid
                            .toString()
                            .toLowerCase()
                            .contains("0000ffe4-0000-1000-8000-00805f9b34fb"))
                        .first;
                    if (char != null) {
                      _setNotification(char);
                    }
                    break;
                  } else if (tmpUUID ==
                      "00001808-0000-1000-8000-00805f9b34fb") {
                    var char = bservice.characteristics
                        .where((c) => c.uuid
                            .toString()
                            .toLowerCase()
                            .contains("00002a18-0000-1000-8000-00805f9b34fb"))
                        .first;
                    if (char != null) {
                      _setNotification(char);
                    }
                    break;
                  }
                }
                //services = s;
                //if (mounted) setState(() {});
              });
            });
          }
        },
        onDone: _disconnect,
      );
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device.disconnect();
    });
  }

  _setNotification(BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    // ignore: cancel_subscriptions
    final sub = c.value.listen((d) async {
      if (d.length == 20 && d[0] == 104 && d[2] == 161) {
        if (mounted)
          setState(() {
            // Update Backend
            var res = checkReceiveData(d);
            print('onValueChanged $d res:$res');
          });
        if (finalMeasure > 0) {
          _disconnect();
          addNewMeasurement(finalMeasure, context);
        }
      }
    });
    // Add to map
    valueChangedSubscriptions[c.uuid] = sub;

    if (mounted) setState(() {});
  }

  //checkReceiveData ACCU-ANSWER Device
  int checkReceiveData(List<int> reciveData) {
    //Blood Glucose=   [104, 56, 161, 0, 138, 19, 5, 25, 10, 46, 29, 162, 2, 141, 136, 194, 85, 159, 224, 123];
    //URICACID=        [104, 56, 161, 0,  44, 19, 5, 25, 15,  3, 16, 163, 2, 253, 136, 194, 85, 159, 224, 123]
    //TotalCholesterol=[104, 56, 161, 0,  89, 19, 5, 25, 14, 56, 50, 164, 2, 129, 136, 194, 85, 159, 224, 123]
    //[0]=startChar >104
    //[1]=56 dataLen
    //[2]=cmdChar >161
    //[3]=0?
    //[4]=138 نتيجة القياس
    //[5]=19السنة
    //[6]=5 الشهر
    //[7]=25 اليوم
    //[8]=10 الساعة
    //[9]=46 الدقيقة
    //[10]=29 الثانية
    //[11]=162 نوع القياس
    //0xA1(161):Urine Glucose,0xA2(162):Blood Glucose,0xA3(163):Uric Acid,0xA4(164):Total Cholesterol
    //[12]=2
    //[13]=141
    //[14]=136
    //[15]=194
    //[16]=85
    //[17]=159
    //[18]=224
    //[19]=123

    int startChar = 104; //LATIN SMALL LETTER h
    int dataLen = 0;
    int cmdChar = 161; //INVERTED EXCLAMATION MARK !
    int chkSum = 0;
    int dataType =
        0; //0xA1(161):Urine Glucose,0xA2(162):Blood Glucose,0xA3(163):Uric Acid,0xA4(164):Total Cholesterol
    double tmpVal = 0.0;
    int tmpIVal = 0;
    String data = "";
    String time = "";
    String typeStr = "";
    String units = "mg/dL";
    String dataTypeStr = "";
    if (reciveData == null) {
      return 0;
    }
    int i = reciveData.length;
    if ((i < 4) || (i > 100)) {
      return 0;
    }
    if (reciveData[0] != startChar) {
      return 0;
    }
    dataLen = (reciveData[1]);
    if (dataLen == 2) {
      int d2 = (reciveData[2]);
      int d3 = (reciveData[3]);
      if ((d2 == 162) && (d3 == 164)) {
        return 1;
      } else {
        return 0;
      }
    }
    if (dataLen == 56) {
      //LINE TABULATION
      cmdChar = (reciveData[2]);
      //0xA1(161):Urine Glucose,0xA2(162):Blood Glucose,0xA3(163):Uric Acid,0xA4(164):Total Cholesterol
      dataType = (reciveData[11]);
      chkSum = (reciveData[12]); //2

      if (cmdChar != 161) {
        return 0;
      }

      int tmpYear = 0;
      int tmpMonth = 0;
      int tmpDay = 0;
      int tmpHour = 0;
      int tmpMin = 0;
      int tmpsec = 0;
      int tmpHVal = 0;
      int tmpLval = 0;
      tmpVal = 0;
      tmpIVal = 0;
      tmpYear = (reciveData[5]); //السنة
      tmpMonth = (reciveData[6]); //الشهر
      tmpDay = (reciveData[7]); //اليوم
      tmpHour = (reciveData[8]); //الساعة
      tmpMin = (reciveData[9]); //الدقيقة
      tmpsec = (reciveData[10]); //الثانية
      tmpHVal = (reciveData[13]); //العالي141
      tmpLval = (reciveData[4]); //المنخفض138
      tmpVal = (((tmpHVal.toDouble()) + (tmpLval.toDouble() / 256.0)) /
          100.0); //القياس عالي وال مرتفع

      tmpIVal = tmpLval; //((tmpHVal * 256) + tmpLval);//القياس عالي وال مرتفع
      tmpYear += 2000;
      time = ((((tmpYear.toString() + "-") + tmpMonth.toString()) + "-") +
          tmpDay.toString() +
          " ");
      if (tmpHour < 10) {
        time = (time + "0");
      }
      time = ((time + tmpHour.toString()) + ":");
      if (tmpMin < 10) {
        time = (time + "0");
      }
      time = ((time + tmpMin.toString()) + ":");
      if (tmpsec < 10) {
        time = (time + "0");
      }
      time = (time + tmpsec.toString());
      dataTypeStr = "";
      if (dataType == 161) {
        dataTypeStr = "Urine Glucose";
        typeStr = "2";
      } else {
        if (dataType == 162) {
          dataTypeStr = "Blood Glucose";
          typeStr = "1";
        } else {
          if (dataType == 163) {
            dataTypeStr = "Uric Acid";
            typeStr = "3";
          } else {
            if (dataType == 164) {
              dataTypeStr = "Total Cholesterol";
              typeStr = "4";
            } else {
              dataTypeStr = " ";
            }
          }
        }
      }
      data = "";
      if (typeStr == "3") {
        //Uric Acid
        if (tmpVal <= 1.48) {
          data = tmpVal.toString() + " " + units.toLowerCase() + " Lo";
        } else {
          if (tmpVal >= 19.809) {
            data = tmpVal.toString() + " " + units.toLowerCase() + " Hi";
          } else {
            data = tmpVal.toString() + " " + units.toLowerCase() + " Normal";
          }
        }
      } else {
        if (typeStr == "1") {
          //Blood Glucose
          if (tmpIVal <= 20) {
            data = tmpIVal.toString() + " " + units.toLowerCase() + " Lo";
          } else {
            if (tmpIVal >= 600) {
              data = tmpIVal.toString() + " " + units.toLowerCase() + " Hi";
            } else {
              data = tmpIVal.toString() + " " + units.toLowerCase() + " Normal";
            }
          }
        } else {
          if (typeStr == "4") {
            //Total Cholesterol
            if (tmpIVal <= 103) {
              data = tmpIVal.toString() + " " + units.toLowerCase() + " Lo";
            } else {
              if (tmpIVal >= 413) {
                data = tmpIVal.toString() + " " + units.toLowerCase() + " Hi";
              } else {
                data =
                    tmpIVal.toString() + " " + units.toLowerCase() + " Normal";
              }
            }
          } else {
            data = tmpIVal.toString();
          }
        }
      }
      if (data.length >= 0) {
        resultTime = time;
        resultData = data; // Lo Or Hi
        resultTestKind =
            dataTypeStr; //Urine Glucose OR Blood Glucose OR Uric Acid OR Total Cholesterol
        resultUnitType = units.toLowerCase(); //mg/dL
        finalMeasure = tmpIVal;

        setState(() {});
      }
      setState(() {});
      return 2;
    }

    return 0;
  }

  _refreshDeviceState(BluetoothDevice d) {
    device = d;
    device.state.listen((s) {
      if (mounted)
        setState(() {
          deviceState = s;
          print('State refreshed: $deviceState');
        });
    });
  }

  _buildScanningButton() {
    if (isConnected || state != BluetoothState.on) {
      return null;
    }
    if (isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: _stopScan,
        backgroundColor: Colors.red,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: _startScan);
    }
  }

  _buildScanResultTiles() {
    setState(() {});
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
              onTap: () => _connect(r.device),
            ))
        .toList();
  }

//  _buildActionButtons() {
//    if (isConnected) {
//      return <Widget>[
//        new IconButton(
//          icon: const Icon(Icons.cancel),
//          onPressed: () {
//            _disconnect();
//            if (finalMeasure > 0) {
//              addNewMeasurement(finalMeasure, context);
//            }
//          },
//        )
//      ];
//    }
//  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          // ignore: deprecated_member_use
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          // ignore: deprecated_member_use
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildDeviceStateTile() {
    return new ListTile(
      leading: (deviceState == BluetoothDeviceState.connected)
          ? const Icon(Icons.bluetooth_connected)
          : const Icon(Icons.bluetooth_disabled),
      // title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),

      title: new Text(
        (deviceState.toString().split('.')[1] == "connected")
            ? allTranslations.text("glucose meter connected")
            : allTranslations.text("glucose meter disconnected"),
        style: (deviceState.toString().split('.')[1] == "connected")
            ? TextStyle(color: Colors.green, fontSize: 25)
            : TextStyle(color: Colors.red, fontSize: 25),
        textDirection: allTranslations.currentLanguage == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
      ),
      //subtitle: new Text('${device.id}'),
      trailing: new IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => _refreshDeviceState(device),
        color: Theme.of(context).iconTheme.color.withOpacity(0.5),
      ),
    );
  }

  _buildDeviceReadDataTile() {
    return new ListTile(
      title: new Text(resultTestKind + " " + resultData),
      subtitle: new Text(resultTime),
    );
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    if (isConnected) {
      tiles.add(_buildDeviceStateTile());
      tiles.add(_buildDeviceReadDataTile());
    } else {
      tiles.addAll(_buildScanResultTiles());
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Directionality(
      textDirection: TextDirection.ltr,
      child: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              if (finalMeasure > 0) {
                addNewMeasurement(finalMeasure, context);
                _disconnect();
              } else if (deviceState.toString() ==
                  "BluetoothDeviceState.connected") {
                _disconnect();
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: isConnected
              ? Text(allTranslations.text("Add test strip"))
              : Text(allTranslations.text("Add glucose meter")),
          centerTitle: true,
          // actions: _buildActionButtons(),
        ),
        floatingActionButton:
            _buildScanningButton(), //_buildTestReadingButton(),
        body: new Stack(
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),
            new ListView(
              children: tiles,
            )
          ],
        ),
      ),
    );
  }
}
