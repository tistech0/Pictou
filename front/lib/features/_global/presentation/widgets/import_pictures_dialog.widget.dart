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
  final TextEditingController _tagsController = TextEditingController();
  Set<String> _tags = {};
  UploadImagesUseCase? _uploadImagesUseCase;
  List<XFile>? _selectedImages;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    initializeUploadImagesUseCase();
  }

  void _validateTags() {
    final String input = _tagsController.text.trim();
    if (input.isNotEmpty) {
      final List<String> newTags =
          input.split(' ').where((tag) => tag.isNotEmpty).toSet().toList();
      setState(() {
        _tags.addAll(newTags);
        _tagsController.clear();
      });
    }
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
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Les images ont été ajoutées avec succès à l\'album')));
  }

  Future<void> _uploadImages(List<XFile> images) async {
    setState(() {
      _isUploading = true;
    });
    if (_uploadImagesUseCase != null && images.isNotEmpty) {
      await _uploadImagesUseCase!.call(_selectedAlbum, images, _tags.toList());
    } else {
      print("Aucune image sélectionnée ou problème de configuration.");
    }
    setState(() {
      _isUploading = false;
    });
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
    final albumProvider = Provider.of<AlbumProvider>(context);
    final albums = albumProvider.albums;

    return AlertDialog(
      title: const Text('Importer des Photos'),
      content: SingleChildScrollView(
        child: Column(
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
                final List<XFile>? images = await _picker.pickMultiImage();
                if (images != null && images.isNotEmpty) {
                  print("${images.length} images picked.");
                  setState(() {
                    _selectedImages = images;
                  });
                } else {
                  print("No images selected.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Choisir des Photos'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                hintText: "Entrez les tags (séparés par des espaces)",
              ),
            ),
            ElevatedButton(
              onPressed: _validateTags,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Ajouter des tags'),
            ),
            const SizedBox(height: 10),
            _buildTagsChips(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.red,
          ),
        ),
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () async {
                  if (_selectedImages != null && _selectedImages!.isNotEmpty) {
                    await _uploadImages(_selectedImages!);
                  } else {
                    print("No images selected.");
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: _isUploading
              ? const CircularProgressIndicator()
              : const Text('Upload'),
        ),
      ],
    );
  }
}
