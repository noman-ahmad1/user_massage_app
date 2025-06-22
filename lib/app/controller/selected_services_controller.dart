/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/services_model.dart';
import 'package:user/app/backend/parse/selected_services_parse.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/services_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/toast.dart';

class SelectedServicesController extends GetxController implements GetxService {
  final SelectedServicesParser parser;

  String selectedServiceId = '';
  String selectedServiceName = '';
  String selectedUID = '';
  bool apiCalled = false;

  List<int> services = [];

  List<ServicesModel> _servicesList = <ServicesModel>[];
  List<ServicesModel> get servicesList => _servicesList;
  List<ServicesModel> _realServicesList = <ServicesModel>[];

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  SelectedServicesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    selectedServiceId = Get.arguments[0].toString();
    debugPrint('selected services --> $selectedServiceId');
    selectedServiceName = Get.arguments[1].toString();
    debugPrint('selected servicesName --> $selectedServiceName');
    selectedUID = Get.arguments[2].toString();
    debugPrint('uid --> $selectedUID');
    getSalonDetails();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> getSalonDetails() async {
    var response = await parser
        .getServicesById({"id": selectedServiceId, "uid": selectedUID});

    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _servicesList = [];

      body.forEach((element) {
        ServicesModel service = ServicesModel.fromJson(element);
        _realServicesList.add(service);
        int index = _servicesList.indexWhere(
            (service) => service.extraField == element['extra_field']);

        if (index != -1) {
          _servicesList[index].prices?.add(service.price);
          _servicesList[index].discounts?.add(service.discount);
          _servicesList[index].offs?.add(service.off);
          _servicesList[index].durations?.add(service.duration);
          _servicesList[index].ids?.add(service.id);
        } else {
          service.prices?.add(service.price);
          service.discounts?.add(service.discount);
          service.offs?.add(service.off);
          service.durations?.add(service.duration);
          service.ids?.add(service.id);
          _servicesList.add(service);
        }
      });

      for (var ele in _servicesList) {
        debugPrint(ele.id.toString());

        for (int i = 0; i < ele.ids!.length; i++) {
          var action = ele.ids![i];
          if (ele.isChecked == false || ele.isChecked == null) {
            if (Get.find<ServiceCartController>()
                .checkServiceInCart(action as int)) {
              ele.isChecked = true;
              int indexy =
                  _realServicesList.indexWhere((service) => service.id == action);
              if (indexy != -1) {
               ele.selectedVariant = _realServicesList[indexy].duration;
               ele.selectedSubId = i;
              }
            } else {
              ele.isChecked = false;
            }
          }
        }
      }
      debugPrint(servicesList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  onUncheck(int index, bool status, int id) {
    int realId =0;
    for (var element in _servicesList) {
      if (element.id == id) {
        element.selectedVariant = null;
        element.selectedSubId = null;
        element.isChecked = false;
        for (var action in element.ids!) {
          if (Get.find<ServiceCartController>()
              .checkServiceInCart(action as int)) {
            element.isChecked = false;
            realId = action;
          }
        }


   
          int indexy =
              _realServicesList.indexWhere((service) => service.id == realId);
          if (indexy != -1) {
            updateServiceStatusInCartX(indexy, false, index);
          }
        
      }

      update();
    }
  }

  onUpdateDayName(dynamic name, int index, bool status, int id) {
    if(_servicesList[index].ids!.length > 1){
            for (var ser in _servicesList[index].ids!) {
    if (Get.find<ServiceCartController>()
              .checkServiceInCart(ser as int)) {
     onUncheck(index, status, id);
      // Return the first matching ID
    }
  }
    }

   
    for (var element in _servicesList) {
      if (element.id == id) {
        element.selectedVariant = name;
        element.isChecked = status;
        int indexx =
            element.durations!.indexWhere((duration) => duration == name);
        
        if (indexx != -1) {
          dynamic id = element.ids![indexx];
            element.selectedSubId =  indexx;
          int indexy =
              _realServicesList.indexWhere((service) => service.id == id);
          if (indexy != -1) {
            
            updateServiceStatusInCartX(indexy, status, index);
          }
        }
      }

      update();
    }
  }

  void updateServiceStatusInCartX(int index, bool status, int mimicIndex) {
    debugPrint('service id $index');
    debugPrint('service status $status');
    if (Get.find<ServiceCartController>().savedInCart.services!.isEmpty &&
        Get.find<ServiceCartController>().savedInCart.packages!.isEmpty) {
      _servicesList[mimicIndex].isChecked = status;
      if (status == true) {
        Get.find<ServiceCartController>()
            .addServiceToCart(_realServicesList[index], 'salon');
      } else {
        Get.find<ServiceCartController>()
            .removeServiceFromCart(_realServicesList[index].id as int);
      }
    } else if (Get.find<ServiceCartController>()
        .savedInCart
        .packages!
        .isNotEmpty) {
      int freelancerPackagesId =
          Get.find<ServiceCartController>().getPackageFreelancerId();
      if (freelancerPackagesId == _realServicesList[index].uid) {
        _servicesList[mimicIndex].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_realServicesList[index], 'salon');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_realServicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other salon or with freelancer'
                .tr);
      }
    } else {
      int freelancerIdServices =
          Get.find<ServiceCartController>().getServiceFreelancerId();

      if (freelancerIdServices == _realServicesList[index].uid) {
        _servicesList[mimicIndex].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_realServicesList[index], 'salon');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_realServicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other salon or with freelancer'
                .tr);
        update();
      }
    }
    Get.find<HomeController>().updateScreen();
    update();
  }

  void updateServiceStatusInCart(int index, bool status) {
    debugPrint('service id $index');
    debugPrint('service status $status');
    if (Get.find<ServiceCartController>().savedInCart.services!.isEmpty &&
        Get.find<ServiceCartController>().savedInCart.packages!.isEmpty) {
      _servicesList[index].isChecked = status;
      if (status == true) {
        Get.find<ServiceCartController>()
            .addServiceToCart(_servicesList[index], 'salon');
      } else {
        Get.find<ServiceCartController>()
            .removeServiceFromCart(_servicesList[index].id as int);
      }
    } else if (Get.find<ServiceCartController>()
        .savedInCart
        .packages!
        .isNotEmpty) {
      int freelancerPackagesId =
          Get.find<ServiceCartController>().getPackageFreelancerId();
      if (freelancerPackagesId == _servicesList[index].uid) {
        _servicesList[index].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_servicesList[index], 'salon');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_servicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other salon or with freelancer'
                .tr);
      }
    } else {
      int freelancerIdServices =
          Get.find<ServiceCartController>().getServiceFreelancerId();

      if (freelancerIdServices == _servicesList[index].uid) {
        _servicesList[index].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_servicesList[index], 'salon');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_servicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other salon or with freelancer'
                .tr);
        update();
      }
    }
    Get.find<HomeController>().updateScreen();
    update();
  }

  void onCheckout() {
    Get.delete<CheckoutController>(force: true);
    Get.toNamed(AppRouter.getCheckoutRoutes());
  }

  void onBack() {
    Get.find<ServicesController>().updateScreen();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
