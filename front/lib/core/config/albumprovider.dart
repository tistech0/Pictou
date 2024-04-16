import 'package:built_collection/src/list.dart';
import 'package:flutter/material.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:built_value/serializer.dart';
import '../domain/entities/album.entity.dart';

class AlbumProvider with ChangeNotifier {
  final Pictouapi _pictouApi;
  List<AlbumEntity> _albums = [];

  final Serializers _serializers;

  AlbumProvider(this._pictouApi, this._serializers);

  List<AlbumEntity> get albums => _albums;

  void fetchAlbums(String accessToken) async {
    try {
      var albumsApi = _pictouApi.getAlbumsApi();
      final response = await albumsApi.getAlbums(
        limit: 10,
        offset: 0,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      print(accessToken);

      if (response.statusCode == 200 && response.data != null) {
        print(response.data);

        _albums = response.data!.albums.map((album) {
          return AlbumEntity.fromAlbumModel(album);
        }).toList();

        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la récupération des albums: $e");
    }
  }

  Future<String?> createAlbum(String name, List<String> tags,
      List<String> images, String accessToken) async {
    try {
      var albumsApi = _pictouApi.getAlbumsApi();
      final albumPost = AlbumPost((b) => b
        ..name = name
        ..tags = ListBuilder(tags)
        ..images = ListBuilder(images));

      final response = await albumsApi.createAlbum(
        albumPost: albumPost,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 && response.data != null) {
        var createdAlbum = AlbumEntity.fromAlbumModel(response.data!);
        _albums.add(createdAlbum);
        notifyListeners();
        return createdAlbum.id; // Retourne l'ID de l'album créé
      } else {
        print(
            "Échec de la création de l'album avec status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la création de l'album: $e");
      return null;
    }
  }

  Future<void> deleteAlbum(String albumId, String accessToken) async {
    try {
      var albumsApi = _pictouApi.getAlbumsApi();
      final response = await albumsApi.deleteAlbum(
        id: albumId,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        print("Album supprimé avec succès.");

        // Supprimez l'album de la liste en mémoire si nécessaire
        _albums.removeWhere((album) => album.id == albumId);
        notifyListeners();
      } else {
        print(
            "Erreur lors de la suppression de l'album: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception lors de la suppression de l'album: $e");
    }
  }

  Future<void> addImageToAlbum(
      String albumId, String imageId, String accessToken) async {
    try {
      final response = await _pictouApi.getAlbumsApi().addImageToAlbum(
          id: albumId,
          imageId: imageId,
          headers: {"Authorization": "Bearer $accessToken"});

      if (response.statusCode == 200) {
        print("Image ajoutée à l'album avec succès.");
        fetchAlbums(accessToken);
      } else {
        print(
            "Erreur lors de l'ajout de l'image à l'album: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception lors de l'ajout de l'image à l'album: $e");
    }
  }

  Future<void> addShared(
      String albumId, String userId, String accessToken) async {
    try {
      var albumsApi = _pictouApi.getAlbumsApi();
      final existingAlbum = _albums.firstWhere((album) => album.id == albumId);

      if (existingAlbum == null) {
        print("Album introuvable");
        return;
      }

      final albumPost = AlbumPost((b) => b
        // ..name = existingAlbum.name
        // ..tags = ListBuilder(existingAlbum.tags)
        // ..images = ListBuilder(existingAlbum.images.map((image) => image.id))
        ..sharedWith = (ListBuilder(existingAlbum.sharedWith)..add(userId)));

      final response = await albumsApi.editAlbum(
        id: albumId,
        albumPost: albumPost,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      print(albumPost);

      if (response.statusCode == 200 && response.data != null) {
        print("Modification de l'album réussie.");
        // Mise à jour de l'album avec les nouvelles informations
        final updatedAlbum = AlbumEntity.fromAlbumModel(response.data!);
        _albums[_albums.indexWhere((album) => album.id == albumId)] =
            updatedAlbum;
        notifyListeners();
      } else {
        print(
            "Échec de la modification de l'album avec status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception lors de la modification de l'album: $e");
    }
  }
}
