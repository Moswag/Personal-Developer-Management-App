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
  String description;
  String date;


  Idea({
    this.description,
    this.date,
  });

  factory Idea.fromJson(Map<String, dynamic> json) => new Idea(
      description: json["description"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "date": date

  };

  factory Idea.fromDocument(DocumentSnapshot doc) {
    return Idea.fromJson(doc.data);
  }
}
