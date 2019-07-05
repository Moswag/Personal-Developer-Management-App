import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Todo userFromJson(String str) {
  final jsonData = json.decode(str);
  return Todo.fromJson(jsonData);
}

String userToJson(Todo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Todo {
  String userId;
  String id;
  String description;
  String date;
  String status;

  Todo({
    this.userId,
    this.id,
    this.description,
    this.date,
    this.status
  });

  factory Todo.fromJson(Map<String, dynamic> json) => new Todo(
      userId: json["userId"],
      id: json["id"],
      description: json["description"],
      date: json["date"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "description": description,
    "date": date,
    "status":status

  };

  factory Todo.fromDocument(DocumentSnapshot doc) {
    return Todo.fromJson(doc.data);
  }
}
