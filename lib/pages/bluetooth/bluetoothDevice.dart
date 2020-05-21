import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
    } catch (e) {
      print("error =====================");
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
             new Guid('0000ffe4-0000-1000-8000-00805f9b34fb')
           ]*/
    )
        .listen((scanResult) {
      print('localName: ${scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${scanResult.advertisementData.serviceData}');
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
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
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
          null,
          onDone: _disconnect,
        );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
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

            // var bservice=s.where((r) =>r.uuid.toString().toLowerCase().contains("0000ffe0-0000-1000-8000-00805f9b34fb")).first;//Accu-Answer
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
              } else if (tmpUUID == "00001808-0000-1000-8000-00805f9b34fb") {
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
          });
        });
      }
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
      device = null;
    });
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
//      valueChangedSubscriptions[c.uuid]?.cancel();
//      valueChangedSubscriptions.remove(c.uuid);
      return;
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) async {
        if (d.length == 20 && d[0] == 104 && d[2] == 161) {
          setState(() {
            // Update Backend
            var res = checkReceiveData(d);
            print('onValueChanged $d res:$res');
          });
        } else if (d.length == 15) {
          var res = checkReceiveDataYASEE(d);
          print('onValueChanged $d res:$res');
        }
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
    setState(() {});
  }

  //checkReceiveData YASEE Device
  int checkReceiveDataYASEE(List<int> reciveData) {
    //[71, 0, 0, 227, 7, 5, 25, 16, 38, 0, 0, 0, 240, 96, 17]
    double tmpVal = 0.0;
    int tmpIVal = 0;
    String data = "";
    String time = "";
    String units = "mg/dL";

    if (reciveData.length == 15) {
      int tmpYear = 0;
      int tmpMonth = 0;
      int tmpDay = 0;
      int tmpHour = 0;
      int tmpMin = 0;
      int tmpsec = 0;

      tmpVal = reciveData[13] * 0.1 * 18.0;
      tmpIVal = tmpVal.round();

      tmpYear = (reciveData[3]) + 1792; //السنة
      tmpMonth = (reciveData[5]); //الشهر
      tmpDay = (reciveData[6]); //اليوم
      tmpHour = (reciveData[7]); //الساعة
      tmpMin = (reciveData[8]); //الدقيقة
      tmpsec = (reciveData[9]); //الثانية

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

      //Blood Glucose
      data = "";
      if (tmpIVal <= 20) {
        data = tmpIVal.toString() + " " + units.toLowerCase() + " Lo";
      } else {
        if (tmpIVal >= 600) {
          data = tmpIVal.toString() + " " + units.toLowerCase() + " Hi";
        } else {
          data = tmpIVal.toString() + " " + units.toLowerCase() + " Normal";
        }
      }

      if (data.length > 0) {
        resultTime = time;
        resultData = data;
        resultTestKind =
            "Blood Glucose"; //Urine Glucose OR Blood Glucose OR Uric Acid OR Total Cholesterol
        resultUnitType = units.toLowerCase();

        setState(() {});
      }
      setState(() {});
      return 2;
    } else {
      return 0;
    }
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
      if (data.length > 0) {
        resultTime = time;
        resultData = data; // Lo Or Hi
        resultTestKind = dataTypeStr; //Urine Glucose OR Blood Glucose OR Uric Acid OR Total Cholesterol
        resultUnitType = units.toLowerCase(); //mg/dL
        addNewMeasurement(tmpIVal, context);

        setState(() {});
      }
      setState(() {});
      return 2;
    }
    return 0;
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      print('State refreshed: $deviceState');
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
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
              onTap: () => _connect(r.device),
            ))
        .toList();
  }

  _buildActionButtons() {
    if (isConnected) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => _disconnect(),
        )
      ];
    }
  }

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
              ? "glucose meter connected"
              : "glucose meter disconnected",
          style: (deviceState.toString().split('.')[1] == "connected")
              ? TextStyle(color: Colors.green)
              : TextStyle(color: Colors.red),
        ),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
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
              Navigator.pop(context);
            },
          ),
          title: Text("Add glucose meter"),
          centerTitle: true,
          actions: _buildActionButtons(),
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
