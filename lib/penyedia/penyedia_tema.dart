import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenyediaTema with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  PenyediaTema() {
    _muatPreferensi();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTema() {
    _isDarkMode = !_isDarkMode;
    _simpanPreferensi();
    notifyListeners();
  }

  Future<void> _muatPreferensi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _simpanPreferensi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
