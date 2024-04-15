import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/_global/domain/usecases/upload_image.use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart'; // Assurez-vous que ce package est inclus pour MediaType

class ImportPicturesDialog extends StatefulWidget {
  const ImportPicturesDialog({super.key});

  @override
  State<ImportPicturesDialog> createState() => _ImportPicturesDialogState();
}

class _ImportPicturesDialogState extends State<ImportPicturesDialog> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedAlbum;
  UploadImageUseCase? _uploadImageUseCase;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final pictouApi =
        Pictouapi(); // Assurez-vous que l'instance est correctement configurée

    _uploadImageUseCase = UploadImageUseCase(dio, pictouApi);
  }

  Future<void> _uploadImages(List<XFile> images) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? accessToken = userProvider.user?.accessToken;

    if (accessToken == null) {
      print('Échec du téléchargement : Token d\'accès non disponible');
      return;
    }

    for (var imageFile in images) {
      final String filePath = imageFile.path;
      final String fileName = path.basename(filePath);
      final MultipartFile multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );

      final uploadResponse =
          await _uploadImageUseCase?.uploadImage(multipartFile, accessToken);

      if (uploadResponse != null && uploadResponse.statusCode == 200) {
        print('Image téléchargée avec succès : ${uploadResponse.data}');
      } else {
        print(
            'Échec du téléchargement de l\'image : ${uploadResponse?.statusCode}');
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
          DropdownButtonFormField<String>(
            value: _selectedAlbum,
            hint: const Text('Sélectionnez un album'),
            items: albums.map<DropdownMenuItem<String>>((album) {
              return DropdownMenuItem<String>(
                value: album.name,
                child: Text(album.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAlbum = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final List<XFile>? images = await _picker.pickMultiImage();
              if (images != null && images.isNotEmpty) {
                await _uploadImages(images);
                print('Images sélectionnées pour $_selectedAlbum');
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
