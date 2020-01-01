import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepsCounter extends StatefulWidget {
  @override
  _StepsCounterState createState() => _StepsCounterState();
}

class _StepsCounterState extends State<StepsCounter> {
  static Pedometer _pedometer;
  static StreamSubscription<int> _subscription;
  static String _stepCountValue = '0';

  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int stepCountValue) async {
    setState(() => _stepCountValue = "$stepCountValue");
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$_stepCountValue'),
    );
  }
}
