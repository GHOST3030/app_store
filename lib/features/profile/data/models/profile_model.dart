// profile/data/models/profile_model.dart
import 'package:new_auth/features/profile/logic/entities/profile_entity.dart';

class ProfileModel {
  final String id;
  final String email;
  final String password;
  final String address;
  final String city;
  final String country;
  final String pincode;
  final String bankAccountNumber;
  final String accountHolderName;
  final String ifscCode;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.email,
    required this.password,
    required this.address,
    required this.city,
    required this.country,
    required this.pincode,
    required this.bankAccountNumber,
    required this.accountHolderName,
    required this.ifscCode,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'address': address,
      'city': city,
      'country': country,
      'pincode': pincode,
      'bankAccountNumber': bankAccountNumber,
      'accountHolderName': accountHolderName,
      'ifscCode': ifscCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      pincode: json['pincode'] as String,
      bankAccountNumber: json['bankAccountNumber'] as String,
      accountHolderName: json['accountHolderName'] as String,
      ifscCode: json['ifscCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      password: password,
      address: address,
      city: city,
      country: country,
      pincode: pincode,
      bankAccountNumber: bankAccountNumber,
      accountHolderName: accountHolderName,
      ifscCode: ifscCode,
      createdAt: createdAt,
    );
  }
}