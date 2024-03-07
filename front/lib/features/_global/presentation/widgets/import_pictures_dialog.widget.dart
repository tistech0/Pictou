import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImportPicturesDialog extends StatefulWidget {
  const ImportPicturesDialog({super.key});

  @override
  State<ImportPicturesDialog> createState() => _NewAlbumDialogState();
}

class _NewAlbumDialogState extends State<ImportPicturesDialog> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedAlbum;
  List<String> _albums = ['Album 1', 'Album 2', 'Album 3'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importer des Photos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAlbum,
            hint: const Text('Sélectionnez un album'),
            items: _albums.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
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
              // Ici, ajoutez votre logique pour importer les images dans l'album sélectionné
              if (images != null && images.isNotEmpty) {
                // Logique pour traiter les images sélectionnées
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
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
