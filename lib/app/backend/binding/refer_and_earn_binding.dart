/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/controller/refer_and_earn_controller.dart';

class ReferAndEarnBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => ReferAndEarnController(parser: Get.find()));
  }
}
