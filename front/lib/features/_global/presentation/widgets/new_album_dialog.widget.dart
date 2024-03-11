import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewAlbumDialog extends StatefulWidget {
  const NewAlbumDialog({super.key});

  @override
  State<NewAlbumDialog> createState() => _NewAlbumDialogState();
}

class _NewAlbumDialogState extends State<NewAlbumDialog> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer un Album'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
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
            if (_images != null)
              for (var image in _images!) Text(image.name),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
