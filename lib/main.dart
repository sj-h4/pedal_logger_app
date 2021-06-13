import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pedal_logger_flutter/view/dataView.dart';
import 'view/dataView.dart';
import 'view/bottom_navi_view.dart';
import 'ble/pedal_ble.dart';

//https://github.com/kazuma-fujita/flutter_bottom_navigation_bar/blob/master/lib/main.dart

final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.data);

enum TabType {
  data,
  setting,
}

final PedalBle pedalBle = PedalBle();

final powerProvider = StateNotifierProvider<PowerViewModel, AsyncValue<int>>(
    (_) => PowerViewModel());

void main() {
  runApp(ProviderScope(child: BottomNavigationBarView()));
}
