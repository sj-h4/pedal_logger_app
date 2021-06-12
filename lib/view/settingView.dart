import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pedal_logger_flutter/main.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: _BuildData(),
    );
  }
}

class _BuildData extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'setting',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
