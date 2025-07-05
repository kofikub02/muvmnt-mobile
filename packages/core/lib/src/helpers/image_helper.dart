import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageHelper {
  static const int _defaultQuality = 85;

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality ?? _defaultQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Pick image from camera
  static Future<File?> pickImageFromCamera({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality ?? _defaultQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>?> pickMultipleImages({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
    int? limit,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage(
        imageQuality: imageQuality ?? _defaultQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        limit: limit,
      );

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }

  /// Show image source selection dialog
  static Future<File?> showImageSourceDialog(
    BuildContext context, {
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromGallery(
                    imageQuality: imageQuality,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  );
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromCamera(
                    imageQuality: imageQuality,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  );
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Compress image file
  static Future<File?> compressImage(
    File imageFile, {
    int quality = 85,
    int maxSize = 1024,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize if needed
      final resizedImage = _resizeImage(image, maxSize);

      // Compress
      final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  /// Resize image
  static img.Image _resizeImage(img.Image image, int maxSize) {
    if (image.width <= maxSize && image.height <= maxSize) {
      return image;
    }

    final aspectRatio = image.width / image.height;
    int newWidth, newHeight;

    if (aspectRatio > 1) {
      newWidth = maxSize;
      newHeight = (maxSize / aspectRatio).round();
    } else {
      newHeight = maxSize;
      newWidth = (maxSize * aspectRatio).round();
    }

    return img.copyResize(image, width: newWidth, height: newHeight);
  }

  /// Create thumbnail
  static Future<File?> createThumbnail(
    File imageFile, {
    int size = 200,
    int quality = 85,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final thumbnail = img.copyResize(
        image,
        width: size,
        height: size,
        maintainAspect: true,
      );

      final thumbnailBytes = img.encodeJpg(thumbnail, quality: quality);

      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File(
        '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await thumbnailFile.writeAsBytes(thumbnailBytes);

      return thumbnailFile;
    } catch (e) {
      debugPrint('Error creating thumbnail: $e');
      return null;
    }
  }

  /// Convert image to base64
  static Future<String?> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Error converting image to base64: $e');
      return null;
    }
  }

  /// Convert base64 to image file
  static Future<File?> base64ToImageFile(
    String base64String, {
    String? fileName,
  }) async {
    try {
      final bytes = base64Decode(base64String);
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg'}',
      );
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Error converting base64 to image: $e');
      return null;
    }
  }

  /// Get image dimensions
  static Future<Size?> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
      return null;
    }
  }

  /// Get image file size in bytes
  static Future<int?> getImageFileSize(File imageFile) async {
    try {
      return await imageFile.length();
    } catch (e) {
      debugPrint('Error getting image file size: $e');
      return null;
    }
  }

  /// Format file size to readable string
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if file is an image
  static bool isImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Rotate image
  static Future<File?> rotateImage(File imageFile, int degrees) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final rotatedImage = img.copyRotate(image, angle: degrees);
      final rotatedBytes = img.encodeJpg(
        rotatedImage,
        quality: _defaultQuality,
      );

      final tempDir = await getTemporaryDirectory();
      final rotatedFile = File(
        '${tempDir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await rotatedFile.writeAsBytes(rotatedBytes);

      return rotatedFile;
    } catch (e) {
      debugPrint('Error rotating image: $e');
      return null;
    }
  }

  /// Crop image
  static Future<File?> cropImage(
    File imageFile, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final croppedImage = img.copyCrop(
        image,
        x: x,
        y: y,
        width: width,
        height: height,
      );
      final croppedBytes = img.encodeJpg(
        croppedImage,
        quality: _defaultQuality,
      );

      final tempDir = await getTemporaryDirectory();
      final croppedFile = File(
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await croppedFile.writeAsBytes(croppedBytes);

      return croppedFile;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

  /// Save image to gallery
  static Future<bool> saveImageToGallery(File imageFile) async {
    try {
      // Check permissions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        debugPrint('Storage permission denied');
        return false;
      }

      // For Android 10+ we need to use different approach
      if (Platform.isAndroid) {
        // Use image_gallery_saver or similar package
        // This is a simplified version
        final appDir = await getExternalStorageDirectory();
        if (appDir != null) {
          final savedFile = await imageFile.copy(
            '${appDir.path}/saved_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
          return savedFile.existsSync();
        }
      } else if (Platform.isIOS) {
        // Use photo_manager or similar package for iOS
        // This is a simplified version
        return true; // Placeholder
      }

      return false;
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
      return false;
    }
  }

  /// Capture widget as image
  static Future<File?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) return null;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/widget_capture_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  /// Apply blur effect to image
  static Future<File?> blurImage(File imageFile, {double radius = 5.0}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final blurredImage = img.gaussianBlur(image, radius: radius.toInt());
      final blurredBytes = img.encodeJpg(
        blurredImage,
        quality: _defaultQuality,
      );

      final tempDir = await getTemporaryDirectory();
      final blurredFile = File(
        '${tempDir.path}/blurred_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await blurredFile.writeAsBytes(blurredBytes);

      return blurredFile;
    } catch (e) {
      debugPrint('Error blurring image: $e');
      return null;
    }
  }

  /// Convert image to grayscale
  static Future<File?> convertToGrayscale(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final grayscaleImage = img.grayscale(image);
      final grayscaleBytes = img.encodeJpg(
        grayscaleImage,
        quality: _defaultQuality,
      );

      final tempDir = await getTemporaryDirectory();
      final grayscaleFile = File(
        '${tempDir.path}/grayscale_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await grayscaleFile.writeAsBytes(grayscaleBytes);

      return grayscaleFile;
    } catch (e) {
      debugPrint('Error converting to grayscale: $e');
      return null;
    }
  }

  /// Clear image cache
  static Future<void> clearImageCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File && isImageFile(file)) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error clearing image cache: $e');
    }
  }

  /// Validate image file
  static Future<bool> validateImageFile(File imageFile) async {
    try {
      if (!imageFile.existsSync()) return false;
      if (!isImageFile(imageFile)) return false;

      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      return image != null;
    } catch (e) {
      debugPrint('Error validating image file: $e');
      return false;
    }
  }
}

/// Image processing options
class ImageProcessingOptions {
  final int quality;
  final int maxSize;
  final bool createThumbnail;
  final int thumbnailSize;
  final bool compress;

  const ImageProcessingOptions({
    this.quality = 85,
    this.maxSize = 1024,
    this.createThumbnail = false,
    this.thumbnailSize = 200,
    this.compress = false,
  });
}

/// Image picker result
class ImagePickerResult {
  final File? originalFile;
  final File? processedFile;
  final File? thumbnailFile;
  final String? error;

  const ImagePickerResult({
    this.originalFile,
    this.processedFile,
    this.thumbnailFile,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasImage => originalFile != null || processedFile != null;
}
