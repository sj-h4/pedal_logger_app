import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view/bottom_navi_view.dart';
import 'view/timer.dart';
import 'ble/pedal_ble.dart';

// 画面遷移用のもの
final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.data);

enum TabType {
  data,
  setting,
}

// ペダルのデータの状態を管理するもの
final powerProvider =
    StateNotifierProvider<PowerViewModel, PedalState>((_) => PowerViewModel());

// タイマーの状態を管理するもの
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
