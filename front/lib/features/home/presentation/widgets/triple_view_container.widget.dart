import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/core/domain/entities/image.entity.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/userprovider.dart';
import 'container_image.widget.dart';

class AlbumCarouselWidget extends StatefulWidget {
  final bool isShared;
  const AlbumCarouselWidget({super.key, required this.isShared});

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allAlbums = albumsProvider.albums;

    List<AlbumEntity> albums = allAlbums;
    if (widget.isShared) {
      final currentUserId = userProvider.user?.userId;
      albums = allAlbums.where((album) => album.ownerId != currentUserId).toList();
    }

    final splitPoint = (albums.length / 2).ceil();

    final firstLineAlbums = albums.take(splitPoint).toList();
    final secondLineAlbums = albums.skip(splitPoint).toList();

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
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<Uint8List?>(
      future: userProvider.user?.accessToken != null
          ? imageProvider.fetchFirstImageOfAlbum(userProvider.user!.accessToken!, album.id, ImageQuality.low)
          : Future.value(null),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the future to complete
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // Future completed successfully
          final imageByte = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: ContainerImageWidget(
              imageByte: imageByte,
              title: album.name,
              album: album,
            ),
          );
        }
      },
    );
  }
}
