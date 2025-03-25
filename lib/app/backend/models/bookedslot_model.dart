/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
class BookedSlotModel {
  String? slot;
  BookedSlotModel({this.slot});
  BookedSlotModel.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot'] = slot;
    return data;
  }
}
