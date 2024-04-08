import 'package:pictouapi/src/model/album.dart';
import 'image.entity.dart'; // Importez la classe ImageEntity ici

class AlbumEntity {
  final String id;
  final String name;
  final List<ImageEntity> images; // Utilisez List<ImageEntity> ici
  final String ownerId;
  final List<String> sharedWith;
  final List<String> tags;

  AlbumEntity({
    required this.id,
    required this.name,
    required this.images,
    required this.ownerId,
    required this.sharedWith,
    required this.tags,
  });

  // Adaptez votre méthode factory pour traiter la liste des images
  factory AlbumEntity.fromAlbumModel(Album album) {
    // Convertit un objet Album en AlbumEntity
    List<ImageEntity> albumImages =
        []; // Créez une liste pour les images de l'album
    // Parcourez les images de l'album et convertissez-les en ImageEntity
    for (var image in album.images) {
      albumImages.add(ImageEntity.fromImageModel(image));
    }
    return AlbumEntity(
      id: album.id,
      name: album.name,
      images: albumImages,
      ownerId: album.ownerId,
      sharedWith: album.sharedWith.toList(), // Convertir en liste de String
      tags: album.tags.toList(), // Convertir en liste de String
    );
  }
}
