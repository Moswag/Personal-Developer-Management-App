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
  String id;
  String nature;
  String client;
  String businessId;
  double amount;
  String date;


  Payment({
    this.userId,
    this.id,
    this.nature,
    this.client,
    this.businessId,
    this.amount,
    this.date,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => new Payment(
      userId: json["userId"],
      id: json["id"],
      nature: json["nature"],
      client: json["client"],
      businessId: json["businessId"],
      amount: json["amount"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id":id,
    "nature":nature,
    "client": client,
    "businessId": businessId,
    "amount": amount,
    "date": date,
  };

  factory Payment.fromDocument(DocumentSnapshot doc) {
    return Payment.fromJson(doc.data);
  }
}
