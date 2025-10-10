import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  static Future<File?> pickFile({required List<String> allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }

    return null;
  }
}
