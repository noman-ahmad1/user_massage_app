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

class IndividualSlotParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  IndividualSlotParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getSlots(var body) {
    return apiService.postPrivate(AppConstants.getSlotsForBookings, body, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSpecialist(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSpecislistById, body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
