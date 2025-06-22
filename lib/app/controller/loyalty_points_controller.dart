import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/loyalty_points_model.dart';
import 'package:user/app/backend/parse/loyalty_points_parse.dart';

class LoyaltyPointsController extends GetxController {
  final LoyaltyPointsParser parser;

  bool apiCalled = false;
  int points = 0;
  List<LoyaltyHistoryModel> loyaltyHistory = [];

  LoyaltyPointsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getLoyaltyPoints();
  }

  Future<void> getLoyaltyPoints() async {
    var response = await parser.getLoyaltyPoints();
    apiCalled = true;
    if (response.statusCode == 200) {
      var body = response.body;
      points = body['points'];
      // loyaltyHistory = List<LoyaltyHistoryModel>.from(
      //   body['history'].map((x) => LoyaltyHistoryModel.fromJson(x)),
      // );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
