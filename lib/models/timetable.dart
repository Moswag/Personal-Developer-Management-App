import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Timetable timetableFromJson(String str) {
  final jsonData = json.decode(str);
  return Timetable.fromJson(jsonData);
}

String timetableToJson(Timetable data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Timetable {
  String userId;
  String id;
  String day;
  String time;
  String activity;
  String nature;  //regular or tight

  Timetable({
    this.userId,
    this.id,
    this.day,
    this.time,
    this.activity,
    this.nature
  });

  factory Timetable.fromJson(Map<String, dynamic> json) => new Timetable(
      userId: json["userId"],
      id: json["id"],
      day: json["day"],
      time: json["time"],
      activity: json["activity"],
      nature: json["nature"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "day": day,
    "time": time,
    "activity": activity,
    "nature":nature

  };

  factory Timetable.fromDocument(DocumentSnapshot doc) {
    return Timetable.fromJson(doc.data);
  }
}
