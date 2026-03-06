import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initialThemeModeProvider = Provider<ThemeMode>((ref) {
  return ThemeMode.system;
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';
  @override
  ThemeMode build() {
    return ref.watch(initialThemeModeProvider);
  }

  void toggleTheme(Brightness currentBrightness) async {
    final newState =
        (state == ThemeMode.light ||
            (state == ThemeMode.system &&
                currentBrightness == Brightness.light))
        ? ThemeMode.dark
        : ThemeMode.light;

    state = newState;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, newState.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});
