import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedal_logger_flutter/main.dart';

class TimerTextWidget extends HookWidget {
  const TimerTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeLeft = useProvider(timeLeftProvider);
    print('building TimerTextWidget $timeLeft');
    return Text(
      timeLeft,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).start();
      },
      child: Icon(Icons.play_arrow),
    );
  }
}
