import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:user/app/controller/feedback_controller.dart';

import 'package:user/app/util/theme.dart';

class FeedbackScreen extends StatefulWidget {


  const FeedbackScreen(
      {super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
  // final FeedbackController feedbackController = Get.put(FeedbackController());
  // final TextEditingController feedbackTextController = TextEditingController();
  // double rating = 0.0;
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // final FeedbackController feedbackController = Get.put(FeedbackController(parser: FeedbackParser(apiService: ApiService(appBaseUrl: ''),)));
  final TextEditingController feedbackTextController = TextEditingController();
  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackController>(
      builder: (value) {
        //     if (!value.apiCalled) {
        //   return const Center(child: CircularProgressIndicator()); // Show loading indicator
        // }
        // if (value.feedback == null) {
        //   return const Center(child: Text("No feedback available.")); // Handle null case
        // }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            title: Text('Feedback'.tr, style: ThemeProvider.titleStyle),
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Section
                Text('Rate Us'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: ThemeProvider.appColor,
                        fontFamily: 'bold',
                        fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index +
                              1.0; // Update the rating and trigger a rebuild
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Feedback Text Section
                Text('Your Feedback'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: ThemeProvider.appColor,
                        fontFamily: 'bold',
                        fontSize: 15)),
                const SizedBox(height: 10),
                TextField(
                  controller: feedbackTextController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeProvider.appColor),
                    ),
                    hintText: 'Write your feedback here...'.tr,
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  height: 70, // Adjusted height for consistency
                  child: InkWell(
                    onTap: () {
                      if (rating > 0 &&
                          feedbackTextController.text.isNotEmpty) {
                        // final feedbackinfo = FeedbackModel(
                        //   id: DateTime.now().millisecondsSinceEpoch, // Unique feedback ID
                        //   uid: userId,
                        //   freelancerId: freelancerId,
                        //   salonId: salonId,
                        //   specialistId: therapistId,
                        //   feedbackText: feedbackTextController.text,
                        //   rating: rating,
                        //   createdAt: DateTime.now(),
                        // );

                        value.submitFeedback(
                            value.userId!, value.salonId!, value.specialistId!, value.freelancerId!);
                        Get.snackbar(
                          'Thank You!'.tr,
                          'Your feedback has been submitted.'.tr,
                          backgroundColor: ThemeProvider.appColor,
                          colorText: ThemeProvider.whiteColor,
                        );
                        feedbackTextController.clear();
                        rating = 0.0;
                      } else {
                        Get.snackbar(
                          'Error'.tr,
                          'Please provide a rating and feedback text.'.tr,
                          backgroundColor: Colors.red,
                          colorText: ThemeProvider.whiteColor,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: ThemeProvider.appColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit'.tr,
                            style: const TextStyle(
                              color: ThemeProvider.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
