import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Business businessFromJson(String str) {
  final jsonData = json.decode(str);
  return Business.fromJson(jsonData);
}

String businessToJson(Business data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Business {
  String userId;
  String id;
  String client;
  double amount;
  String nature;
  String date;
  double balance;

  Business({
    this.userId,
    this.id,
    this.client,
    this.amount,
    this.nature,
    this.date,
    this.balance
  });

  factory Business.fromJson(Map<String, dynamic> json) => new Business(
      userId: json["userId"],
      id: json["id"],
      client: json["client"],
      amount: json["amount"],
      nature: json["nature"],
      date: json["date"],
      balance: json["balance"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "client": client,
    "amount": amount,
    "nature": nature,
    "date":date,
    "balance":balance

  };

  factory Business.fromDocument(DocumentSnapshot doc) {
    return Business.fromJson(doc.data);
  }
}
