// Openapi Generator last run: : 2024-04-02T10:43:42.283775

class AlbumEntity {
  final String id;
  final String name;
  List<String> picturePath;

  AlbumEntity({
    required this.id,
    required this.name,
    required this.picturePath,
  });

  bool get hasPictures => picturePath.isNotEmpty;

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

  void updatePicturePaths({required List<String> updatedPicturePaths}) {
    picturePath = updatedPicturePaths;
  }

  @override
  String toString() =>
      'AlbumEntity(id: $id, name: $name, picturePath: $picturePath)';
}
