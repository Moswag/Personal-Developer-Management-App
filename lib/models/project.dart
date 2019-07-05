import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Project projectFromJson(String str) {
  final jsonData = json.decode(str);
  return Project.fromJson(jsonData);
}

String projectToJson(Project data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Project {
  String userId;
  String id;
  String name;
  String client;
  String documentationUrl;
  double amount;
  String tools;
  String status;
  String nature;
  String startDate;
  String endDate;

  Project({
    this.userId,
    this.id,
    this.name,
    this.client,
    this.documentationUrl,
    this.amount,
    this.tools,
    this.status,
    this.nature,
    this.startDate,
    this.endDate
  });

  factory Project.fromJson(Map<String, dynamic> json) => new Project(
      userId: json["userId"],
      id: json["id"],
      name: json["name"],
      client: json["client"],
      documentationUrl: json["documentationUrl"],
      amount: json["amount"],
      tools: json["tools"],
      status: json["status"],
      nature: json["nature"],
      startDate: json["startDate"],
      endDate: json["endDate"]

  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "name": name,
    "client": client,
    "email": documentationUrl,
    "amount":amount,
    "tools": tools,
    "status": status,
    "nature": nature,
    "startDate": startDate,
    "endDate":endDate

  };

  factory Project.fromDocument(DocumentSnapshot doc) {
    return Project.fromJson(doc.data);
  }
}
