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

  Future<void> createAlbum(String name, List<String> tags, List<String> images,
      String accessToken) async {
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
        print("Album créé avec succès: ${response.data}");

        _albums.add(AlbumEntity.fromAlbumModel(response.data!));
        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la création de l'album: $e");
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
}
