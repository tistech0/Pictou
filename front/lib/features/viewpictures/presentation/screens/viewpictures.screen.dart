import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_grid_item.widget.dart';
import 'package:front/features/_global/presentation/widgets/bottom_bar.widget.dart';

class ViewPictures extends StatelessWidget {
  final String albumId;

  const ViewPictures({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    final album =
        albumProvider.albums.firstWhereOrNull((album) => album.id == albumId);

    if (album == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Album introuvable')),
        body: const Center(child: Text('Cet album n\'existe pas.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Logique pour partager l'album
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeletion(context, albumProvider),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: album.images.length,
        itemBuilder: (context, index) {
          final image = album.images[index];
          return PhotoGridItem(
            key: ValueKey(image.id),
            imagePath: image.path,
            allImagePaths: album.images.map((e) => e.path).toList(),
          );
        },
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  void _confirmDeletion(BuildContext context, AlbumProvider albumProvider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer l\'album'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cet album ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              style: TextButton.styleFrom(primary: Colors.black),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Supprimer'),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () =>
                  _deleteAlbum(context, albumProvider, dialogContext),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAlbum(BuildContext context, AlbumProvider albumProvider,
      BuildContext dialogContext) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.accessToken != null) {
      await albumProvider.deleteAlbum(albumId, userProvider.user!.accessToken!);
      if (userProvider.user?.accessToken != null) {
        albumProvider.fetchAlbums(userProvider.user!.accessToken!);
      }
      Navigator.of(dialogContext).pop(); // Ferme la popup
      Navigator.of(context).pop(); // Retour à la page précédente ou à la home
    }
  }
}
