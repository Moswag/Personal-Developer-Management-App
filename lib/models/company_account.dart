import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

CompanyAccount accountFromJson(String str) {
  final jsonData = json.decode(str);
  return CompanyAccount.fromJson(jsonData);
}

String accountToJson(CompanyAccount data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CompanyAccount {
  String userId;
  String balance;
  String date;

  CompanyAccount({
    this.userId,
    this.balance,
    this.date
  });

  factory CompanyAccount.fromJson(Map<String, dynamic> json) => new CompanyAccount(
      userId: json["userId"],
      balance: json["balance"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "balance": balance,
    "date": date

  };

  factory CompanyAccount.fromDocument(DocumentSnapshot doc) {
    return CompanyAccount.fromJson(doc.data);
  }
}
