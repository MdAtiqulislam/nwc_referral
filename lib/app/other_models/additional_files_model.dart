/*


import 'dart:convert';

AdditionalFileListModel additionalFileListModelFromJson(String str) => AdditionalFileListModel.fromJson(json.decode(str));

String additionalFileListModelToJson(AdditionalFileListModel data) => json.encode(data.toJson());

class AdditionalFileListModel {
  final String? msg;
  final bool? status;
  final Data? data;

  AdditionalFileListModel({
    this.msg,
    this.status,
    this.data,
  });

  factory AdditionalFileListModel.fromJson(Map<String, dynamic> json) => AdditionalFileListModel(
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
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;
  final String? path;
  final int? from;
  final int? to;
  final List<Datum>? data;

  Data({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.from,
    this.to,
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    firstPageUrl: json["first_page_url"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
    path: json["path"],
    from: json["from"],
    to: json["to"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
    "path": path,
    "from": from,
    "to": to,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? fileName;
  final dynamic comments;
  final dynamic fileUrl;

  Datum({
    this.id,
    this.fileName,
    this.comments,
    this.fileUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    fileName: json["file_name"],
    comments: json["comments"],
    fileUrl: json["file_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_name": fileName,
    "comments": comments,
    "file_url": fileUrl,
  };
}
*/

// To parse this JSON data, do
//
//     final additionalFileListModel = additionalFileListModelFromJson(jsonString);

import 'dart:convert';

AdditionalFileListModel additionalFileListModelFromJson(String str) => AdditionalFileListModel.fromJson(json.decode(str));

String additionalFileListModelToJson(AdditionalFileListModel data) => json.encode(data.toJson());

class AdditionalFileListModel {
  final String? msg;
  final bool? status;
  final AdditionalFileListData? data;

  AdditionalFileListModel({
    this.msg,
    this.status,
    this.data,
  });

  factory AdditionalFileListModel.fromJson(Map<String, dynamic> json) => AdditionalFileListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : AdditionalFileListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class AdditionalFileListData {
  final FileList? fileList;
  final SingleFile? cv;
  final SingleFile? passport;
  final SingleFile? academicDoc;

  AdditionalFileListData({
    this.fileList,
    this.cv,
    this.passport,
    this.academicDoc
  });

  factory AdditionalFileListData.fromJson(Map<String, dynamic> json) => AdditionalFileListData(
    fileList: json["file_list"] == null ? null : FileList.fromJson(json["file_list"]),
    cv: json["cv"] == null ? null : SingleFile.fromJson(json["cv"]),
    passport: json["passport"] == null ? null : SingleFile.fromJson(json["passport"]),
    academicDoc: json["academic_doc"] == null ? null : SingleFile.fromJson(json["academic_doc"]),
  );

  Map<String, dynamic> toJson() => {
    "file_list": fileList?.toJson(),
    "cv": cv?.toJson(),
    "passport": passport?.toJson(),
    "academic_doc": academicDoc?.toJson(),
  };
}

class SingleFile {
  final int? id;
  final String? fileName;
  final dynamic comments;
  final dynamic fileUrl;
  final String? createdAt;

  SingleFile({
    this.id,
    this.fileName,
    this.comments,
    this.fileUrl,
    this.createdAt,
  });

  factory SingleFile.fromJson(Map<String, dynamic> json) => SingleFile(
    id: json["id"],
    fileName: json["file_name"],
    comments: json["comments"],
    fileUrl: json["file_url"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_name": fileName,
    "comments": comments,
    "file_url": fileUrl,
    "created_at": createdAt,
  };
}

class FileList {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;
  final String? path;
  final int? from;
  final int? to;
  final List<SingleFile>? data;

  FileList({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.from,
    this.to,
    this.data,
  });

  factory FileList.fromJson(Map<String, dynamic> json) => FileList(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    firstPageUrl: json["first_page_url"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
    path: json["path"],
    from: json["from"],
    to: json["to"],
    data: json["data"] == null ? [] : List<SingleFile>.from(json["data"]!.map((x) => SingleFile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
    "path": path,
    "from": from,
    "to": to,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
