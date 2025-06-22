import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/feedback_model.dart';
import 'package:user/app/backend/parse/feedback_parse.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class FeedbackController extends GetxController implements GetxService {
  final FeedbackParser parser;

  bool apiCalled = false;
  int? salonId;
  int? specialistId;
  int? freelancerId;
  int? userId;


  FeedbackModel? _feedback = FeedbackModel();
  FeedbackModel? get feedback => _feedback;

  String feedbackText = '';
  double rating = 0.0;

  FeedbackController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    salonId = Get.arguments[0];
    specialistId = Get.arguments[1];
    freelancerId = Get.arguments[2];
    userId = Get.arguments[3];
    fetchFeedbacks(); // Fetch existing feedbacks on initialization
  }

  // Fetch feedbacks from the backend
  Future<void> fetchFeedbacks() async {
    apiCalled = false;
    update();
    int? userId = parser.sharedPreferencesManager.getInt('userId');
    var response = await parser.getFeedbacks({"id": userId}); // Pass the required argument
    if (response.statusCode == 200) {
      var feedbackList = List<FeedbackModel>.from(response.body.map((item) => FeedbackModel.fromJson(item)));
      apiCalled = true;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Submit feedback to the backend
  Future<void> submitFeedback(int? userId, int? salonId, int? specialistId, int? freelancerId) async {
    if (rating <= 0 || feedbackText.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please provide a rating and feedback text.'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              Text("Submitting feedback...".tr, style: const TextStyle(fontFamily: 'bold')),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var body = {
      "userId": userId ?? 0,
      "salonId": salonId?? 0,
      "freelancerId": freelancerId?? 0,
      "specialistId": specialistId?? 0,
      "feedbackText": feedbackText,
      "rating": rating,
    };

    var response = await parser.submitFeedback(body);
    Get.back(); // Close the dialog

    if (response.statusCode == 200) {
      successToast('Feedback submitted successfully!'.tr);
      fetchFeedbacks(); // Refresh feedback list
    } else {
      ApiChecker.checkApi(response);
    }
  }

  // Clear feedback input
  void clearFeedback() {
    feedbackText = '';
    rating = 0.0;
    update();
  }

  // Navigate to feedback screen
  void navigateToFeedbackScreen(int? salon_id, int? specialist_id, int? freelancer_id, int? user_id) {
    Get.toNamed(AppRouter.getFeedbackRoutes(),arguments: [salon_id, specialist_id, freelancer_id, user_id] );
  }

  // Utility method to check if feedback list is empty
  bool isFeedbackListEmpty(dynamic feedbackList) {
    return feedbackList.isEmpty;
  }
}