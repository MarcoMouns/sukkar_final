import 'package:scoped_model/scoped_model.dart';
import './user_scoped_model.dart';
import './meals_scoped_model.dart';
import './medicine_scoped_model.dart';
import '../languages/all_translations.dart';
import 'package:flutter/material.dart';
import 'articles_soped_model.dart';
import 'articles_tab/articles_scoped_category.dart';
import 'doctor_tab/doctor_scoped_model.dart';
import 'friends_tab/friends_tab_scoped_model.dart';
import 'home_scoped_model.dart';
import 'measurements.dart';
import 'notifications_scoped_model.dart';

class MainModel extends Model
    with
        UserScopedModel,
        MealScopedModel,
        MedicineScopedModel,
        MeasurementsScopedModel,
        ArticlesScopedModel,
        ArticlesCategoriesScopedModel,
        NotificationsScopedModel,
        FriendsScopedModel,
        HomeScopedModel,
        DoctorScopedModel {
  Locale get appLocal => allTranslations.locale;

  void changeDirection(lang) async {
    notifyListeners();
  }
}
