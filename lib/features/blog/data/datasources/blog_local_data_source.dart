import 'package:hive/hive.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> getLocalBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box blogBox;

  BlogLocalDataSourceImpl({required this.blogBox});

  @override
  List<BlogModel> getLocalBlogs() {
    List<BlogModel> blogs = [];
    for (int i = 0; i < blogBox.length; i++) {
      final blog = blogBox.get(i.toString());
      if (blog != null) {
        blogs.add(BlogModel.fromJson(blog));
      }
    }
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    blogBox.clear();
    for (int i = 0; i < blogs.length; i++) {
      blogBox.put(i.toString(), blogs[i].toJson());
    }
  }
}
