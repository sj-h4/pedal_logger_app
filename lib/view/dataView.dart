import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pedal_logger_flutter/main.dart';
import 'package:pedal_logger_flutter/ble/pedal_ble.dart';

class PowerViewModel extends StateNotifier<AsyncValue<int>> {
  PowerViewModel() : super(const AsyncValue.loading());

  final PedalBle pedalBle = PedalBle();

  Future<void> getPower() async {
    state = const AsyncValue.loading();
    try {
      final power = await pedalBle.recieveNotification();
      state = AsyncValue.data(power);
    } catch (e) {
      state = AsyncValue.error(e);
    }
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
  const _BuildData({Key key}) : super(key: key);
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
              context.read(powerProvider.notifier).getPower();
            },
            child: Text('CONNECT'),
          )
        ],
      ),
    );
  }
}
