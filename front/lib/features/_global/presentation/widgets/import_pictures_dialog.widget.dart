import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart'; // Assurez-vous que le chemin d'accès est correct
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImportPicturesDialog extends StatefulWidget {
  const ImportPicturesDialog({super.key});

  @override
  State<ImportPicturesDialog> createState() => _ImportPicturesDialogState();
}

class _ImportPicturesDialogState extends State<ImportPicturesDialog> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedAlbum;

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
                value: album
                    .name, // Utilisez l'identifiant ou un identificateur unique ici si nécessaire
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
                // Logique pour traiter les images sélectionnées pour l'album
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
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
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
