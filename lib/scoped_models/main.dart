import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class MainModel extends Model {
  Locale _appLocale = Locale('ar');

  Locale get appLocal => _appLocale ?? Locale("ar");

  void changeDirection() {
    if (_appLocale == Locale("ar")) {
      _appLocale = Locale("en");
    } else {
      _appLocale = Locale("ar");
    }
    notifyListeners();
  }

  void appLanguage(String lang) {
    _appLocale = Locale(lang);
    notifyListeners();
  }
}