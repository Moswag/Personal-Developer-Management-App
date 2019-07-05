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
  String title;
  String description;
  String documentUrl;
  String price;
  String status;

  Proposal({
    this.userId,
    this.title,
    this.description,
    this.documentUrl,
    this.price,
    this.status
  });

  factory Proposal.fromJson(Map<String, dynamic> json) => new Proposal(
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      documentUrl: json["documentUrl"],
      price: json["price"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "title": title,
    "description": description,
    "documentUrl": documentUrl,
    "price": price,
    "status":status

  };

  factory Proposal.fromDocument(DocumentSnapshot doc) {
    return Proposal.fromJson(doc.data);
  }
}
