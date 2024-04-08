import 'package:flutter/material.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:front/core/domain/entities/album.entity.dart';

class AlbumProvider with ChangeNotifier {
  final List<AlbumEntity> _albums = [];
  final Pictouapi _pictouApi;

  AlbumProvider(this._pictouApi) {
    fetchAlbums();
  }

  List<AlbumEntity> get albums => _albums;

  void fetchAlbums() async {
    try {
      var albumsApi = _pictouApi.getAlbumsApi();
      final response = await albumsApi.getAlbums();
      if (response.data != null) {
        _albums.clear();
        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors de la récupération des albums: $e");
    }
  }
}
