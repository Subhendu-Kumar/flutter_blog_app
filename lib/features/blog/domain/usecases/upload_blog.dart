import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      author: params.author,
      topics: params.topics,
      description: params.description,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String author;
  final String description;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.title,
    required this.author,
    required this.topics,
    required this.description,
  });
}
