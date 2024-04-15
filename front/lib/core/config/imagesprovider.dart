import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pictouapi/pictouapi.dart'; // Assurez-vous que cette importation est correcte.
import 'package:built_value/serializer.dart';
import '../domain/entities/image.entity.dart'; // Importez vos entités d'image.

class ImagesProvider with ChangeNotifier {
  final Pictouapi _pictouApi;
  final Serializers _serializers;
  final ImagesApi _imagesApi;

  ImagesProvider(this._pictouApi, this._serializers)
      : _imagesApi = _pictouApi.getImagesApi();
  List<ImageEntity> _images = [];
  List<ImageEntity> get images => _images;

  Future<void> fetchImages(String accessToken) async {
    try {
      final response = await _imagesApi.getImages(
        headers: {"Authorization": "Bearer $accessToken"},
      );

      // if (response.statusCode == 200 && response.data != null) {
      //   _images = response.data.images.map((image) {
      //     return ImageEntity.fromImageModel(image);
      //   }).toList();
      //   notifyListeners();
      // }
    } catch (e) {
      print("Erreur lors de la récupération des images: $e");
    }
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

// Ajoutez d'autres méthodes pour la gestion des images si nécessaire
}
