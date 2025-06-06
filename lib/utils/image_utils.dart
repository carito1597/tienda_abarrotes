import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> takeAndSavePhoto() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

  if (pickedFile == null) return null;

  final appDir = await getApplicationDocumentsDirectory();
  final fileName = basename(pickedFile.path);
  final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

  return savedImage.path;
}
