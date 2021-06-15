import 'package:flutter_blue/flutter_blue.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pedal_logger_flutter/main.dart';

class PowerViewModel extends StateNotifier<PedalState> {
  PowerViewModel() : super(PedalState(power: 0, powerList: [], average: "0"));
  final String deviceName = "V3 BLE:0442838";
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic bleCharactaristic;

  final String serviceUUID = "00001818-0000-1000-8000-00805f9b34fb";
  final String charactaristicUUID = "00002a63-0000-1000-8000-00805f9b34fb";

  // デバイスと接続済みか
  bool isConnected = false;

  String deviceStatus = "No Device";

  int power = 0;

  void startScan() {
    flutterBlue.startScan();
    print("deviceStatus: connecting");
    if (isConnected) {
      disconnectDevice();
      return;
    }

    // Listen to scan results
    flutterBlue.scanResults.listen(
      (results) {
        // do something with scan results
        for (ScanResult r in results) {
          print(r.device.name);
          if (r.device.name == deviceName && !isConnected) {
            isConnected = true;
            targetDevice = r.device;
            connectToDevice();
            flutterBlue.stopScan();
            break;
          }
        }
      },
    );
  }

  void connectToDevice() async {
    if (targetDevice == null) return;

    await targetDevice.connect();
    /*
    setState(() {
      deviceStatus = "Connected: ${targetDevice.name}";
      print('connected');
    });
    */
    targetDevice.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });
    discoverServices();
  }

  void disconnectDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    isConnected = false;
/*
    setState(() {
      deviceStatus = "disconnected";
    });
*/
  }

  void discoverServices() async {
    if (targetDevice == null) return;
    print("discovering");
    targetDevice.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });

    List<BluetoothService> services = await targetDevice?.discoverServices();
    services.forEach((element) {
      print("service UUID: $element.uuid.toString");
      if (element.uuid.toString() == serviceUUID) {
        element.characteristics.forEach((charactaristic) {
          print("cahractaristic UUID: $charactaristic.uuid.toString()");

          if (charactaristic.uuid.toString() == charactaristicUUID) {
            bleCharactaristic = charactaristic;
            recieveNotification();
          } else {
            print("cannot");
          }

          print("connected service");
        });
      }
    });
  }

  Future<void> recieveNotification() async {
    if (targetDevice == null) return 0;
    await bleCharactaristic?.setNotifyValue(true);
    bleCharactaristic?.value?.listen((value) async {
      power = value[3] * 256 + value[2];
      print("$power");
      state.power = power;
      state.powerList.add(power);

      double ave =
          state.powerList.reduce((a, b) => a + b) / state.powerList.length;
      state.average = ave.toStringAsFixed(1);
/*
      state = const AsyncValue.loading();
      try {
        state = AsyncValue.data(power);
      } on Exception catch (e) {
        state = AsyncValue.error(e);
      } */
    });
  }
}

class PedalState {
  PedalState({this.power, this.powerList, this.average});
  int power;
  List<int> powerList;
  String average;
}
