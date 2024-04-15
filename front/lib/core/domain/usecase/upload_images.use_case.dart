import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class UploadImagesUseCase {
  final ImagesProvider imagesProvider;
  final AlbumProvider albumProvider;
  final String accessToken;
  final VoidCallback onSuccess;

  UploadImagesUseCase({
    required this.imagesProvider,
    required this.albumProvider,
    required this.accessToken,
    required this.onSuccess,
  });

  Future<void> call(AlbumEntity? selectedAlbum, List<XFile> images) async {
    if (selectedAlbum == null) {
      throw Exception("Album non sélectionné.");
    }

    var errorOccurred = false;

    for (var imageFile in images) {
      try {
        final image = await MultipartFile.fromFile(imageFile.path,
            filename: path.basename(imageFile.path),
            contentType: MediaType(
                'image', path.extension(imageFile.path).substring(1)));

        final uploadResponse =
            await imagesProvider.uploadImage(image, accessToken);
        if (uploadResponse == null) {
          errorOccurred = true;
          print('Échec du téléchargement de l\'image.');
          continue;
        }

        await albumProvider.addImageToAlbum(
            selectedAlbum.id, uploadResponse.id, accessToken);
      } catch (e) {
        errorOccurred = true;
        print(
            'Exception lors du téléchargement ou de l\'ajout de l\'image: $e');
      }
    }

    if (!errorOccurred) {
      print(
          'Toutes les images ont été téléchargées et ajoutées à l\'album avec succès.');
      onSuccess(); // Appel du rappel lorsque tout est réussi
    } else {
      print(
          'Certaines images n\'ont pas pu être téléchargées ou ajoutées à l\'album.');
    }
  }
}
