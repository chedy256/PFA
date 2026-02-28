import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme(Brightness currentBrightness) {
    if (state == ThemeMode.light ||
        (state == ThemeMode.system && currentBrightness == Brightness.light)) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});
