import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum PickerSource { camera, gallery }

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> pickImages({
    required PickerSource source,
    bool allowMultiple = false,
  }) async {
    if (source == PickerSource.camera) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      return photo != null ? [File(photo.path)] : [];
    } else {
      if (allowMultiple) {
        final List<XFile> files = await _picker.pickMultiImage();
        return files.map((xfile) => File(xfile.path)).toList();
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        return image != null ? [File(image.path)] : [];
      }
    }
  }
}
