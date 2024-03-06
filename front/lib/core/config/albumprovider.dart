import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/album.entity.dart';

class AlbumProvider with ChangeNotifier {
  final List<AlbumEntity> _albums = [
    AlbumEntity(
      id: "1", // Ajout de l'ID
      name: "Mon Premier Album",
      picturePath: [
        'assets/images/workers.png',
      ],
    ),
    AlbumEntity(
      id: "2", // Ajout de l'ID
      name: "Mon deuxième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    AlbumEntity(
      id: "3", // Ajout de l'ID
      name: "Mon troisième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    AlbumEntity(
      id: "4", // Ajout de l'ID
      name: "Mon quatrième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    // Continuez à ajouter des ID uniques pour les autres albums
    AlbumEntity(
      id: "5",
      name: "Mon cinquième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    // ...
  ];

  List<AlbumEntity> get albums => _albums;

  void addAlbum(AlbumEntity newAlbum) {
    _albums.add(newAlbum);
    notifyListeners();
  }

  void removeAlbum(String albumName) {
    _albums.removeWhere((album) => album.name == albumName);
    notifyListeners();
  }
}
