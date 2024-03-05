import 'package:flutter/material.dart';
import 'package:front_t_dev_800/features/home_configuration/domain/entities/album.entity.dart';
import 'package:provider/provider.dart';
import 'package:front_t_dev_800/core/config/albumprovider.dart';
import 'package:front_t_dev_800/features/homepage/presentation/widgets/container_image.widget.dart';

class TripleContainerWidget extends StatelessWidget {
  const TripleContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albums = Provider.of<AlbumProvider>(context).albums;
    int splitPoint = (albums.length / 2).ceil();

    var firstLineAlbums = albums.take(splitPoint).toList();
    var secondLineAlbums = albums.skip(splitPoint).toList();

    return Column(
      children: [
        // Première ligne avec possibilité de défilement horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: firstLineAlbums
                .map((album) => _buildAlbumWidget(album))
                .toList(),
          ),
        ),
        SizedBox(height: 20), // Espace entre les lignes
        // Deuxième ligne avec possibilité de défilement horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: secondLineAlbums
                .map((album) => _buildAlbumWidget(album))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumWidget(AlbumEntity album) {
    String imageUrl =
        album.picturePath.isNotEmpty ? album.picturePath.first : '';
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerImageWidget(imageUrl: imageUrl),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              album.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
