import 'package:flutter_blue/flutter_blue.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

import 'package:pedal_logger_flutter/main.dart';

// ペダルとの接続とペダルのデータを管理するクラス
class PowerViewModel extends StateNotifier<PedalState> {
  PowerViewModel()
      : super(PedalState(
            power: 0,
            powerList: [],
            rotation: "0.0",
            rotationList: [],
            average: "0"));
  final String deviceName = "V3 BLE:0442838";
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic bleCharactaristic;

  final String serviceUUID = "00001818-0000-1000-8000-00805f9b34fb";
  final String charactaristicUUID = "00002a63-0000-1000-8000-00805f9b34fb";

  // デバイスと接続済みか
  bool isConnected = false;

  StreamSubscription<List<int>> _powerSubscription;

  String deviceStatus = "No Device";

  int power = 0;
  double rotation = 0;

  int prevRev = 0;
  int prevTime = 0;

  // BLEデバイスを探す関数
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

  // BLEデバイスと接続する関数
  void connectToDevice() async {
    if (targetDevice == null) return;

    await targetDevice.connect();
    targetDevice.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });
    discoverServices();
  }

  // BLEデバイスを切断する関数
  void disconnectDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    isConnected = false;
  }

  // BLEデバイスのserviceと接続する関数
  void discoverServices() async {
    if (targetDevice == null) return;
    print("discovering");
    targetDevice.isDiscoveringServices.forEach((element) {
      print("is discovering $element");
    });

    List<BluetoothService> services = await targetDevice?.discoverServices();

    // 指定したserviceがあれば接続
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

  // bleの値の更新を受け取る関数
  Future<void> recieveNotification() async {
    if (targetDevice == null) return 0;
    _powerSubscription?.cancel();
    await bleCharactaristic?.setNotifyValue(true);

    // 以下に各bitが何を指してるかが書いてある
    // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.cycling_power_measurement.xml
    _powerSubscription = bleCharactaristic?.value?.listen((value) async {
      power = value[3] * 256 + value[2];
      print("$power");
      state.power = power;
      state.powerList.add(power);

      double ave =
          state.powerList.reduce((a, b) => a + b) / state.powerList.length;
      state.average = ave.toStringAsFixed(1);

      // timeは 1/1024 された値が送られてくることに注意
      int rev = value[6] * 256 + value[5];
      int time = value[8] * 256 + value[7];
      print("rev: $rev \n time: $time");

      int dr = rev - prevRev;
      int dt = time - prevTime;
      print("drev: $dr \n dtime: $dt");

      if (dt != 0) {
        rotation = dr * 1024 * 60 / dt;
        state.rotationList.add(rotation);
        state.rotation = rotation.toStringAsFixed(1);
      }

      prevRev = rev;
      prevTime = time;
      state = PedalState(
          power: power,
          powerList: state.powerList,
          rotation: state.rotation,
          rotationList: state.rotationList,
          average: ave.toStringAsFixed(1));
    });

    _powerSubscription?.onDone(() {
      state = PedalState(
          power: state.power,
          powerList: state.powerList,
          rotation: state.rotation,
          rotationList: state.rotationList,
          average: state.average);
    });
  }

  // パワーと回転数のデータをリセットする関数
  void resetData() {
    state.powerList.clear();
    state.rotationList.clear();

    state = PedalState(
        power: state.power,
        powerList: state.powerList,
        rotation: state.rotation,
        rotationList: state.rotationList,
        average: state.average);
  }
}

class PedalState {
  PedalState(
      {this.power,
      this.powerList,
      this.rotation,
      this.rotationList,
      this.average});
  int power;
  List<int> powerList; // powerの値の保管用
  String rotation;
  List<double> rotationList; // rotaionの値の保管用
  String average; // パワーの平均値
}
