// To parse this JSON data, do
//
//     final contactUsModel = contactUsModelFromJson(jsonString);

import 'dart:convert';

ContactUsModel contactUsModelFromJson(String str) => ContactUsModel.fromJson(json.decode(str));

String contactUsModelToJson(ContactUsModel data) => json.encode(data.toJson());

class ContactUsModel {
  final String? msg;
  final bool? status;
  final Data? data;

  ContactUsModel({
    this.msg,
    this.status,
    this.data,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  final String? aboutUsText;
  final ContactInfo? contactInfo;

  Data({
    this.aboutUsText,
    this.contactInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    aboutUsText: json["about_us_text"],
    contactInfo: json["contact_info"] == null ? null : ContactInfo.fromJson(json["contact_info"]),
  );

  Map<String, dynamic> toJson() => {
    "about_us_text": aboutUsText,
    "contact_info": contactInfo?.toJson(),
  };
}

class ContactInfo {
  final String? name;
  final String? mob;
  final String? whatsApp;
  final String? address;

  ContactInfo({
    this.name,
    this.mob,
    this.whatsApp,
    this.address,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
    name: json["name"],
    mob: json["mob"],
    whatsApp: json["whats_app"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mob": mob,
    "whats_app": whatsApp,
    "address": address,
  };
}
