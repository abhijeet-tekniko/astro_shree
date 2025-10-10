import 'package:astro_shree_user/core/network/endpoints.dart';

class ProfileResponse {
  final bool status;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final User user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  Wallet? wallet;
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;
  final String profileImage;
  final String maritalStatus;
  final bool status;
  final DateTime createdAt;
  final int v;

  User({
    required this.wallet,
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.profileImage,
    required this.maritalStatus,
    required this.status,
    required this.createdAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      wallet:
          json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null,
      id: json['_id'] ?? '',
      mobile: json['mobile'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dob'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      timeOfBirth: json['birthTime'] ?? '',
      profileImage: json['profileImage'] != null
          ? EndPoints.base + json['profileImage']
          : '',
      maritalStatus: json['maritalStatus'] ?? '',
      status: json['status'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      v: json['__v'] ?? 0,
    );
  }
}

class Wallet {
  var balance;
  var lockedBalance;

  Wallet({this.balance, this.lockedBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    lockedBalance = json['lockedBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['lockedBalance'] = this.lockedBalance;
    return data;
  }
}
