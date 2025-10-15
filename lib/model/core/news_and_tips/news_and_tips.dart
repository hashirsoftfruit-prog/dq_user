class NewsAndTips {
  bool? status;
  String? message;
  List<News>? news;
  List<Tip>? tips;

  NewsAndTips({this.status, this.message, this.news, this.tips});

  factory NewsAndTips.fromJson(Map<String, dynamic> json) => NewsAndTips(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        news: (json['news'] as List<dynamic>?)
            ?.map((e) => News.fromJson(e as Map<String, dynamic>))
            .toList(),
        tips: (json['tips'] as List<dynamic>?)
            ?.map((e) => Tip.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'news': news?.map((e) => e.toJson()).toList(),
        'tips': tips?.map((e) => e.toJson()).toList(),
      };
}

class News {
  int? id;
  String? image;
  String? title;
  String? subtitle;
  String? description;
  String? publishedDate;
  String? authorName;
  String? authorImage;
  String? authorTag;

  News({
    this.id,
    this.image,
    this.title,
    this.subtitle,
    this.description,
    this.publishedDate,
    this.authorName,
    this.authorImage,
    this.authorTag,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json['id'] as int?,
        image: json['image'] as String?,
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?,
        description: json['description'] as String?,
        publishedDate: json['published_date'] as String?,
        authorName: json['author_name'] as String?,
        authorImage: json['author_image'] as String?,
        authorTag: json['author_tag'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'published_date': publishedDate,
        'author_name': authorName,
        'author_image': authorImage,
        'author_tag': authorTag,
      };
}

class Tip {
  int? id;
  String? image;
  String? title;
  String? subtitle;
  String? description;
  String? publishedDate;
  String? authorName;
  String? authorImage;
  String? authorTag;

  Tip({
    this.id,
    this.image,
    this.title,
    this.subtitle,
    this.description,
    this.publishedDate,
    this.authorName,
    this.authorImage,
    this.authorTag,
  });

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        id: json['id'] as int?,
        image: json['image'] as String,
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?,
        description: json['description'] as String?,
        publishedDate: json['published_date'] as String?,
        authorName: json['author_name'] as String?,
        authorImage: json['author_image'] as String?,
        authorTag: json['author_tag'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'published_date': publishedDate,
        'author_name': authorName,
        'author_image': authorImage,
        'author_tag': authorTag,
      };
}

class NewsAndTipsScreenArguments {
  String? type;
  News? news;
  Tip? tip;
  NewsAndTipsScreenArguments({required this.type, this.news, this.tip});
}

class NewsAndTipsListScreenArguments {
  final String? type;
  final List<News>? news;
  final List<Tip>? tips;
  NewsAndTipsListScreenArguments({required this.type, this.news, this.tips});
}
