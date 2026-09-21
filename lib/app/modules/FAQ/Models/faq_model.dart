// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  final String? msg;
  final bool? status;
  final FAQData? data;

  FaqModel({
    this.msg,
    this.status,
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : FAQData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class FAQData {
  final List<Faq>? faq;

  FAQData({
    this.faq,
  });

  factory FAQData.fromJson(Map<String, dynamic> json) => FAQData(
    faq: json["faq"] == null ? [] : List<Faq>.from(json["faq"]!.map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "faq": faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
  };
}

class Faq {
  final String? question;
  final String? ans;

  Faq({
    this.question,
    this.ans,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    question: json["question"],
    ans: json["ans"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "ans": ans,
  };
}
