import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pedal_logger_flutter/main.dart';
import 'package:pedal_logger_flutter/ble/pedal_ble.dart';

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
  const _BuildData({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final power = useProvider(powerProvider);
    final aveList = useProvider(averageNotifer);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          power.maybeWhen(error: (e, stateTrace) {
            return Text(e.toString());
          }, orElse: () {
            final data = power.data?.value;
            return Text(
              "$data",
              style: Theme.of(context).textTheme.headline4,
            );
          }),
          Text(
            "${aveList.reduce((a, b) => a + b) / aveList.length}",
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton(
            onPressed: () {
              context.read(powerProvider.notifier);
            },
            child: Text('CONNECT'),
          )
        ],
      ),
    );
  }
}
