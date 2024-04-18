import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:built_collection/src/list.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pictouapi/pictouapi.dart'; // Assurez-vous que cette importation est correcte.
import 'package:built_value/serializer.dart';
import '../domain/entities/image.entity.dart'; // Importez vos entités d'image.
import 'package:mime/mime.dart';
import 'package:image/image.dart' as imglib;

class ImagesProvider with ChangeNotifier {
  final Pictouapi _pictouApi;
  final Serializers _serializers;
  final ImagesApi _imagesApi;
  final AlbumsApi _albumsApi;

  ImagesProvider(this._pictouApi, this._serializers)
      : _imagesApi = _pictouApi.getImagesApi(),
      _albumsApi = _pictouApi.getAlbumsApi();
  List<ImageEntity> _images = [];
  List<ImageEntity> get images => _images;

  Stream<List<Uint8List>> fetchImagesAlbum(String accessToken, String albumId, ImageQuality quality) async* {
    try {
      final response = await _albumsApi.getAlbum(id: albumId, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200 && response.data != null) {
        final Album? album = response.data;
        final BuiltList<ImageMetaData>? images = album?.images;
        if (images != null) {
          List<Uint8List> downloadedImages = [];
          for (var image in images) {
            print('Image ID: ${image.id}');
            final response = await _imagesApi.getImage(id: image.id, quality: quality, headers: {
              "Authorization": "Bearer $accessToken"
            });
            if (response.statusCode == 200 && response.data != null) {
              final Uint8List? imageData = response.data;
              // Decode the image data using the image package
              final imglib.Image? decodedImage = imglib.decodeImage(imageData!);
              if (decodedImage != null) {
                // Determine the format of the image data based on the Content-Type header
                final String? contentType = response.headers.map['content-type']?.first;
                final String format = contentType?.split('/').last ?? '';
                // Encode the decoded image data as a PNG or JPEG depending on the original format
                final Uint8List encodedImage = format == 'jpeg'
                    ? Uint8List.fromList(imglib.encodeJpg(decodedImage))
                    : Uint8List.fromList(imglib.encodePng(decodedImage));
                // Store the encoded image data in a list
                downloadedImages.add(encodedImage);
                yield downloadedImages; // Yield the current state of the downloadedImages each time a new image is added
              }
            }
          }
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des images: $e");
    }
  }

  Future<Uint8List?> fetchFirstImageOfAlbum(String accessToken, String albumId, ImageQuality quality) async {
    try {
      final response = await _albumsApi.getAlbum(id: albumId, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200 && response.data != null) {
        final Album? album = response.data;
        final BuiltList<ImageMetaData>? images = album?.images;
        if (images != null && images.length > 0) {
          final ImageMetaData firstImage = images.first;
          final response = await _imagesApi.getImage(id: firstImage.id, quality: quality, headers: {
            "Authorization": "Bearer $accessToken"
          });
          if (response.statusCode == 200 && response.data != null) {
            final Uint8List? imageData = response.data;
            // Decode the image data using the image package
            final imglib.Image? decodedImage = imglib.decodeImage(imageData!);
            if (decodedImage != null) {
              // Encode the decoded image data as a PNG or JPEG depending on the original format
              final String? contentType = response.headers.map['content-type']?.first;
              final String format = contentType?.split('/').last ?? '';
              final Uint8List encodedImage = format == 'jpeg'
                  ? Uint8List.fromList(imglib.encodeJpg(decodedImage))
                  : Uint8List.fromList(imglib.encodePng(decodedImage));
              return encodedImage;
            }
          }
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération de la première image de l'album: $e");
    }
    return null;
  }



  Future<ImageUploadResponse?> uploadImage(
      MultipartFile imageFile, String accessToken) async {
    try {
      final response = await _imagesApi.uploadImage(
        image: imageFile,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 && response.data != null) {
        notifyListeners();
        return response.data;
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'upload de l\'image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageId, String accessToken) async {
    try {
      final response = await _imagesApi.deleteImage(
        id: imageId,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        _images.removeWhere((image) => image.id == imageId);
        notifyListeners();
        print("Image supprimée avec succès.");
      } else {
        print(
            "Erreur lors de la suppression de l'image: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception lors de la suppression de l'image: $e");
    }
  }
}
