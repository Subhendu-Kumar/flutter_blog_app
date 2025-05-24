import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _getAllBlogs = getAllBlogs,
      _uploadBlog = uploadBlog,
      super(BlogInitial()) {
    on<BlogUpload>((event, emit) async {
      emit(BlogLoading());
      final res = await _uploadBlog(
        UploadBlogParams(
          image: event.image,
          title: event.title,
          author: event.author,
          topics: event.topics,
          description: event.description,
        ),
      );
      res.fold(
        (failure) => emit(BlogFailure(error: failure.message)),
        (blog) => emit(BlogSuccess()),
      );
    });

    on<BlogGetAll>((event, emit) async {
      emit(BlogLoading());
      final res = await _getAllBlogs(NoParams());
      res.fold(
        (failure) => emit(BlogFailure(error: failure.message)),
        (blogs) => emit(BlogDisplaySuccess(blogs: blogs)),
      );
    });
  }
}
