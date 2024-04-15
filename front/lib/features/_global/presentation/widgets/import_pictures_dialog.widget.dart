import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ImportPicturesDialog extends StatefulWidget {
  const ImportPicturesDialog({super.key});

  @override
  State<ImportPicturesDialog> createState() => _ImportPicturesDialogState();
}

class _ImportPicturesDialogState extends State<ImportPicturesDialog> {
  final ImagePicker _picker = ImagePicker();
  AlbumEntity? _selectedAlbum;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadImages(List<XFile> images) async {
    final imagesProvider = Provider.of<ImagesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.user?.accessToken;

    for (var imageFile in images) {
      final image = await MultipartFile.fromFile(imageFile.path,
          filename: path.basename(imageFile.path),
          contentType:
              MediaType('image', path.extension(imageFile.path).substring(1)));

      final uploadResponse =
          await imagesProvider.uploadImage(image, accessToken!);
      if (uploadResponse != null && _selectedAlbum != null) {
        await Provider.of<AlbumProvider>(context, listen: false)
            .addImageToAlbum(
                _selectedAlbum!.id, uploadResponse.id, accessToken);
      } else {
        print('Échec du téléchargement de l\'image ou album non sélectionné');
      }
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
          DropdownButtonFormField<AlbumEntity>(
            value: _selectedAlbum,
            hint: const Text('Sélectionnez un album'),
            items: albums.map<DropdownMenuItem<AlbumEntity>>((album) {
              return DropdownMenuItem<AlbumEntity>(
                value: album,
                child: Text(album.name),
              );
            }).toList(),
            onChanged: (AlbumEntity? newValue) {
              setState(() {
                _selectedAlbum = newValue;
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
                print('Images sélectionnées pour $_selectedAlbum');
              } else {
                print("No images selected.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text('Importer dessss Photos'),
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
