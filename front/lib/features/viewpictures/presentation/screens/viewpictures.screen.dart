import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_grid_item.widget.dart';

class ViewPictures extends StatelessWidget {
  final String albumId;

  const ViewPictures({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    final album =
        albumProvider.albums.firstWhere((album) => album.id == albumId);

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: album.picturePath.length,
        itemBuilder: (context, index) {
          return PhotoGridItem(
            key: ValueKey(album.picturePath[index]),
            imagePath: album.picturePath[index],
          );
        },
      ),
    );
  }
}
