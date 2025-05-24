import 'dart:io';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> addNewBlog(BlogModel blog);
  Future<String> getBlogImageUrl({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<BlogModel> addNewBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from("blogs_new").insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> getBlogImageUrl({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage
          .from("blogs_new_images")
          .upload(blog.id, image);
      return supabaseClient.storage
          .from("blogs_new_images")
          .getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from("blogs_new")
          .select("*, profiles (name)");
      return List<BlogModel>.from(
        blogs.map(
          (blog) => BlogModel.fromJson(
            blog,
          ).copyWith(authorName: blog['profiles']['name']),
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
