import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'all_translations.dart';
class AppModel extends Model {
  Locale get appLocal =>allTranslations.locale;
  void changeDirection (lang) async{
    notifyListeners();
  }
}