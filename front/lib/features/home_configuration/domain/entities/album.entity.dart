class AlbumEntity {
  final String name;
  List<String> picturePath;

  AlbumEntity({
    required this.name,
    required this.picturePath,
  });

  // Méthode pour vérifier si l'album contient des images
  bool get hasPictures => picturePath.isNotEmpty;

  // Méthode pour créer une copie de cette instance avec des valeurs modifiables
  AlbumEntity copyWith({
    String? name,
    List<String>? picturePath,
  }) {
    return AlbumEntity(
      name: name ?? this.name,
      picturePath: picturePath ?? this.picturePath,
    );
  }

  // Méthode pour mettre à jour les chemins d'images de l'album
  void updatePicturePaths({required List<String> updatedPicturePaths}) {
    picturePath = updatedPicturePaths;
  }

  @override
  String toString() => 'AlbumEntity( name: $name, picturePath: $picturePath)';
}
