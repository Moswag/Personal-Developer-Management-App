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
  double balance;
  double allTransactionAmounts;
  String date;

  CompanyAccount({
    this.userId,
    this.balance,
    this.allTransactionAmounts,
    this.date
  });

  factory CompanyAccount.fromJson(Map<String, dynamic> json) => new CompanyAccount(
      userId: json["userId"],
      balance: json["balance"],
      allTransactionAmounts: json["allTransactionAmounts"],
      date: json["date"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "balance": balance,
    "allTransactionAmounts":allTransactionAmounts,
    "date": date

  };

  factory CompanyAccount.fromDocument(DocumentSnapshot doc) {
    return CompanyAccount.fromJson(doc.data);
  }
}
