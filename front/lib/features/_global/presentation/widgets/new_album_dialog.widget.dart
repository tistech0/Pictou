import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class NewAlbumDialog extends StatefulWidget {
  const NewAlbumDialog({super.key});

  @override
  State<NewAlbumDialog> createState() => _NewAlbumDialogState();
}

class _NewAlbumDialogState extends State<NewAlbumDialog> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  final TextEditingController _albumNameController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  List<String> _tags = [];

  @override
  void dispose() {
    _albumNameController.dispose();
    _tagsController.dispose();
    _images = null;
    super.dispose();
  }

  void _validateTags() {
    final String input = _tagsController.text.trim();
    if (input.isNotEmpty) {
      final List<String> newTags = input
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      setState(() {
        _tags.addAll(newTags);
        _tagsController.clear();
      });
    }
  }

  Future<void> createAlbumAndUploadImages() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    final imagesProvider = Provider.of<ImagesProvider>(context, listen: false);
    final accessToken = userProvider.user?.accessToken;

    if (accessToken == null || _albumNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access token ou nom d\'album manquant.')));
      return;
    }

    try {
      final albumId = await albumProvider.createAlbum(
        _albumNameController.text,
        _tags,
        [], // Initialement pas d'images
        accessToken,
      );

      if (albumId != null) {
        for (XFile image in _images!) {
          try {
            final imageFile = await MultipartFile.fromFile(image.path,
                filename: path.basename(image.path),
                contentType: MediaType(
                    'image', path.extension(image.path).substring(1)));

            final uploadResponse =
                await imagesProvider.uploadImage(imageFile, accessToken);
            if (uploadResponse != null) {
              await albumProvider.addImageToAlbum(
                  albumId, uploadResponse.id, accessToken);
            } else {
              throw Exception('Échec de l\'upload de l\'image');
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Erreur lors de l\'ajout de l\'image à l\'album: $e')));
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Toutes les images ont été ajoutées avec succès à l\'album.')));
      } else {
        throw Exception('Échec de la création de l\'album.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }

    Navigator.of(context).pop();
  }

  Widget _buildTagsChips() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: _tags.map((String name) {
        return Chip(
          label: Text(name),
          onDeleted: () {
            setState(() {
              _tags.remove(name);
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer un Album'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _albumNameController,
              decoration: const InputDecoration(
                hintText: "Nom de l'album",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final List<XFile> selectedImages =
                    await _picker.pickMultiImage();
                if (selectedImages.isNotEmpty) {
                  setState(() {
                    _images = selectedImages;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Importer des Photos'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                hintText: "Entrez les tags (séparés par des virgules)",
              ),
            ),
            ElevatedButton(
              onPressed: _validateTags,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Ajouter des tags'),
            ),
            const SizedBox(height: 20),
            _buildTagsChips(),
            const SizedBox(height: 20),
            if (_images != null)
              for (var image in _images!) Text(image.name),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
          onPressed: createAlbumAndUploadImages,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
