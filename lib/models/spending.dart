import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Spending userFromJson(String str) {
  final jsonData = json.decode(str);
  return Spending.fromJson(jsonData);
}

String userToJson(Spending data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Spending {
  String userId;
  String id;
  String reason;
  double amount;
  String date;
  String time;


  Spending({
    this.userId,
    this.id,
    this.reason,
    this.amount,
    this.date,
    this.time
  });

  factory Spending.fromJson(Map<String, dynamic> json) => new Spending(
      userId: json["userId"],
      id: json["id"],
      reason: json["reason"],
      amount: json["amount"],
      date: json["date"],
      time: json["time"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "reason": reason,
    "amount": amount,
    "date": date,
    "time": time
  };

  factory Spending.fromDocument(DocumentSnapshot doc) {
    return Spending.fromJson(doc.data);
  }
}
