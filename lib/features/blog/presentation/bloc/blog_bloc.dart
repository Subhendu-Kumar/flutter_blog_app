import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;

  BlogBloc({required UploadBlog uploadBlog})
    : _uploadBlog = uploadBlog,
      super(BlogInitial()) {
    on<BlogUpload>((event, emit) async {
      emit(BlogLoading());
      final res = await _uploadBlog(
        UploadBlogParams(
          image: event.image,
          title: event.title,
          description: event.description,
          author: event.author,
          topics: event.topics,
        ),
      );
      res.fold(
        (failure) => emit(BlogFailure(error: failure.message)),
        (blog) => emit(BlogSuccess()),
      );
    });
  }
}
