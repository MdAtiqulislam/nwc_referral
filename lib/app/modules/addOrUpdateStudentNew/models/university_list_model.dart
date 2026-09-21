// To parse this JSON data, do
//
//     final universityListModel = universityListModelFromJson(jsonString);

import 'dart:convert';

UniversityListModel universityListModelFromJson(String str) => UniversityListModel.fromJson(json.decode(str));

String universityListModelToJson(UniversityListModel data) => json.encode(data.toJson());

class UniversityListModel {
  final String? msg;
  final bool? status;
  final UniversityListData? data;

  UniversityListModel({
    this.msg,
    this.status,
    this.data,
  });

  factory UniversityListModel.fromJson(Map<String, dynamic> json) => UniversityListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : UniversityListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class UniversityListData {
  final List<SingleUniversity>? uniData;

  UniversityListData({
    this.uniData,
  });

  factory UniversityListData.fromJson(Map<String, dynamic> json) => UniversityListData(
    uniData: json["uni_data"] == null ? [] : List<SingleUniversity>.from(json["uni_data"]!.map((x) => SingleUniversity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uni_data": uniData == null ? [] : List<dynamic>.from(uniData!.map((x) => x.toJson())),
  };
}

class SingleUniversity {
  final int? id;
  final String? name;
  final String? address;

  SingleUniversity({
    this.id,
    this.name,
    this.address,
  });

  factory SingleUniversity.fromJson(Map<String, dynamic> json) => SingleUniversity(
    id: json["id"],
    name: json["name"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
  };
}
