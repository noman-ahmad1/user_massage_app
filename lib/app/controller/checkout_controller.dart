/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/appointment_model.dart';
import 'package:user/app/backend/models/service_cart_model.dart';
import 'package:user/app/backend/parse/checkout_parse.dart';
import 'package:user/app/backend/parse/service_cart_parse.dart';
import 'package:user/app/controller/coupon_controller.dart';
import 'package:user/app/controller/individual_slot_controller.dart';
import 'package:user/app/controller/login_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/slot_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';

class CheckoutController extends GetxController implements GetxService {
  final CheckoutParser parser;

  bool isChecked = false;

  ServiceCartModel _savedInCart = ServiceCartModel();
  ServiceCartModel get savedInCart => _savedInCart;


  AppointmentModel _appointmentInfo = AppointmentModel();
  AppointmentModel get appointmentInfo => _appointmentInfo;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  CheckoutController({required this.parser});

  @override
  void onInit() {
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    super.onInit();
    // getAppointmentByAppointmentType();
  }

  Future<void> getAppointmentByAppointmentType() async {
  try {
    Response response = await parser.getAppointmentById();
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      debugPrint('Response body: $body');
      _appointmentInfo = AppointmentModel.fromJson(body);
      
      debugPrint('Appointment type from API: ${_appointmentInfo?.appointmentsTo}');
      
      if (_appointmentInfo?.appointmentsTo == null) {
        throw Exception('Appointment type not specified in API response');
      }
      
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  } catch (e) {
    debugPrint('Error in getAppointmentByAppointmentType: $e');
    Get.snackbar('Error', 'Failed to load appointment: ${e.toString()}');
  }
}

  void onCoupon() {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes());
  }

  void onSlot() {
    String serviceFrom = parser.getServicesFrom();

  if (parser.isLogin() == true) {
    if (serviceFrom == "salon") {
      Get.delete<SlotController>(force: true);
      Get.toNamed(AppRouter.getSlotRoutes());
    } else if (serviceFrom == "individual") {
      Get.delete<IndividualSlotController>(force: true);
      Get.toNamed(AppRouter.getIndividualSlot());
    }
  } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
    }
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  void deleteServiceFromCart(int index) {
    Get.find<ServiceCartController>().removeServiceFromCart(_savedInCart.services![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    update();
    checkCartItems();
  }

  void deletePackageFromCart(int index) {
    Get.find<ServiceCartController>().removePackageFromCart(_savedInCart.packages![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    update();
    checkCartItems();
  }

  void checkCartItems() {
    if (Get.find<ServiceCartController>().savedInCart.services!.isEmpty && Get.find<ServiceCartController>().savedInCart.packages!.isEmpty) {
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }
  }
}
