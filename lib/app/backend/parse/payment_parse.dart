/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class PaymentParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PaymentParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> salonDetails(var body) async {
    return await apiService.postPublic(AppConstants.salonDetails, body);
  }

  Future<Response> getPayments() async {
    var response = await apiService.getPrivate(AppConstants.getPayments, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> createAppoinments(var body) async {
    return await apiService.postPrivate(AppConstants.createAppointments, body, sharedPreferencesManager.getString('token') ?? '');
  }
  Future<Response> deductLoyaltyPoints(var body) async {
    return await apiService.postPrivate(AppConstants.deductloyaltyPoints, body, sharedPreferencesManager.getString('token') ?? '');
  }
  Future<Response> saveLoyaltyPoints(var body) async {
    // body['user_id'] = sharedPreferencesManager.getString('userId') ?? '';
    return await apiService.postPrivate(AppConstants.saveloyaltyPoints, body, sharedPreferencesManager.getString('token') ?? '');
  }
  Future<Response> fetchLoyaltyPoints(var body) async {
    return await apiService.postPrivate(AppConstants.fetchloyaltyPoints, body, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendNotification(var body) async {
    var response = await apiService.postPrivate(AppConstants.sendNotification, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getInstaMojoPayLink(var param) async {
    return await apiService.postPrivate(AppConstants.payWithInstaMojo, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSavedAddress(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSavedAddress, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getPhone() {
    return sharedPreferencesManager.getString('phone') ?? '';
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('first_name') ?? '';
    String lastName = sharedPreferencesManager.getString('last_name') ?? '';
    return '$firstName $lastName';
  }

  String getFirstName() {
    return sharedPreferencesManager.getString('first_name') ?? '';
  }

  String getLastName() {
    return sharedPreferencesManager.getString('last_name') ?? '';
  }

  String getAppLogo() {
    return sharedPreferencesManager.getString('appLogo') ?? '';
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

  Future<Response> getMyWalletBalance() async {
    return await apiService.postPrivate(AppConstants.getMyWalletBalance, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }
}
