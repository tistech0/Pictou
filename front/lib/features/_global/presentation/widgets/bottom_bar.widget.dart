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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.user?.accessToken;
      if (accessToken == null) {
        throw Exception("Token d'accès non trouvé.");
      }
      UploadImagesUseCase uploadImagesUseCase = UploadImagesUseCase(
        imagesProvider: imagesProvider,
        albumProvider: albumProvider,
        accessToken: accessToken,
        onSuccess: onSuccess,
      );

      uploadImagesUseCase(selectedAlbum, images, []);
    }

    void openCamera() async {
      final ImagePicker pickerCamera = ImagePicker();
      final XFile? photo =
          await pickerCamera.pickImage(source: ImageSource.camera);
      if (photo != null) {
        uploadImages([photo]);
      }
    }

    void openGallery() async {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        uploadImages(images);
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
                  openGallery();
                  break;
                case 'useCamera':
                  openCamera();
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
