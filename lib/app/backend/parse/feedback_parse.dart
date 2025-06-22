import 'package:http/http.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:user/app/util/constant.dart';

class FeedbackParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FeedbackParser({required this.apiService, 
  required this.sharedPreferencesManager
  });


  Future<dynamic> getFeedbacks(var body) async {
    var response = await apiService.postPrivate(
      AppConstants.getFeedbacks, body, sharedPreferencesManager.getString('token') ?? ''
    );
    return response;
  }

  Future<dynamic> submitFeedback(Map<String, dynamic> body) async {
  var response = await apiService.postPrivate(
    AppConstants.submitFeedbacks,
    body,
    sharedPreferencesManager.getString('token') ?? ''
  );
  return response;
}

}