import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Disturbance userFromJson(String str) {
  final jsonData = json.decode(str);
  return Disturbance.fromJson(jsonData);
}

String userToJson(Disturbance data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Disturbance {
  String userId;
  String id;
  String description;
  String date;
  String startTime;
  String timeClosed;

  Disturbance({
    this.userId,
    this.id,
    this.description,
    this.date,
    this.startTime,
    this.timeClosed
  });

  factory Disturbance.fromJson(Map<String, dynamic> json) => new Disturbance(
      userId: json["userId"],
      id: json["id"],
      description: json["description"],
      date: json["date"],
      startTime: json["startTime"],
      timeClosed: json["timeClosed"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "description": description,
    "date": date,
    "startTime": startTime,
    "timeClosed":timeClosed

  };

  factory Disturbance.fromDocument(DocumentSnapshot doc) {
    return Disturbance.fromJson(doc.data);
  }
}
