import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:pedal_logger_flutter/main.dart';

class PowerViewModel extends StateNotifier<int> {
  PowerViewModel() : super(0);
  void update(int num) {
    state = num;
  }

  final String deviceName = "V3 BLE:0442838";
  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic bleCharactaristic;

  final String serviceUUID = "00001818-0000-1000-8000-00805f9b34fb";
  final String charactaristicUUID = "00002a63-0000-1000-8000-00805f9b34fb";

  // デバイスと接続済みか
  bool isConnected = false;

  String deviceStatus = "No Device";

  final power = useProvider(powerProvider);

  void _startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    print("deviceStatus: connecting");
    if (isConnected) {
      disconnectDevice();
      return;
    }

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print(r.device.name);
        if (r.device.name == deviceName) {
          isConnected = true;
          targetDevice = r.device;
          connectToDevice();
          flutterBlue.stopScan();
          break;
        }
      }
    }, onDone: () => flutterBlue.stopScan());

    // Stop scanning
    flutterBlue.stopScan();
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

  void recieveNotification() async {
    if (targetDevice == null) return;
    await bleCharactaristic?.setNotifyValue(true);
    bleCharactaristic?.value?.listen((value) async {
      state = value[3] * 256 + value[2];
    });
  }
}

class DataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
      ),
      body: _BuildData(),
    );
  }
}

class _BuildData extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final power = useProvider(powerProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$power',
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton(
            onPressed: () {
              context.read(powerProvider.notifier)._startScan();
            },
            child: Text('CONNECT'),
          )
        ],
      ),
    );
  }
}
