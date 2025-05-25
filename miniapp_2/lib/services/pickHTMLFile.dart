import 'package:file_picker/file_picker.dart';

Future<PlatformFile?> pickHtmlFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['html'],
  );

  if (result != null && result.files.isNotEmpty) {
    return result.files.first;
  }

  return null;
}
