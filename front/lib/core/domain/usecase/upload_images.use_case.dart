import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:pictouapi/pictouapi.dart';

class UploadImagesUseCase {
  final ImagesProvider imagesProvider;
  final AlbumProvider albumProvider;
  final String accessToken;
  final VoidCallback onSuccess;
  final imageApi = Pictouapi().getImagesApi();

  UploadImagesUseCase({
    required this.imagesProvider,
    required this.albumProvider,
    required this.accessToken,
    required this.onSuccess,
  });

  Future<void> _editImageMetadata(String imageId, List<String> tags) async {
    final imagePatch = ImagePatch((b) => b..tags.replace(tags));

    try {
      await imageApi.editImage(
        id: imageId,
        imagePatch: imagePatch,
        headers: {"Authorization": "Bearer $accessToken"},
      );
    } catch (e) {
      print(
          'Exception lors de la modification des métadonnées de l\'image: $e');
    }
  }

  Future<void> call(
      AlbumEntity? selectedAlbum, List<XFile> images, List<String> tags) async {
    if (selectedAlbum == null) {
      throw Exception("Album non sélectionné.");
    }

    List<Future> uploadTasks = [];
    for (var imageFile in images) {
      uploadTasks.add(_uploadAndHandleImage(imageFile, selectedAlbum.id, tags));
    }

    final results = await Future.wait(uploadTasks, eagerError: false);

    bool errorOccurred = results.any((result) => result != true);
    if (!errorOccurred) {
      print(
          'Toutes les images ont été téléchargées et ajoutées à l\'album avec succès.');
      onSuccess();
    } else {
      print(
          'Certaines images n\'ont pas pu être téléchargées ou ajoutées à l\'album.');
    }
  }

  Future<bool> _uploadAndHandleImage(
      XFile imageFile, String albumId, List<String> tags) async {
    try {
      final image = await MultipartFile.fromFile(imageFile.path,
          filename: path.basename(imageFile.path),
          contentType:
              MediaType('image', path.extension(imageFile.path).substring(1)));

      final uploadResponse =
          await imagesProvider.uploadImage(image, accessToken);
      if (uploadResponse == null) {
        print('Échec du téléchargement de l\'image.');
        return false;
      }

      await albumProvider.addImageToAlbum(
          albumId, uploadResponse.id, accessToken);
      await _editImageMetadata(uploadResponse.id, tags);
      return true;
    } catch (e) {
      print('Exception lors du téléchargement ou de l\'ajout de l\'image: $e');
      return false;
    }
  }
}
