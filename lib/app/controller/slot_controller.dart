/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/bookedslot_model.dart';
import 'package:user/app/backend/models/slots_model.dart';
import 'package:user/app/backend/models/specialist_model.dart';
import 'package:user/app/backend/parse/slot_parse.dart';
import 'package:user/app/controller/checkout_controller.dart';
import 'package:user/app/controller/payment_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class SlotController extends GetxController implements GetxService {
  final SlotParser parser;

  bool selected = false;
  String savedDate = '';
  List<String> bookedSlots = [];
  bool haveData = false;
  String selectedSlotIndex = '';
  DatePickerController controller = DatePickerController();
  DateTime selectedValue = DateTime.now();
  List<String> dayList = ['Sunday'.tr, 'Monday'.tr, 'Tuesday'.tr, 'Wednesday'.tr, 'Thursday'.tr, 'Friday'.tr, 'Saturday'.tr];

  bool isChecked = false;

  List<SpecialistModel> _specialistList = <SpecialistModel>[];
  List<SpecialistModel> get specialistList => _specialistList;

  bool apiCalled = false;
  String uid = '';

  SlotModel _slotList = SlotModel();
  SlotModel get slotList => _slotList;

  String selectedSpecialist = '';
  SlotController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    if (Get.find<CheckoutController>().savedInCart.services!.isNotEmpty || Get.find<CheckoutController>().savedInCart.packages!.isNotEmpty) {
      if (Get.find<CheckoutController>().savedInCart.services!.isNotEmpty) {
        uid = Get.find<CheckoutController>().savedInCart.services![0].uid.toString();
      } else if (Get.find<CheckoutController>().savedInCart.packages!.isNotEmpty) {
        uid = Get.find<CheckoutController>().savedInCart.packages![0].uid.toString();
      }

      // var dayName = Jiffy.now().format(pattern: "EEEE"); // Tuesday
      // debugPrint(dayName);
      // int index = dayList.indexOf(dayName);
      // var date = Jiffy.now().format(pattern: 'yyyy-MM-dd');
      // savedDate = date;
      update();
     
    } else {
      onBack();
    }
    getSpecialist();
  }

  Future<void> getSpecialist() async {
    var response = await parser.getSpecialist({"id": uid});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonSpecialist = myMap['data'];

      _specialistList = [];

      salonSpecialist.forEach((data) {
        SpecialistModel specialist = SpecialistModel.fromJson(data);
        _specialistList.add(specialist);
      });
      debugPrint(specialistList.length.toString());

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSlotsForBookings(int index, String date, String specialistId) async {
  _slotList = SlotModel();
  bookedSlots = [];
  haveData = false;
  update();

  var response = await parser.getSlots({
    "week_id": index,
    "date": date,
    "uid": uid,
    "from": "salon",
    "specialist_id": specialistId
  });

  apiCalled = true;

  if (response.statusCode == 200) {
    Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
    var body = myMap['data'];
    var booked = myMap['bookedSlots'];

    if (body != null) {
      SlotModel datas = SlotModel.fromJson(body);
      _slotList = datas;
      haveData = true;
    }

    if (booked != null) {
      bookedSlots = List<String>.from(booked.map((e) => BookedSlotModel.fromJson(e).slot.toString()));
    }
  } else {
    ApiChecker.checkApi(response);
  }

  update();
}

  // Future<void> getSlotsForBookings(int index, String date, String specialistId) async {
  //   var response = await parser.getSlots({"week_id": index, "date": date, "uid": uid, "from": "salon", "specialist_id": specialistId});
  //   apiCalled = true;

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
  //     var body = myMap['data'];
  //     var booked = myMap['bookedSlots'];
  //     _slotList = SlotModel();
  //     if (body != null) {
  //       haveData = true;
  //       SlotModel datas = SlotModel.fromJson(body);
  //       _slotList = datas;
  //       update();
  //     }

  //     if (booked != null) {
  //       bookedSlots = [];
  //       booked.forEach((element) {
  //         BookedSlotModel slot = BookedSlotModel.fromJson(element);
  //         bookedSlots.add(slot.slot.toString());
  //       });
  //     }
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  Color getColor(Set<WidgetState> states) {
    return ThemeProvider.appColor;
  }

  bool isBooked(String slot) {
    return bookedSlots.contains(slot) ? true : false;
  }

  void onSelectSlot(String slot) {
    if (!bookedSlots.contains(slot)) {
      selectedSlotIndex = slot;
      update();
    }
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onDateChange(DateTime date) {
  selectedSlotIndex = '';
  haveData = false;
  selectedValue = date;
  update();

  String dayName = Jiffy.parse(date.toString()).format(pattern: "EEEE");
  String selectedDate = Jiffy.parse(date.toString()).format(pattern: 'yyyy-MM-dd');
  savedDate = selectedDate;

  int index = dayList.indexOf(dayName);

  getSlotsForBookings(index, selectedDate, selectedSpecialist);
}

  // void onDateChange(DateTime date) {
  //   selectedSlotIndex = '';
  //   haveData = false;
  //   debugPrint(date.toString());
  //   var dayName = Jiffy.parse(date.toString()).format(pattern: "EEEE");
  //   var selectedDate = Jiffy.parse(date.toString()).format(pattern: 'yyyy-MM-dd');
  //   savedDate = selectedDate;
  //   update();
  //   debugPrint(dayName);
  //   int index = dayList.indexOf(dayName);
  //   debugPrint(index.toString());
  //   getSlotsForBookings(index, selectedDate, selectedSpecialist);
  // }

  void onPayment() {
    if (selectedSlotIndex == '') {
      showToast('Please select Slots'.tr);
      return;
    }
    if (selectedSpecialist == '') {
      showToast('Please select specialist'.tr);
      return;
    }
    Get.delete<PaymentController>(force: true);
    Get.toNamed(AppRouter.getPaymentRoutes());
  }

  void saveSpecialist(int id) {
  debugPrint(id.toString());
  selectedSpecialist = id.toString();

  String targetDate = savedDate.isNotEmpty
      ? savedDate
      : Jiffy.now().format(pattern: 'yyyy-MM-dd');

  String dayName = Jiffy.parse(targetDate).format(pattern: "EEEE");
  int index = dayList.indexOf(dayName);

  haveData = false; // Reset before fetching
  selectedSlotIndex = '';
  update();

  getSlotsForBookings(index, targetDate, selectedSpecialist);
}


  // void saveSpecialist(int id) {
  //   debugPrint(id.toString());
  //    var dayName = Jiffy.now().format(pattern: "EEEE"); // Tuesday
  //     debugPrint(dayName);
  //     int index = dayList.indexOf(dayName);
  //     var date = Jiffy.now().format(pattern: 'yyyy-MM-dd');
  //     savedDate = date;
  //   selectedSpecialist = id.toString();
  //    getSlotsForBookings(index, date, selectedSpecialist);
  //   update();
  // }
}
