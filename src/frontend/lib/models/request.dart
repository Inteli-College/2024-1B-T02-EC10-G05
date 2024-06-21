import 'package:flutter/foundation.dart';

class Request {
  final String id;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;
  final bool? isUrgent;
  final String? description;
  final String? status;
  final String? messages;
  final String? productName;
  final String? productCode;
  

  Request({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isUrgent,
    required this.description,
    required this.status,
    required this.messages,
    required this.productName,
    required this.productCode,

  });

  // // Método para converter um JSON em uma instância de Request
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['ID'] as String,
      createdAt: json['CreatedAt'] as String,
      updatedAt: json['UpdatedAt'] as String,
      userId: json['UserId'] as String,
      isUrgent: json['IsUrgent'] as bool,
      description: json['Description'] as String,
      status: json['Status'] as String,
      messages: json['Messages'] as String,
      productName: json['Name'] as String,
      productCode: json['productCode'] as String,

    );
  }

  // Método para converter uma instância de Request em um JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CreatedAt': createdAt,
      'UpdateAt': updatedAt,
      'UserId': userId,
      'IsUrgent': isUrgent,
      'Description': description,
      'Messages': messages,
      'Status': status,
      'productCode': productCode,
    };
  }
}
