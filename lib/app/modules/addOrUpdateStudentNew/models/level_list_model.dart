// To parse this JSON data, do
//
//     final levelListModel = levelListModelFromJson(jsonString);

import 'dart:convert';

LevelListModel levelListModelFromJson(String str) => LevelListModel.fromJson(json.decode(str));

String levelListModelToJson(LevelListModel data) => json.encode(data.toJson());

class LevelListModel {
  final String? msg;
  final bool? status;
  final LevelData? data;

  LevelListModel({
    this.msg,
    this.status,
    this.data,
  });

  factory LevelListModel.fromJson(Map<String, dynamic> json) => LevelListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : LevelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class LevelData {
  final List<SingleCourse>? coursesData;

  LevelData({
    this.coursesData,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) => LevelData(
    coursesData: json["courses_data"] == null ? [] : List<SingleCourse>.from(json["courses_data"]!.map((x) => SingleCourse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "courses_data": coursesData == null ? [] : List<dynamic>.from(coursesData!.map((x) => x.toJson())),
  };
}

class SingleCourse {
  final int? id;
  final String? name;
  final String? shortName;

  SingleCourse({
    this.id,
    this.name,
    this.shortName,
  });

  factory SingleCourse.fromJson(Map<String, dynamic> json) => SingleCourse(
    id: json["id"],
    name: json["name"],
    shortName: json["short_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_name": shortName,
  };
}
