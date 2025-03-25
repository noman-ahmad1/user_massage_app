/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/language_model.dart';
import 'package:user/app/backend/models/settings_model.dart';
import 'package:user/app/backend/models/support_model.dart';
import 'package:user/app/backend/parse/splash_parse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashController extends GetxController implements GetxService {
  final SplashParser parser;

  late LanguageModel _defaultLanguage;
  LanguageModel get defaultLanguage => _defaultLanguage;
  late SettingsModel _settingsModel;
  SettingsModel get settinsModel => _settingsModel;

  late SupportModel _supportModel;
  SupportModel get supportModel => _supportModel;
  SplashController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) {
      checkNotificationPermission();
    }
  }

  Future<void> checkNotificationPermission() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    firebaseMessaging.getToken().then((value) async {
      String? token = value;
      parser.saveDeviceToken(value.toString());
      debugPrint('/////////////////////////');
      debugPrint(token);
      debugPrint('/////////////////////////');
    });
  }

  Future<bool> initSharedData() {
    return parser.initAppSettings();
  }

  Future<bool> getConfigData() async {
    Response response = await parser.getAppSettings();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != null) {
        dynamic body = myMap["data"];
        if (body['settings'] != null && body['support'] != null) {
          SettingsModel appSettingsInfo = SettingsModel.fromJson(body['settings']);

          _settingsModel = appSettingsInfo;

          SupportModel supportModelInfo = SupportModel.fromJson(body['support']);
          _supportModel = supportModelInfo;
          parser.saveBasicInfo(
            appSettingsInfo.currencyCode,
            appSettingsInfo.currencySide,
            appSettingsInfo.currencySymbol,
            appSettingsInfo.smsName,
            appSettingsInfo.userVerifyWith,
            appSettingsInfo.userLogin,
            appSettingsInfo.email,
            appSettingsInfo.name,
            0,
            appSettingsInfo.deliveryCharge,
            appSettingsInfo.tax,
            appSettingsInfo.logo,
            '${supportModelInfo.firstName!} ${supportModelInfo.lastName!}',
            supportModelInfo.id,
            appSettingsInfo.mobile.toString(),
            appSettingsInfo.allowDistance,
          );
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  String getLanguageCode() {
    return parser.getLanguagesCode();
  }
}
