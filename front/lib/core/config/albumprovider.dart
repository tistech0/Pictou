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

// Autres méthodes...
}
