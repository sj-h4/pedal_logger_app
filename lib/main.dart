import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pedal_logger_flutter/view/dataView.dart';
import 'view/dataView.dart';
import 'view/bottom_navi_view.dart';
import 'view/timer.dart';
import 'ble/pedal_ble.dart';

//https://github.com/kazuma-fujita/flutter_bottom_navigation_bar/blob/master/lib/main.dart

final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.data);

enum TabType {
  data,
  setting,
}

final powerProvider = StateNotifierProvider<PowerViewModel, AsyncValue<int>>(
    (_) => PowerViewModel());

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

final _timeLeftProvider = Provider<String>((ref) {
  return ref.watch(timerProvider).timeLeft;
});

final timeLeftProvider = Provider<String>((ref) {
  return ref.watch(_timeLeftProvider);
});

void main() {
  runApp(ProviderScope(child: BottomNavigationBarView()));
}
