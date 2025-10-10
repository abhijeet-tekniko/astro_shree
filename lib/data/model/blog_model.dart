class BlogResponse {
  final bool status;
  final String message;
  final List<Blog> data;

  BlogResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      status: json['status'],
      message: json['message'],
      data: List<Blog>.from(json['data'].map((x) => Blog.fromJson(x))),
    );
  }
}

class Blog {
  final String id;
  final String title;
  final String description;
  final String thumbImage;
  final List<String> image;
  final bool status;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbImage,
    required this.image,
    required this.status,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    String base = "http://167.71.232.245:4856/";
    return Blog(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      thumbImage: base+json['thumbImage'],
      image: List<String>.from(json['image']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
