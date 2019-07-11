import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Proposal proposalFromJson(String str) {
  final jsonData = json.decode(str);
  return Proposal.fromJson(jsonData);
}

String proposalToJson(Proposal data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Proposal {
  String userId;
  String id;
  String title;
  String description;
  String documentUrl;
  double amount;
  String status;

  Proposal({
    this.userId,
    this.id,
    this.title,
    this.description,
    this.documentUrl,
    this.amount,
    this.status
  });

  factory Proposal.fromJson(Map<String, dynamic> json) => new Proposal(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      description: json["description"],
      documentUrl: json["documentUrl"],
      amount: json["amount"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "description": description,
    "documentUrl": documentUrl,
    "amount": amount,
    "status":status

  };

  factory Proposal.fromDocument(DocumentSnapshot doc) {
    return Proposal.fromJson(doc.data);
  }
}
