import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Idea ideaFromJson(String str) {
  final jsonData = json.decode(str);
  return Idea.fromJson(jsonData);
}

String ideaToJson(Idea data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Idea {
  String userId;
  String id;
  String idea;
  String date;


  Idea({
    this.userId,
    this.id,
    this.idea,
    this.date,
  });

  factory Idea.fromJson(Map<String, dynamic> json) => new Idea(
    userId: json["userId"],
      id: json["id"],
      idea: json["idea"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId":userId,
    "id":id,
    "idea": idea,
    "date": date

  };

  factory Idea.fromDocument(DocumentSnapshot doc) {
    return Idea.fromJson(doc.data);
  }
}
