import 'dart:typed_data';
import 'package:image/image.dart' as img;

class PhotoMetadata {
  final int width;
  final int height;
  final double sizeInKB;

  PhotoMetadata({
    required this.width,
    required this.height,
    required this.sizeInKB,
  });

  factory PhotoMetadata.fromImageBytes(Uint8List imageBytes) {
    final img.Image image = img.decodeImage(imageBytes)!;
    return PhotoMetadata(
      width: image.width,
      height: image.height,
      sizeInKB: imageBytes.lengthInBytes / 1024,
    );
  }
}
