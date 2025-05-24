import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({
    required this.connectionChecker,
    required this.blogLocalDataSource,
    required this.blogRemoteDataSource,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String author,
    required String description,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v4(),
        title: title,
        imageUrl: "",
        author: author,
        topics: topics,
        description: description,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.getBlogImageUrl(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSource.addNewBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final localBlogs = blogLocalDataSource.getLocalBlogs();
        print("Returning local blogs: ${localBlogs.length}");
        return right(localBlogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
