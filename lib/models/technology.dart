import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Technology userFromJson(String str) {
  final jsonData = json.decode(str);
  return Technology.fromJson(jsonData);
}

String userToJson(Technology data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Technology {
  String userId;
  String id;
  String name;
  String description;
  int numberOfUse;

  Technology({
    this.userId,
    this.id,
    this.name,
    this.description,
    this.numberOfUse
  });

  factory Technology.fromJson(Map<String, dynamic> json) => new Technology(
      userId: json["userId"],
      id: json["id"],
      name: json["name"],
      description: json["description"],
      numberOfUse: json["numberOfUse"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "name": name,
    "description": description,
    "numberOfUse":numberOfUse

  };

  factory Technology.fromDocument(DocumentSnapshot doc) {
    return Technology.fromJson(doc.data);
  }
}
