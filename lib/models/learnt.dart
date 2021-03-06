import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Learnt learntFromJson(String str) {
  final jsonData = json.decode(str);
  return Learnt.fromJson(jsonData);
}

String learntToJson(Learnt data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Learnt {
  String userId;
  String id;
  String description;
  String question;
  String date;

  Learnt({
    this.userId,
    this.id,
    this.description,
    this.question,
    this.date
  });

  factory Learnt.fromJson(Map<String, dynamic> json) => new Learnt(
      userId: json["userId"],
      id: json["id"],
      description: json["description"],
      question: json["question"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "description": description,
    "question": question,
    "date": date

  };

  factory Learnt.fromDocument(DocumentSnapshot doc) {
    return Learnt.fromJson(doc.data);
  }
}
