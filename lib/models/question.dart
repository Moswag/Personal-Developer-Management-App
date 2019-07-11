import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Question userFromJson(String str) {
  final jsonData = json.decode(str);
  return Question.fromJson(jsonData);
}

String userToJson(Question data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Question {
  String userId;
  String id;
  String question;
  String answer;
  String date;
  String status;

  Question({
    this.userId,
    this.id,
    this.question,
    this.answer,
    this.date,
    this.status
  });

  factory Question.fromJson(Map<String, dynamic> json) => new Question(
      userId: json["userId"],
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      date: json["date"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "question": question,
    "answer": answer,
    "date": date,
    "status": status

  };

  factory Question.fromDocument(DocumentSnapshot doc) {
    return Question.fromJson(doc.data);
  }
}
