/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/address_model.dart';
import 'package:user/app/backend/models/coupons_model.dart';
import 'package:user/app/backend/models/payment_models.dart';
import 'package:user/app/backend/models/salon_details_model.dart';
import 'package:user/app/backend/parse/payment_parse.dart';
import 'package:user/app/controller/address_list_controller.dart';
import 'package:user/app/controller/coupon_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/slot_controller.dart';
import 'package:user/app/controller/web_payment_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentParser parser;

  bool isChecked = false;
  bool apiCalled = false;
  bool paymentAPICalled = false;
  SalonDetailsModel _salonDetails = SalonDetailsModel();
  SalonDetailsModel get salonDetails => _salonDetails;

  List<PaymentModel> _paymentList = <PaymentModel>[];
  List<PaymentModel> get paymentList => _paymentList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  final notesEditor = TextEditingController();

  double loyaltyPoints = 0.0;

  String offerId = '';
  String offerName = '';

  double _discount = 0.0;
  double get discount => _discount;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  bool haveFairDeliveryRadius = true;

  double _deliveryPrice = 0.0;
  double get deliveryPrice => _deliveryPrice;

  int paymentId = 0;
  String payMethodName = '';

  bool isWalletChecked = false;
  double balance = 0.0;
  double walletDiscount = 0.0;

  bool haveAddress = false;

  late CouponsModel _selectedCoupon = CouponsModel();
  CouponsModel get selectedCoupon => _selectedCoupon;

  List<AddressModel> _addressList = <AddressModel>[];
  List<AddressModel> get addressList => _addressList;

  AddressModel _addressInfo = AddressModel();
  AddressModel get addressInfo => _addressInfo;

  String selectedAddressId = '';

  int appointmentsTo = 0;

  PaymentController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getSalonDetails();
    getPaymentMethods();
    getMyWalletAmount();
    calculateAllCharge();
    getLoyaltyPoints();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();

    debugPrint('salon id ==> ${Get.find<ServiceCartController>().salonId}');
  }

  Future<void> getMyWalletAmount() async {
    Response response = await parser.getMyWalletBalance();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null &&
          body != '' &&
          body['balance'] != null &&
          body['balance'] != '') {
        balance = double.tryParse(body['balance'].toString()) ?? 0.0;
        walletDiscount = double.tryParse(body['balance'].toString()) ?? 0.0;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSalonDetails() async {
    var response =
        await parser.salonDetails({"id": Get.find<SlotController>().uid});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      _salonDetails = SalonDetailsModel();

      SalonDetailsModel services = SalonDetailsModel.fromJson(body);
      _salonDetails = services;
      // if (salonDetails.serviceAtHome == 1) {
      //   appointmentsTo = 1;
      //   getSavedAddress();
      // }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void updateServiceAt(int type) {
    appointmentsTo = type;
    if (appointmentsTo == 0) {
      _deliveryPrice = 0;
      haveFairDeliveryRadius = true;
    } else {
      haveFairDeliveryRadius = false;
      getSavedAddress();
    }
    update();
  }

  Future<void> getSavedAddress() async {
    var param = {"id": parser.getUID()};

    Response response = await parser.getSavedAddress(param);
    debugPrint(response.bodyString);
    apiCalled = true;
    update();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != null && myMap['data'] != '') {
        var address = myMap['data'];
        _addressList = [];
        _addressInfo = AddressModel();
        address.forEach((add) {
          AddressModel adds = AddressModel.fromJson(add);
          _addressList.add(adds);
        });
        if (_addressList.isNotEmpty) {
          haveAddress = true;
          _addressInfo = _addressList[0];
          selectedAddressId = _addressInfo.id.toString();
          calculateDistance();
        } else {
          haveAddress = false;
        }
        debugPrint(addressList.length.toString());
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getPaymentMethods() async {
    Response response = await parser.getPayments();
    paymentAPICalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var payment = myMap['data'];
      _paymentList = [];
      payment.forEach((pay) {
        PaymentModel pays = PaymentModel.fromJson(pay);
        _paymentList.add(pays);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void calculateDistance() {
    debugPrint(salonDetails.lat.toString());
    debugPrint(salonDetails.lng.toString());
    debugPrint(addressInfo.lat.toString());
    debugPrint(addressInfo.lng.toString());

    debugPrint(Get.find<ServiceCartController>().shippingMethod.toString());
    if (addressInfo.lat != null &&
        addressInfo.lng != null &&
        salonDetails.lat != null &&
        salonDetails.lng != null) {
      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(addressInfo.lat.toString()) ?? 0.0,
        double.tryParse(addressInfo.lng.toString()) ?? 0.0,
        double.tryParse(salonDetails.lat.toString()) ?? 0.0,
        double.tryParse(salonDetails.lng.toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint('distance$distance');
      debugPrint(
          'distance price${Get.find<ServiceCartController>().shippingPrice}');
      if (distance >
          Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()) {
        haveFairDeliveryRadius = false;
        showToast(
            '${'Sorry we deliver the order near to'.tr} ${Get.find<ServiceCartController>().parser.getAllowedDeliveryRadius()} KM');
      } else {
        if (Get.find<ServiceCartController>().shippingMethod == 0) {
          double distancePricer =
              distance * Get.find<ServiceCartController>().shippingPrice;
          _deliveryPrice = double.parse((distancePricer).toStringAsFixed(2));
        } else {
          _deliveryPrice = Get.find<ServiceCartController>().shippingPrice;
        }
        haveFairDeliveryRadius = true;
      }
      calculateAllCharge();
      update();
    }
  }

  void onCoupon(String offerId, String offerName) {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes(),
        arguments: ['service', offerId, offerName]);
  }

  void updateWalletChecked(bool status) {
    isWalletChecked = status;
    calculateAllCharge();
    update();
  }

  void onSaveCoupon(CouponsModel offer) {
    _selectedCoupon = offer;
    offerId = offer.id.toString();
    offerName = offer.name.toString();
    update();
    calculateAllCharge();
  }

  void calculateAllCharge() {
    double totalPrice = Get.find<ServiceCartController>().totalPrice +
        Get.find<ServiceCartController>().orderTax +
        _deliveryPrice;

    if (_selectedCoupon.discount != null && _selectedCoupon.discount != 0) {
      double percentage(numFirst, per) {
        return (numFirst / 100) * per;
      }

      _discount = percentage(Get.find<ServiceCartController>().totalPrice,
          _selectedCoupon.discount); // null
    }
    walletDiscount = balance;
    if (isWalletChecked == true) {
      if (totalPrice <= walletDiscount) {
        walletDiscount = totalPrice;
        totalPrice = totalPrice - walletDiscount;
      } else {
        totalPrice = totalPrice - walletDiscount;
      }
    } else {
      if (totalPrice <= discount) {
        _discount = totalPrice;
        totalPrice = totalPrice - discount;
      } else {
        totalPrice = totalPrice - discount;
      }
    }
    debugPrint('grand total $totalPrice');
    _grandTotal = double.parse((totalPrice).toStringAsFixed(2));
    update();
  }

  void updateStatus() {
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void selectPaymentMethod(int id) {
    paymentId = id;
    if (paymentId == 1) {
      payMethodName = 'cod';
    } else if (paymentId == 2) {
      payMethodName = 'stripe';
    } else if (paymentId == 3) {
      payMethodName = 'paypal';
    } else if (paymentId == 4) {
      payMethodName = 'paytm';
    } else if (paymentId == 5) {
      payMethodName = 'razorpay';
    } else if (paymentId == 6) {
      payMethodName = 'instamojo';
    } else if (paymentId == 7) {
      payMethodName = 'paystack';
    } else if (paymentId == 8) {
      payMethodName = 'flutterwave';
    } else if (paymentId == 9) {
      payMethodName = 'Loyalty Points';
    }
    update();
  }

  void onSelectAddress() {
    Get.delete<AddressListController>(force: true);
    Get.toNamed(AppRouter.getAddressList(),
        arguments: ['salon', selectedAddressId]);
  }

  void onSaveAddress(String id) {
    selectedAddressId = id;
    var address =
        _addressList.firstWhere((element) => element.id.toString() == id);
    _addressInfo = address;
    calculateDistance();

    update();
  }

  void onPayment() {
    if (paymentId == 0) {
      showToast('Please select payment method'.tr);
      return;
    }
    Get.defaultDialog(
      title: '',
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/question-mark.png',
              fit: BoxFit.cover, height: 80, width: 80),
          const SizedBox(height: 20),
          Text('Are you sure'.tr,
              style: const TextStyle(fontSize: 24, fontFamily: 'semi-bold')),
          const SizedBox(height: 10),
          Text('Appoinments once placed cannot be cancelled and non-refundable'
              .tr),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    var context = Get.context as BuildContext;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeProvider.whiteColor,
                    backgroundColor: ThemeProvider.greyColor,
                    minimumSize: const Size.fromHeight(35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('Cancel'.tr,
                      style: const TextStyle(
                          color: ThemeProvider.whiteColor, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    var context = Get.context as BuildContext;
                    Navigator.pop(context);
                    onCheckout();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeProvider.whiteColor,
                    backgroundColor: ThemeProvider.appColor,
                    minimumSize: const Size.fromHeight(35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('Book'.tr,
                      style: const TextStyle(
                          color: ThemeProvider.whiteColor, fontSize: 14)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onCheckout() {
    if (paymentId == 1) {
      createOrder('COD');
    } else if (paymentId == 9) {
      createOrder('Loyalty Points');
    }

    // } else if (paymentId == 2) {
    //   final int toPay = grandTotal.toInt() * 100;
    //   debugPrint('Stripe Pay $payMethodName --- $toPay');
    //   Get.delete<WebPaymentController>(force: true);
    //   var paymentURL = AppConstants.stripeWebCheckoutLink + toPay.toString();
    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    // } else if (paymentId == 3) {
    //   Get.delete<WebPaymentController>(force: true);
    //   var paymentURL = AppConstants.payPalPayLink + grandTotal.toString();
    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    //   // paypal
    // } else if (paymentId == 4) {
    //   // paytm
    //   Get.delete<WebPaymentController>(force: true);
    //   var paymentURL = AppConstants.payTmPayLink + grandTotal.toString();
    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    // } else if (paymentId == 5) {
    //   // razorpay
    //   Get.delete<WebPaymentController>(force: true);
    //   var paymentPayLoad = {
    //     'amount': double.parse((grandTotal * 100).toStringAsFixed(2)).toString(),
    //     'email': parser.getEmail(),
    //     'logo': '${parser.apiService.appBaseUrl}storage/images/${parser.getAppLogo()}',
    //     'name': parser.getName(),
    //     'app_color': '#f47878'
    //   };

    //   String queryString = Uri(queryParameters: paymentPayLoad).query;
    //   var paymentURL = AppConstants.razorPayLink + queryString;

    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    // } else if (paymentId == 6) {
    //   payWithInstaMojo();
    //   // instamojo
    // } else if (paymentId == 7) {
    //   var rng = Random();
    //   var paykey = List.generate(12, (_) => rng.nextInt(100));
    //   Get.delete<WebPaymentController>(force: true);
    //   var paymentPayLoad = {'email': parser.getEmail(), 'amount': double.parse((grandTotal * 100).toStringAsFixed(2)).toString(), 'first_name': parser.getFirstName(), 'last_name': parser.getLastName(), 'ref': paykey.join()};
    //   String queryString = Uri(queryParameters: paymentPayLoad).query;
    //   var paymentURL = AppConstants.paystackCheckout + queryString;

    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    //   // paystock
    // } else if (paymentId == 8) {
    //   //flutterwave
    //   Get.delete<WebPaymentController>(force: true);
    //   var gateway = paymentList.firstWhereOrNull((element) => element.id.toString() == paymentId.toString());
    //   var paymentPayLoad = {
    //     'amount': grandTotal.toString(),
    //     'email': parser.getEmail(),
    //     'phone': parser.getPhone(),
    //     'name': parser.getName(),
    //     'code': gateway!.currencyCode.toString(),
    //     'logo': '${parser.apiService.appBaseUrl}storage/images/${parser.getAppLogo()}',
    //     'app_name': Environments.appName
    //   };

    //   String queryString = Uri(queryParameters: paymentPayLoad).query;
    //   var paymentURL = AppConstants.flutterwaveCheckout + queryString;

    //   Get.toNamed(AppRouter.getWebPayment(), arguments: [payMethodName, paymentURL, 'salon']);
    // }
  }
  Future<void> getLoyaltyPoints() async {
  var response = await parser.fetchLoyaltyPoints({
    'user_id': parser.getUID(),
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
    loyaltyPoints = double.tryParse(myMap['points'].toString()) ?? 0.0;
    update();
  } else {
    ApiChecker.checkApi(response);
  }
}

Future<void> saveLoyaltyPoints(double points) async {
  var response = await parser.saveLoyaltyPoints({
    "user_id": parser.getUID(),
    "points": points.toInt(),
  });

  if (response.statusCode == 200) {
    Get.snackbar(
      'Loyalty Points Saved',
      'You have earned $points loyalty points!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    getLoyaltyPoints();
  } else {
    ApiChecker.checkApi(response);
  }
}

  Future<void> createOrder(String type) async {
    if (type == 'Loyalty Points') {
      //deduction API Call
      var resp = await parser.deductLoyaltyPoints({ "user_id": parser.getUID(),"points": Get.find<ServiceCartController>().totalPrice.toInt() });
      if (resp.statusCode != 200) {
        Get.dialog(
          SimpleDialog(
            children: [
              Row(
                children: [
                  const SizedBox(width: 30),
                  const CircularProgressIndicator(
                      color: ThemeProvider.appColor),
                  const SizedBox(width: 30),
                  SizedBox(
                      child: Text("Error Paying through loyalty points",
                          style: const TextStyle(fontFamily: 'bold'))),
                ],
              )
            ],
          ),
        );
        return;
      }
    }
    if(type == 'COD') {
    double pointsToSave = grandTotal * 0.05;

    await saveLoyaltyPoints(pointsToSave);
    }

    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(
                  child: Text("Please wait".tr,
                      style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var param = {
      "uid": parser.getUID(),
      "freelancer_id": 0,
      "salon_id": Get.find<ServiceCartController>().salonId.toString(),
      "specialist_id": Get.find<SlotController>().selectedSpecialist,
      "appointments_to": appointmentsTo,
      "address": appointmentsTo == 1 ? jsonEncode(addressInfo) : 'NA',
      "items": jsonEncode(Get.find<ServiceCartController>().savedInCart),
      "coupon_id": selectedCoupon.code != null ? selectedCoupon.id : 0,
      "coupon": selectedCoupon.code != null ? jsonEncode(selectedCoupon) : 'NA',
      "discount": discount,
      "distance_cost": deliveryPrice,
      "total": Get.find<ServiceCartController>().totalPrice,
      "serviceTax": Get.find<ServiceCartController>().orderTax,
      "grand_total": grandTotal,
      "pay_method": paymentId,
      "paid": type,
      "save_date": Get.find<SlotController>().savedDate,
      "slot": Get.find<SlotController>().selectedSlotIndex,
      'wallet_used': isWalletChecked == true && walletDiscount > 0 ? 1 : 0,
      'wallet_price':
          isWalletChecked == true && walletDiscount > 0 ? walletDiscount : 0,
      "notes": notesEditor.text.isNotEmpty ? notesEditor.text : 'NA',
      "status": 0
    };
    var response = await parser.createAppoinments(param);
    var notificationParam = {
      "id": Get.find<ServiceCartController>().salonId,
      "title": 'New Appointment',
      "message": 'New Appointment Received'
    };
    await parser.sendNotification(notificationParam);
    Get.back();

    if (response.statusCode == 200) {
      Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/images/sure.gif',
                        fit: BoxFit.cover, height: 60, width: 60)),
              ),
              const SizedBox(height: 30),
              Text('Thank You!'.tr,
                  style: const TextStyle(fontFamily: 'bold', fontSize: 18)),
              const SizedBox(height: 10),
              Text('For Your Appoinment'.tr,
                  style:
                      const TextStyle(fontFamily: 'semi-bold', fontSize: 16)),
              const SizedBox(height: 20),
              Text(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  backOrders();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ThemeProvider.whiteColor,
                  backgroundColor: ThemeProvider.appColor,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'TRACK MY APPOINTMENT'.tr,
                  style: const TextStyle(
                      color: ThemeProvider.whiteColor, fontSize: 14),
                ),
              ),
              TextButton(
                  onPressed: () => backHome(),
                  child: Text('BACK TO HOME'.tr,
                      style: const TextStyle(color: ThemeProvider.appColor))),
            ],
          ),
        ),
      );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> payWithInstaMojo() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(
                  child: Text("Please wait".tr,
                      style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    var param = {
      'allow_repeated_payments': 'False',
      'amount': grandTotal,
      'buyer_name': parser.getName(),
      'purpose': 'Orders',
      'redirect_url': '${parser.apiService.appBaseUrl}/api/v1/success_payments',
      'phone': parser.getPhone() != '' ? parser.getPhone() : '8888888888888888',
      'send_email': 'True',
      'webhook': parser.apiService.appBaseUrl,
      'send_sms': 'True',
      'email': parser.getEmail()
    };
    Response response = await parser.getInstaMojoPayLink(param);
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["success"];
      if (body['payment_request'] != '' &&
          body['payment_request']['longurl'] != '') {
        Get.delete<WebPaymentController>(force: true);
        var paymentURL = body['payment_request']['longurl'];
        Get.toNamed(AppRouter.getWebPayment(),
            arguments: [payMethodName, paymentURL, 'salon']);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void backHome() {
    Get.find<ServiceCartController>().clearCart();
    Get.offAllNamed(AppRouter.getTabsBarRoute(), arguments: [0]);
    // Get.find<TabsController>().updateTabId(0);
  }

  void backOrders() {
    Get.find<ServiceCartController>().clearCart();
    Get.offAllNamed(AppRouter.getTabsBarRoute(), arguments: [3]);
    // Get.find<TabsController>().updateTabId(3);
  }
}
