part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final File image;
  final String title;
  final String author;
  final String description;
  final List<String> topics;

  BlogUpload({
    required this.image,
    required this.title,
    required this.author,
    required this.topics,
    required this.description,
  });
}

final class BlogGetAll extends BlogEvent {}
