import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class themeChange extends ChangeNotifier {
  var isDark = true;

  themeChange(bool isdark) {
    if (isdark) {
      isDark = true;
    } else {
      isDark = false;
    }
  }

  Future<void> changeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark = !isDark;
    sharedPreferences.setBool('theme', isDark);
    notifyListeners();
  }
}
