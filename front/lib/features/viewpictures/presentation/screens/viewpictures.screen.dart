import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_grid_item.widget.dart';
import 'package:front/features/_global/presentation/widgets/bottom_bar.widget.dart';

class ViewPictures extends StatelessWidget {
  final String albumId;

  const ViewPictures({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    // Rendre album nullable pour permettre le retour de null.
    final AlbumEntity album = albumProvider.albums.firstWhere(
        (album) => album.id == albumId,
        orElse: () => [] as AlbumEntity);

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
            onPressed: () {
              // Logique pour supprimer l'album
            },
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
            allImagePaths: [''],
          );
        },
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }
}
