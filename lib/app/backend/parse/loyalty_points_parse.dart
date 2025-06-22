import 'package:get/get_connect.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/util/constant.dart';

class LoyaltyPointsParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;

  LoyaltyPointsParser({required this.apiService, required this.sharedPreferencesManager});

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getLoyaltyPoints() async {
    return await apiService.postPrivate(
      AppConstants.fetchloyaltyPoints,
      {"user_id": getUID()},
      getToken(),
    );
  }
}
