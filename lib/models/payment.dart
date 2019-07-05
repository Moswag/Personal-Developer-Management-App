import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Payment paymentFromJson(String str) {
  final jsonData = json.decode(str);
  return Payment.fromJson(jsonData);
}

String paymentToJson(Payment data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Payment {
  String userId;
  String client;
  String amount;
  String date;


  Payment({
    this.userId,
    this.client,
    this.amount,
    this.date,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => new Payment(
      userId: json["userId"],
      client: json["client"],
      amount: json["amount"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "client": client,
    "amount": amount,
    "date": date,

  };

  factory Payment.fromDocument(DocumentSnapshot doc) {
    return Payment.fromJson(doc.data);
  }
}
