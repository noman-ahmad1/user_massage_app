/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class AddReviewParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddReviewParser({required this.sharedPreferencesManager, required this.apiService});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getOwnerReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.getOwnerReviews, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
  Future<Response> getSpecialistReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSpecialistReviews, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getProductsReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.getProductsReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> saveOwnerReview(var body) async {
    var response = await apiService.postPrivate(AppConstants.saveOwnerReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
  Future<Response> saveSpecialistReview(var body) async {
    var response = await apiService.postPrivate(AppConstants.saveSpecialistReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> saveProductReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.saveProductReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateProductReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateProductReviews, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> savePackageReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.savePackageReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateOwnerReview(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateOwnerReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
  Future<Response> updateSpecialistReview(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateSpecialistReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getServiceReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.getServiceReviews, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> saveServiceReviews(var body) async {
    var response = await apiService.postPrivate(AppConstants.saveServiceReview, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
