import 'package:front/core/config/imagesprovider.dart';

class DeleteImageUseCase {
  final ImagesProvider imagesProvider;
  final String accessToken;

  DeleteImageUseCase(this.imagesProvider, this.accessToken);

  Future<void> execute(String imageId) async {
    try {
      await imagesProvider.deleteImage(imageId, accessToken);
    } catch (e) {
      print("Erreur lors de la suppression de l'image: $e");
    }
  }
}
