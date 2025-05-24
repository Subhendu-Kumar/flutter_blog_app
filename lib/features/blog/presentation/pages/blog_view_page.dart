import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogViewPage extends StatelessWidget {
  final Blog blog;

  const BlogViewPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(blog.updatedAt);
    final readingtime = calculateReadingTime(blog.description);

    return Scaffold(
      appBar: AppBar(title: Text(blog.title, overflow: TextOverflow.ellipsis)),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${blog.authorName ?? blog.author} • $formattedDate • $readingtime',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  blog.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: const Color.fromARGB(255, 47, 46, 46),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 200,
                        color: const Color.fromARGB(255, 47, 46, 46),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    blog.topics
                        .map(
                          (topic) => Chip(
                            label: Text(topic),
                            backgroundColor: Colors.blue.shade50,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                blog.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
