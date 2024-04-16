import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/core/domain/usecase/upload_images.use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImportPicturesDialog extends StatefulWidget {
  const ImportPicturesDialog({super.key});

  @override
  State<ImportPicturesDialog> createState() => _ImportPicturesDialogState();
}

class _ImportPicturesDialogState extends State<ImportPicturesDialog> {
  final ImagePicker _picker = ImagePicker();
  AlbumEntity? _selectedAlbum;

  UploadImagesUseCase? _uploadImagesUseCase;

  @override
  void initState() {
    super.initState();
    initializeUploadImagesUseCase();
  }

  void initializeUploadImagesUseCase() {
    final imagesProvider = Provider.of<ImagesProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.user?.accessToken;

    if (accessToken != null) {
      _uploadImagesUseCase = UploadImagesUseCase(
        imagesProvider: imagesProvider,
        albumProvider: albumProvider,
        accessToken: accessToken,
        onSuccess: handleSuccess,
      );
    }
  }

  void handleSuccess() {
    Navigator.of(context).pop(); // Ferme le dialogue
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Les images ont été ajoutées avec succès à l\'album')));
  }

  Future<void> _uploadImages(List<XFile> images) async {
    if (_uploadImagesUseCase != null && images.isNotEmpty) {
      await _uploadImagesUseCase!.call(_selectedAlbum, images);
    } else {
      print("Aucune image sélectionnée ou problème de configuration.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    final albums = albumProvider.albums;

    return AlertDialog(
      title: const Text('Importer des Photos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAlbum?.id,
            hint: const Text('Sélectionnez un album'),
            items: albums.map<DropdownMenuItem<String>>((album) {
              return DropdownMenuItem<String>(
                value: album.id,
                child: Text(album.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAlbum =
                    albums.firstWhere((album) => album.id == newValue);
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final List<XFile> images = await _picker.pickMultiImage();
              if (images.isNotEmpty) {
                print("${images.length} images picked.");
                await _uploadImages(images);
              } else {
                print("No images selected.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text('Importer des Photos'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
