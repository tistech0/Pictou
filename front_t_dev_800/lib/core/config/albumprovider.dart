import 'package:flutter/material.dart';
import 'package:front_t_dev_800/features/home_configuration/domain/entities/album.entity.dart';

class AlbumProvider with ChangeNotifier {
  // Liste d'albums au lieu d'un seul album
  final List<AlbumEntity> _albums = [
    AlbumEntity(
      name: "Mon Premier Album",
      picturePath: [
        'assets/images/card.png',
        'assets/images/workers.png',
      ],
    ),
    AlbumEntity(
      name: "Mon deuxième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    AlbumEntity(
      name: "Mon troisième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    AlbumEntity(
      name: "Mon quatrième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    AlbumEntity(
      name: "Mon cinquième Album",
      picturePath: [
        'assets/images/workers.png',
        'assets/images/card.png',
      ],
    ),
    // Ajoutez d'autres albums initiaux ici si nécessaire
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

// Vous pourriez vouloir ajouter ou ajuster les méthodes pour modifier les albums existants si nécessaire
}
