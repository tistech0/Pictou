import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/core/domain/usecase/upload_images.use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:provider/provider.dart';

class BottomBarWidget extends StatelessWidget {
  final AlbumEntity? selectedAlbum;
  final String accessToken;
  final VoidCallback onSuccess;

  const BottomBarWidget({
    super.key,
    required this.selectedAlbum,
    required this.accessToken,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void uploadImages(List<XFile> images) {
      final imagesProvider =
          Provider.of<ImagesProvider>(context, listen: false);
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

      UploadImagesUseCase uploadImagesUseCase = UploadImagesUseCase(
        imagesProvider: imagesProvider,
        albumProvider: albumProvider,
        accessToken:
            accessToken, // Utilisation de accessToken passé au constructeur
        onSuccess: onSuccess,
      );

      uploadImagesUseCase(selectedAlbum, images, []);
    }

    Future<void> pickImages(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      List<XFile>? images;

      try {
        if (source == ImageSource.camera) {
          final XFile? photo = await picker.pickImage(source: source);
          if (photo != null) {
            images = [photo];
          }
        } else {
          images = await picker.pickMultiImage();
        }

        if (images != null && images.isNotEmpty) {
          uploadImages(images);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aucune image sélectionnée.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur lors de la sélection de l\'image : $e')));
      }
    }

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'importFromGallery':
                  pickImages(ImageSource.gallery);
                  break;
                case 'useCamera':
                  pickImages(ImageSource.camera);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'importFromGallery',
                child: Center(
                  child: Text('Importer de la galerie'),
                ),
              ),
              const PopupMenuItem(
                value: 'useCamera',
                child: Center(child: Text('Utiliser la caméra')),
              ),
            ],
            icon: const Icon(Icons.add_a_photo),
            offset: Offset(screenWidth / 4, 20),
          ),
        ],
      ),
    );
  }
}
