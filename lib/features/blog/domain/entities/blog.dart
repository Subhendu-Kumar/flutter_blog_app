// ignore_for_file: public_member_api_docs, sort_constructors_first
class Blog {
  final String id;
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;

  Blog({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
  });
}
