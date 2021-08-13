import 'package:flutter/material.dart';
import 'package:pedal_logger_flutter/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dataView.dart';
import 'settingView.dart';

// 画面下部のナビゲーションバーを表示
class BottomNavigationBarView extends HookWidget {
  final _views = [DataView(), SettingView()];

  @override
  Widget build(BuildContext context) {
    final tabType = useProvider(tabTypeProvider);
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          // タブとそのアイコンの指定
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          // 押された場所に遷移する
          onTap: (int selectIndex) {
            tabType.state = TabType.values[selectIndex];
          },
          currentIndex: tabType.state.index,
        ),
        body: _views[tabType.state.index],
        // body: ProviderScope(
        //   child: _views[_selectIndex],
        // ),
      ),
    );
  }
}
