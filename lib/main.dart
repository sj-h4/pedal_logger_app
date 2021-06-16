import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final powerProvider =
    StateNotifierProvider<PowerViewModel, PedalState>((_) => PowerViewModel());
final _nowPowerProvider = Provider<int>((ref) {
  return ref.watch(powerProvider).power;
});
final nowPowerProvider = Provider<int>((ref) {
  return ref.watch(_nowPowerProvider);
});
final _averagePowerProvider = Provider<String>((ref) {
  return ref.watch(powerProvider).average;
});
final averagePowerProvider = Provider<String>((ref) {
  return ref.watch(_averagePowerProvider);
});

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
