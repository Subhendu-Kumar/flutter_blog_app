import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xImage == null) return null;
    return File(xImage.path);
  } catch (e) {
    return null;
  }
}
