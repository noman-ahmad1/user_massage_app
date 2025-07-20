/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';

class CheckoutParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CheckoutParser({required this.apiService, required this.sharedPreferencesManager});

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }
    String getServicesFrom() {
    return sharedPreferencesManager.getString('serviceFrom') ?? '';
  }

  void saveUID(String id) {
    sharedPreferencesManager.putString('uid', id);
  }

  Future<Response> getAppointmentById() async {
    return await apiService.postPrivate(AppConstants.getAppoimentById, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  bool isLogin() {
    return sharedPreferencesManager.getString('uid') != null && sharedPreferencesManager.getString('uid') != '' ? true : false;
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }
}
