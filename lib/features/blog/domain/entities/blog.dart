class Blog {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final DateTime updatedAt;
  final String? authorName;
  final List<String> topics;

  Blog({
    this.authorName,
    required this.id,
    required this.title,
    required this.author,
    required this.topics,
    required this.imageUrl,
    required this.updatedAt,
    required this.description,
  });
}
