// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) => HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  final String? msg;
  final bool? status;
  final HomePageDataModel? data;

  HomePageModel({
    this.msg,
    this.status,
    this.data,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : HomePageDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class HomePageDataModel {
  final UserInfo? userInfo;
  final List<SliderModel>? slider;
  final int? leadsCount;
  final int? depositAmount;
  final String? totalEarning;
  final String? qFormLink;

  HomePageDataModel({
    this.userInfo,
    this.slider,
    this.leadsCount,
    this.depositAmount,
    this.totalEarning,
    this.qFormLink,
  });

  factory HomePageDataModel.fromJson(Map<String, dynamic> json) => HomePageDataModel(
    userInfo: json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]),
    slider: json["slider"] == null ? [] : List<SliderModel>.from(json["slider"]!.map((x) => SliderModel.fromJson(x))),
    leadsCount: json["leads_count"],
    depositAmount: json["deposit_amount"],
    totalEarning: json["total_earning"],
    qFormLink: json["q_form_link"],
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo?.toJson(),
    "slider": slider == null ? [] : List<dynamic>.from(slider!.map((x) => x.toJson())),
    "leads_count": leadsCount,
    "deposit_amount": depositAmount,
    "total_earning": totalEarning,
    "q_form_link": qFormLink,
  };
}

class SliderModel {
  final ImgInfo? imgInfo;
  final String? img;

  SliderModel({
    this.imgInfo,
    this.img,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    imgInfo: json["img_info"] == null ? null : ImgInfo.fromJson(json["img_info"]),
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "img_info": imgInfo?.toJson(),
    "img": img,
  };
}

class ImgInfo {
  final int? id;
  final String? imgTitle;
  final int? awsMediaId;
  final int? companyId;
  final String? imgDescription;
  final int? status;
  final dynamic officeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ImgInfo({
    this.id,
    this.imgTitle,
    this.awsMediaId,
    this.companyId,
    this.imgDescription,
    this.status,
    this.officeId,
    this.createdAt,
    this.updatedAt,
  });

  factory ImgInfo.fromJson(Map<String, dynamic> json) => ImgInfo(
    id: json["id"],
    imgTitle: json["img_title"],
    awsMediaId: json["aws_media_id"],
    companyId: json["company_id"],
    imgDescription: json["img_description"],
    status: json["status"],
    officeId: json["office_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img_title": imgTitle,
    "aws_media_id": awsMediaId,
    "company_id": companyId,
    "img_description": imgDescription,
    "status": status,
    "office_id": officeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class UserInfo {
  final int? agentId;
  final String? name;
  final String? email;
  final int? status;
  final int? subAgentInfoId;
  final int? officeId;
  final int? companyId;
  final int? phoneCountryId;
  final String? phone;
  final String? mobile;
  final int? country;
  final String? city;
  final String? sourceOccupation;
  final int? estimateEarning;
  final String? currency;

  UserInfo({
    this.agentId,
    this.name,
    this.email,
    this.status,
    this.subAgentInfoId,
    this.officeId,
    this.companyId,
    this.phoneCountryId,
    this.phone,
    this.mobile,
    this.country,
    this.city,
    this.sourceOccupation,
    this.estimateEarning,
    this.currency,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    agentId: json["agent_id"],
    name: json["name"],
    email: json["email"],
    status: json["status"],
    subAgentInfoId: json["sub_agent_info_id"],
    officeId: json["office_id"],
    companyId: json["company_id"],
    phoneCountryId: json["phone_country_id"],
    phone: json["phone"],
    mobile: json["mobile"],
    country: json["country"],
    city: json["city"],
    sourceOccupation: json["source_occupation"],
    estimateEarning: json["estimate_earning"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "agent_id": agentId,
    "name": name,
    "email": email,
    "status": status,
    "sub_agent_info_id": subAgentInfoId,
    "office_id": officeId,
    "company_id": companyId,
    "phone_country_id": phoneCountryId,
    "phone": phone,
    "mobile": mobile,
    "country": country,
    "city": city,
    "source_occupation": sourceOccupation,
    "estimate_earning": estimateEarning,
    "currency": currency,
  };
}
