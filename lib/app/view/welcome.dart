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
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const Image(image: AssetImage('assets/images/splash.jpg'), fit: BoxFit.cover, height: double.infinity, width: double.infinity, alignment: Alignment.center),
          Positioned(
            bottom: 20,
            child: Column(
              children: [
                const Image(image: AssetImage('assets/images/logo_white.png'), fit: BoxFit.cover, height: 50, width: 50, alignment: Alignment.center),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text('Book an Appointment for therapist, Spa & massage center.'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 18)),
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.red),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: ThemeProvider.whiteColor),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                    ),
                    onPressed: () => {},
                    icon: const Icon(Icons.lock_outline, color: ThemeProvider.whiteColor),
                    label: Text('Connect with Google'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                  ),
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: ThemeProvider.appColor),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: ThemeProvider.whiteColor),
                      backgroundColor: ThemeProvider.secondaryAppColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                    ),
                    onPressed: () => {},
                    icon: const Icon(Icons.lock_outline, color: ThemeProvider.whiteColor),
                    label: Text('Connect with Facebook'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: <TextSpan>[TextSpan(text: ' Sign In'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14))],
                    ),
                  ),
                  onTap: () => Get.toNamed(AppRouter.getLoginRoute()),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
