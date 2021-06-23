import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pedal_logger_flutter/main.dart';
import 'timerView.dart';

class DataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TimerTextWidget(),
              StartButton(),
              _BuildData(),
              ButtonWidget(),
            ],
          ),
        ));
  }
}

class _BuildData extends HookWidget {
  const _BuildData({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final powerState = useProvider(powerProvider);
    //final nowPower = useProvider(nowPowerProvider);
    //final averagePower = useProvider(averagePowerProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            //"$nowPower W",
            "${powerState.power}",
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            "ave: ${powerState.average} W",
            //"${aveList.reduce((a, b) => a + b) / aveList.length}",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            '${powerState.rotation} rpm',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}

class ButtonWidget extends HookWidget {
  const ButtonWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              context.read(powerProvider.notifier).startScan();
            },
            child: Text('CONNECT'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read(powerProvider.notifier).resetData();
            },
            child: Text('RESET AVERAGE'),
          ),
        ],
      ),
    );
  }
}
