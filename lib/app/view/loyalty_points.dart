import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/loyalty_points_controller.dart';
import 'package:user/app/util/theme.dart';

class LoyaltyPointsScreen extends StatefulWidget {
  const LoyaltyPointsScreen({super.key});

  @override
  State<LoyaltyPointsScreen> createState() => _LoyaltyPointsScreenState();
}

class _LoyaltyPointsScreenState extends State<LoyaltyPointsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyPointsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Loyalty Points'.tr, style: ThemeProvider.titleStyle),
            bottom: value.apiCalled == true
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      width: double.infinity,
                      color: ThemeProvider.whiteColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${value.points} pts',
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'bold',
                                color: ThemeProvider.appColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Loyalty Points Available'.tr,
                              style: const TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: ThemeProvider.appColor,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: ThemeProvider.appColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      value.loyaltyHistory.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.loyaltyHistory[index].description,
                                  style: const TextStyle(fontFamily: 'bold', fontSize: 12),
                                ),
                                Text(
                                  value.loyaltyHistory[index].uuid,
                                  style: const TextStyle(fontFamily: 'regular', fontSize: 10),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${value.loyaltyHistory[index].points} pts',
                                  style: const TextStyle(fontSize: 12, fontFamily: 'bold'),
                                ),
                                Text(
                                  value.loyaltyHistory[index].createdAt,
                                  style: const TextStyle(fontFamily: 'regular', fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
