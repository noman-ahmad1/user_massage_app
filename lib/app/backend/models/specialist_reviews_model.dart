/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
class SpecialistReviewsModel {
  int? id;
  int? uid;
  String? specialistId;
  String? notes;
  double? rating;
  int? status;
  String? extraField;
  String? createdAt;
  User? user;

  SpecialistReviewsModel({this.id, this.uid, this.specialistId, this.notes, this.rating, this.status, this.extraField, this.createdAt, this.user});

  SpecialistReviewsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    specialistId = json['freelancer_id'];
    notes = json['notes'];
    rating = double.parse(json['rating'].toString());
    status = int.parse(json['status'].toString());
    extraField = json['extra_field'];
    createdAt = json['created_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['specialist_id'] = specialistId;
    data['notes'] = notes;
    data['rating'] = rating;
    data['status'] = status;
    data['extra_field'] = extraField;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? cover;
  String? firstName;
  String? lastName;

  User({this.id, this.cover, this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    cover = json['cover'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cover'] = cover;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
