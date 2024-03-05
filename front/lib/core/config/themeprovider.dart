import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  void updateTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
