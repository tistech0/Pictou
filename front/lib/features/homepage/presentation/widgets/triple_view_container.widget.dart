import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/home_configuration/domain/entities/album.entity.dart';
import 'package:provider/provider.dart';

import 'container_image.widget.dart'; // Nom modifié pour suivre les conventions Dart

class AlbumCarouselWidget extends StatefulWidget {
  const AlbumCarouselWidget({Key? key}) : super(key: key);

  @override
  _AlbumCarouselWidgetState createState() => _AlbumCarouselWidgetState();
}

class _AlbumCarouselWidgetState extends State<AlbumCarouselWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albums = context.watch<AlbumProvider>().albums;
    final splitPoint = (albums.length / 2).ceil();

    final firstLineAlbums = albums.take(splitPoint).toList();
    final secondLineAlbums = albums.skip(splitPoint).toList();

    if (albums.length % 2 != 0) {
      secondLineAlbums.add(AlbumEntity(
          name: "", picturePath: ["assets/images/default_image.webp"], id: ''));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Column(
        children: [
          _buildAlbumsRow(firstLineAlbums),
          const SizedBox(height: 20),
          _buildAlbumsRow(secondLineAlbums),
        ],
      ),
    );
  }

  Widget _buildAlbumsRow(List<AlbumEntity> albums) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: albums.map(_buildAlbumWidget).toList(),
    );
  }

  Widget _buildAlbumWidget(AlbumEntity album) {
    final imageUrl =
        album.picturePath.isNotEmpty ? album.picturePath.first : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: ContainerImageWidget(
        imageUrl: imageUrl,
        title: album.name,
        album: album, // Ajout de l'instance de l'album
      ),
    );
  }
}
