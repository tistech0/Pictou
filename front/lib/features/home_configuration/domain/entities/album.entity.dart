class AlbumEntity {
  final String id; // Identifiant unique de l'album
  final String name;
  List<String> picturePath;

  AlbumEntity({
    required this.id,
    required this.name,
    required this.picturePath,
  });

  // Méthode pour vérifier si l'album contient des images
  bool get hasPictures => picturePath.isNotEmpty;

  // Méthode pour créer une copie de cette instance avec des valeurs modifiables
  AlbumEntity copyWith({
    String? id,
    String? name,
    List<String>? picturePath,
  }) {
    return AlbumEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      picturePath: picturePath ?? this.picturePath,
    );
  }

  // Méthode pour mettre à jour les chemins d'images de l'album
  void updatePicturePaths({required List<String> updatedPicturePaths}) {
    picturePath = updatedPicturePaths;
  }

  @override
  String toString() =>
      'AlbumEntity(id: $id, name: $name, picturePath: $picturePath)';
}
