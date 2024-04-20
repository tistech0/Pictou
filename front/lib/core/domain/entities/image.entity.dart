class ImageEntity {
  final String id;
  final String path;
  final String caption; // Légende de l'image
  final String ownerId; // Identifiant du propriétaire de l'image
  final List<String>
      sharedWith; // Liste des identifiants des utilisateurs avec qui l'image est partagée
  final List<String> tags; // Tags associés à l'image

  ImageEntity({
    required this.id,
    required this.path,
    required this.caption,
    required this.ownerId,
    required this.sharedWith,
    required this.tags,
  });

  // Méthode pour créer une instance d'ImageEntity à partir d'un objet JSON
  factory ImageEntity.fromJson(Map<String, ImageEntity> json) {
    return ImageEntity(
      id: json['id'] as String,
      path: json['path'] as String,
      caption: json['caption'] as String,
      ownerId: json['owner_id'] as String,
      sharedWith: List<String>.from(json['shared_with'] as List<dynamic>),
      tags: List<String>.from(json['tags'] as List<dynamic>),
    );
  }

  // Méthode pour convertir une instance d'ImageEntity en objet JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'caption': caption,
      'owner_id': ownerId,
      'shared_with': sharedWith,
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'ImageEntity(id: $id, path: $path, caption: $caption, ownerId: $ownerId, sharedWith: $sharedWith, tags: $tags)';
  }

  static fromImageModel(image) {
    return ImageEntity(
      id: image.id,
      path: image.path,
      caption: image.caption,
      ownerId: image.ownerId,
      sharedWith: image.sharedWith.toList(),
      tags: image.tags.toList(),
    );
  }
}
