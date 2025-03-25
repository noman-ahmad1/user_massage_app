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
import 'package:user/app/controller/languages_controller.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Languages'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                for (var language in AppConstants.languages)
                  ListTile(
                    title: Text(language.languageName),
                    leading: Radio(
                      value: language.languageCode,
                      groupValue: value.languageCode,
                      onChanged: (e) => value.saveLanguages(e.toString()),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
