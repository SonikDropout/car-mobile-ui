import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';
import './car_controller.dart';

class ScannerScreen extends StatelessWidget {
  final BleManager _bleManager = BleManager();

  Future<void> _initBleManager() {
    print("Init devices bloc");
    return _bleManager
        .createClient()
        .catchError((e) => print("Couldn't create BLE client"))
        .then((_) => _checkPermissions())
        .catchError((e) => print("Permission check error"))
        .then((_) => _waitForBluetoothPoweredOn());
  }

  Future<bool> _waitForBluetoothPoweredOn() async {
    Completer<bool> completer = Completer();
    StreamSubscription<BluetoothState> subscription;
    subscription = _bleManager
        .observeBluetoothState(emitCurrentValue: true)
        .listen((bluetoothState) async {
      if (bluetoothState == BluetoothState.POWERED_ON &&
          !completer.isCompleted) {
        await subscription.cancel();
        completer.complete(true);
        print('bluetooth powered on');
      }
    });
    return completer.future;
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        if (!(await Permission.location.request().isGranted))
          return Future.error(Exception("Location permission not granted"));
      }
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text('Searching for cars')),
        body: FutureBuilder(
          future: _initBleManager(),
          builder: (context, snapshot) {
            if (!snapshot.hasError)
              return CarList(_bleManager);
            else
              return Center(child: Text('Please turn on bluetooth'));
          },
        ));
  }
}

class CarList extends StatefulWidget {
  final BleManager _bleManager;

  CarList(this._bleManager);
  @override
  _CarList createState() => _CarList(_bleManager);
}

class _CarList extends State<CarList> {
  final List<ScanResult> cars = [];
  final BleManager _bleManager;
  StreamSubscription _carScannerSubscription;

  _CarList(this._bleManager);

  @override
  void initState() {
    super.initState();
    _carScannerSubscription = _bleManager.startPeripheralScan(uuids: [
      '0000ffe0-0000-1000-8000-00805f9b34fb'
    ]).listen((ScanResult scanResult) {
      if (!cars.contains(scanResult))
        setState(() {
          cars.add(scanResult);
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _carScannerSubscription.cancel();
    _bleManager.stopPeripheralScan();
  }

  @override
  Widget build(context) {
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
            title: Text(cars[index].advertisementData.localName),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CarController()))));
  }
}
