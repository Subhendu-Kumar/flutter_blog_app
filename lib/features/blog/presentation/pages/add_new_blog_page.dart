import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/theme/pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  File? image;
  List<String> selectedTopics = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _blogTitleController = TextEditingController();
  final TextEditingController _blogDescriptionController =
      TextEditingController();

  final List<String> topics = [
    "Technology",
    "Health",
    "Science",
    "Sports",
    "Politics",
  ];

  void clearFormFields() {
    image = null;
    selectedTopics.clear();
    _blogTitleController.clear();
    _blogDescriptionController.clear();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void handlePress() {
    if (_formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final author =
          (BlocProvider.of<AppUserCubit>(context).state as AppUserLoggedIn)
              .user
              .id;
      BlocProvider.of<BlogBloc>(context).add(
        BlogUpload(
          image: image!,
          title: _blogTitleController.text.trim(),
          description: _blogDescriptionController.text.trim(),
          author: author,
          topics: selectedTopics,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _blogTitleController.dispose();
    _blogDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new Blog")),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
          if (state is BlogSuccess) {
            clearFormFields();
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                          onTap: selectImage,
                          child: SizedBox(
                            height: 200.0,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(image!, fit: BoxFit.cover),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: selectImage,
                          child: Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Pallete.borderColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                SizedBox(height: 15),
                                Text(
                                  "Select Image",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            topics
                                .map(
                                  (text) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTopics.contains(text)) {
                                            selectedTopics.remove(text);
                                          } else {
                                            selectedTopics.add(text);
                                          }
                                        });
                                      },
                                      child: Chip(
                                        label: Text(text),
                                        color:
                                            selectedTopics.contains(text)
                                                ? WidgetStatePropertyAll(
                                                  Pallete.gradient1,
                                                )
                                                : null,
                                        side:
                                            selectedTopics.contains(text)
                                                ? null
                                                : BorderSide(
                                                  color: Pallete.borderColor,
                                                ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    BlogEditor(
                      hintText: "Blog Title",
                      controller: _blogTitleController,
                    ),
                    SizedBox(height: 20),
                    BlogEditor(
                      hintText: "Blog Description",
                      controller: _blogDescriptionController,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handlePress,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(395, 55),
                        backgroundColor: Pallete.gradient2,
                        shadowColor: Pallete.gradient3,
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
