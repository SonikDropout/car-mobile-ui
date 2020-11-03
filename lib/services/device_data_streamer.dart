import 'dart:async';
import './buffer_parser.dart';

import 'package:flutter_blue/flutter_blue.dart';

class DeviceDataStreamer {
  final BluetoothDevice device;
  final StreamController _streamController = StreamController.broadcast();
  BluetoothCharacteristic _characteristic;
  Timer _timer;

  DeviceDataStreamer(this.device) {
    device.state.listen((state) {
      if (state == BluetoothDeviceState.connected) {
        device.discoverServices().then((services) {
          _characteristic = services
              .firstWhere((element) =>
                  element.uuid == Guid('0000ffe0-0000-1000-8000-00805f9b34fb'))
              .characteristics
              .firstWhere((element) =>
                  element.uuid == Guid('0000ffe1-0000-1000-8000-00805f9b34fb'));
          subscribeCharacteristic();
        });
      }
    });
  }

  void subscribeCharacteristic() {
    _characteristic.setNotifyValue(true).then((value) {
      if (value) {
        _characteristic.value.listen((buffer) {
          print('read characteristic $buffer');
        });
      }
    });
  }

  Stream get dataStream => _streamController.stream;

  void dispose() {
    device.disconnect();
    _streamController.close();
    _timer.cancel();
  }
}
