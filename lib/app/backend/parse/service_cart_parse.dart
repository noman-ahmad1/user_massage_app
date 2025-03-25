/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'dart:convert';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/backend/models/packages_details_model.dart';
import 'package:user/app/backend/models/services_model.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';

class ServiceCartParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ServiceCartParser({required this.sharedPreferencesManager, required this.apiService});

  void saveService(List<ServicesModel> services) {
    List<String> carts = [];
    for (var cartModel in services) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferencesManager.putStringList('savedServices', carts);
  }

  void saveServiceFrom(String from) {
    sharedPreferencesManager.putString('serviceFrom', from);
  }

  String getServicesFrom() {
    return sharedPreferencesManager.getString('serviceFrom') ?? '';
  }

  void saveSalonId(int uid) {
    sharedPreferencesManager.putInt('salonId', uid);
  }

  int getSalonId() {
    return sharedPreferencesManager.getInt('salonId') ?? 0;
  }

  void savePackages(List<PackagesDetailsModel> packages) {
    List<String> carts = [];
    for (var cartModel in packages) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferencesManager.putStringList('savedPackages', carts);
  }

  List<ServicesModel> getServices() {
    List<String>? carts = [];
    if (sharedPreferencesManager.isKeyExists('savedServices') ?? false) {
      carts = sharedPreferencesManager.getStringList('savedServices');
    }
    List<ServicesModel> cartList = <ServicesModel>[];
    carts?.forEach((element) {
      var data = jsonDecode(element);
      cartList.add(ServicesModel.fromJson(data));
    });
    return cartList;
  }

  List<PackagesDetailsModel> getPackages() {
    List<String>? carts = [];
    if (sharedPreferencesManager.isKeyExists('savedPackages') ?? false) {
      carts = sharedPreferencesManager.getStringList('savedPackages');
    }
    List<PackagesDetailsModel> cartList = <PackagesDetailsModel>[];
    carts?.forEach((element) {
      var data = jsonDecode(element);
      cartList.add(PackagesDetailsModel.fromJson(data));
    });
    return cartList;
  }

  bool isLoggedIn() {
    return sharedPreferencesManager.getString('uid') != null && sharedPreferencesManager.getString('uid') != '' ? true : false;
  }

  double taxOrderPrice() {
    return sharedPreferencesManager.getDouble('tax') ?? 0.0;
  }

  double getShippingPrice() {
    return sharedPreferencesManager.getDouble('shippingPrice') ?? 0;
  }

  int getShippingMethod() {
    return sharedPreferencesManager.getInt('shipping') ?? AppConstants.defaultShippingMethod;
  }

  double freeOrderPrice() {
    return sharedPreferencesManager.getDouble('free') ?? 0.0;
  }

  double getAllowedDeliveryRadius() {
    return sharedPreferencesManager.getDouble('allowDistance') ?? AppConstants.defaultDeliverRadius;
  }
}
