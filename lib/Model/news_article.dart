class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String image;
  final String source;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.image,
    required this.source,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      source: (json['source'] is Map)
          ? (json['source']['name']?.toString() ?? '')
          : '',
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
