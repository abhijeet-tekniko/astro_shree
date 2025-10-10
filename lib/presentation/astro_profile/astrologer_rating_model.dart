import 'package:astro_shree_user/core/network/endpoints.dart';

class RatingsResponse {
  final bool status;
  final String message;
  final RatingsData data;

  RatingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RatingsResponse.fromJson(Map<String, dynamic> json) {
    return RatingsResponse(
      status: json['status'],
      message: json['message'],
      data: RatingsData.fromJson(json['data']),
    );
  }
}

class RatingsData {
  final List<Rating> ratings;
  final Pagination pagination;

  RatingsData({
    required this.ratings,
    required this.pagination,
  });

  factory RatingsData.fromJson(Map<String, dynamic> json) {
    return RatingsData(
      ratings:
          List<Rating>.from(json['ratings'].map((x) => Rating.fromJson(x))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Rating {
  final String id;
 var rating;
  var comment;
  final User user;
  final String astrologer;
  final bool isActive;
  final DateTime createdAt;
  final int v;

  Rating({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
    required this.astrologer,
    required this.isActive,
    required this.createdAt,
    required this.v,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'],
      rating: json['rating'],
      comment: json['comment'],
      user: User.fromJson(json['user']),
      astrologer: json['astrologer'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      v: json['__v'],
    );
  }
}

class User {
  final String id;
  final String profileImage;
  final String name;

  User({
    required this.id,
    required this.profileImage,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      profileImage: EndPoints.imageBaseUrl + json['profileImage'],
      name: json['name'],
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}
