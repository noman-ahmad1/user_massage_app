import 'package:get/get.dart';
import 'package:user/app/controller/loyalty_points_controller.dart';
import 'package:user/app/backend/parse/loyalty_points_parse.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';

class LoyaltyPointsBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies in the correct order
    // Get.lazyPut(() => SharedPreferencesManager());
    // Get.lazyPut(() => ApiService(sharedPreferencesManager: Get.find()));
    Get.lazyPut(() => LoyaltyPointsParser(
          apiService: Get.find(),
          sharedPreferencesManager: Get.find(),
        ));
    Get.lazyPut(() => LoyaltyPointsController(parser: Get.find()));
  }
}
