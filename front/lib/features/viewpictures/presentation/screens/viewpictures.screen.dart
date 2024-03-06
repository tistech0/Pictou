import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_grid_item.widget.dart';

class ViewPictures extends StatelessWidget {
  final String albumId;

  const ViewPictures({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    final album =
        AlbumProvider().albums.firstWhere((album) => album.id == albumId);

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Nombre de colonnes
          crossAxisSpacing: 4, // Espace horizontal entre les éléments
          mainAxisSpacing: 4, // Espace vertical entre les éléments
        ),
        itemCount: album.picturePath.length,
        itemBuilder: (context, index) {
          return PhotoGridItem(imagePath: album.picturePath[index]);
        },
      ),
    );
  }
}
