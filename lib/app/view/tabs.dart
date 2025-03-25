/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/view/account.dart';
import 'package:user/app/view/booking.dart';
import 'package:user/app/view/categories.dart';
import 'package:user/app/view/home.dart';
import 'package:user/app/view/near.dart';
import 'package:badges/badges.dart' as badges;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: (TabBar(
            controller: value.tabController,
            labelColor: ThemeProvider.appColor,
            unselectedLabelColor: const Color.fromARGB(255, 185, 196, 207),
            indicatorColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            labelStyle: const TextStyle(fontFamily: 'regular', fontSize: 12),
            onTap: (int index) => value.updateTabId(index),
            tabs: [
              Tab(
                icon: Icon(value.tabId != 0 ? Icons.home_outlined : Icons.home_sharp, color: value.tabId == 0 ? ThemeProvider.appColor : const Color.fromARGB(255, 185, 196, 207)),
                text: 'Home'.tr,
              ),
              Tab(
                icon: Icon(value.tabId != 1 ? Icons.location_on_outlined : Icons.location_on, color: value.tabId == 1 ? ThemeProvider.appColor : const Color.fromARGB(255, 185, 196, 207)),
                text: 'NearBy'.tr,
              ),
              Tab(
                icon: value.cartTotal > 0
                    ? badges.Badge(
                        badgeStyle: const badges.BadgeStyle(badgeColor: ThemeProvider.appColor),
                        badgeContent: Text(value.cartTotal.toString(), style: const TextStyle(color: ThemeProvider.whiteColor)),
                        child: Icon(
                          value.tabId != 2 ? Icons.shopping_cart_outlined : Icons.shopping_cart,
                          color: value.tabId == 2 ? ThemeProvider.appColor : ThemeProvider.greyColor,
                        ),
                      )
                    : Icon(
                        value.tabId != 2 ? Icons.shopping_cart_outlined : Icons.shopping_cart,
                        color: value.tabId == 2 ? ThemeProvider.appColor : const Color.fromARGB(255, 185, 196, 207),
                      ),
                text: 'Shop'.tr,
              ),
              Tab(
                icon: Icon(value.tabId != 3 ? Icons.calendar_today_outlined : Icons.calendar_today, color: value.tabId == 3 ? ThemeProvider.appColor : const Color.fromARGB(255, 185, 196, 207)),
                text: 'Appoinment'.tr,
              ),
              Tab(
                icon: Icon(value.tabId != 4 ? Icons.account_circle_outlined : Icons.account_circle, color: value.tabId == 4 ? ThemeProvider.appColor : const Color.fromARGB(255, 185, 196, 207)),
                text: 'Account'.tr,
              ),
            ],
          )),
          body: TabBarView(
            controller: value.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [HomeScreen(), NearScreen(), CategoriesScreen(), BookingScreen(), AccountScreen()],
          ),
        ),
      );
    });
  }
}
