import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/core/domain/entities/image.entity.dart';
import 'package:provider/provider.dart';

import 'container_image.widget.dart';

class AlbumCarouselWidget extends StatefulWidget {
  const AlbumCarouselWidget({super.key});

  @override
  State<AlbumCarouselWidget> createState() => _AlbumCarouselWidgetState();
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
    final albumsProvider = Provider.of<AlbumProvider>(context, listen: true);
    final albums = albumsProvider.albums;

    final splitPoint = (albums.length / 2).ceil();

    final firstLineAlbums = albums.take(splitPoint).toList();
    final secondLineAlbums = albums.skip(splitPoint).toList();

    // Ajoute un album fictif si nécessaire pour équilibrer les lignes ou en l'absence d'albums
    if (albums.isEmpty || albums.length % 2 != 0) {
      secondLineAlbums.add(AlbumEntity(
        id: '',
        name: 'Album fictif',
        images: [
          ImageEntity(
            id: '',
            caption: 'Image par défaut',
            path: 'assets/images/default_image.jpeg',
            ownerId: '',
            sharedWith: [],
            tags: [],
          )
        ],
        ownerId: '',
        sharedWith: [],
        tags: [],
      ));
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
    final imageUrl = album.images.isNotEmpty
        ? album.images.first.path
        : 'assets/images/default_image.jpeg';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: ContainerImageWidget(
        imageUrl: imageUrl,
        title: album.name,
        album: album,
      ),
    );
  }
}
