import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/core/domain/usecase/shared_album.use_case.dart';

class ShareAlbumDialog extends StatefulWidget {
  final String albumId;
  final ShareAlbumUseCase useCase;

  const ShareAlbumDialog({
    super.key,
    required this.albumId,
    required this.useCase,
  });

  @override
  State<ShareAlbumDialog> createState() => _ShareAlbumDialogState();
}

class _ShareAlbumDialogState extends State<ShareAlbumDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Partager l\'album'),
      content: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email de l\'utilisateur',
          hintText: 'Entrez l\'email pour partager',
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.error,
            )),
        TextButton(
            onPressed: () async {
              await widget.useCase
                  .execute(widget.albumId, _emailController.text);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Album partagé avec succès !')));
            },
            child: const Text('Partager'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green, // Couleur de fond
            )),
      ],
    );
  }
}
