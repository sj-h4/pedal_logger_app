import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pedal_logger_flutter/view/dataView.dart';

import 'view/dataView.dart';
import 'view/bottom_navi_view.dart';

//https://github.com/kazuma-fujita/flutter_bottom_navigation_bar/blob/master/lib/main.dart

final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.data);

enum TabType {
  data,
  setting,
}

final powerProvider =
    StateNotifierProvider<PowerViewModel, int>((ref) => PowerViewModel());

void main() {
  runApp(ProviderScope(child: BottomNavigationBarView()));
}
