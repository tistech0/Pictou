import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
// Supposons que AlbumProvider est accessible globalement ou injecté via un constructeur ou un contexte

class ViewPictures extends StatelessWidget {
  final String albumId; // Modifier pour stocker albumId
  const ViewPictures({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    final album =
        AlbumProvider().albums.firstWhere((album) => album.id == albumId);

    // Si l'album n'est pas trouvé, afficher un message d'erreur
    if (album == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Album Introuvable'),
        ),
        body: const Center(
          child: Text('Aucun album correspondant trouvé.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name), // Utiliser le nom de l'album comme titre
      ),
      body: ListView.builder(
        itemCount: album.picturePath.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(album.picturePath[index]),
            title: Text('Image ${index + 1}'),
          );
        },
      ),
    );
  }
}
