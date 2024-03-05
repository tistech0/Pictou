import 'package:flutter/material.dart';
import 'package:front_t_dev_800/features/home_configuration/domain/entities/album.entity.dart';
import 'package:provider/provider.dart';
import 'package:front_t_dev_800/core/config/albumprovider.dart';
import 'package:front_t_dev_800/features/homepage/presentation/widgets/container_image.widget.dart';

class TripleContainerWidget extends StatefulWidget {
  const TripleContainerWidget({Key? key}) : super(key: key);

  @override
  State<TripleContainerWidget> createState() => _TripleContainerWidgetState();
}

class _TripleContainerWidgetState extends State<TripleContainerWidget> {
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
    final albums = Provider.of<AlbumProvider>(context).albums;
    int splitPoint = (albums.length / 2).ceil();

    var firstLineAlbums = albums.take(splitPoint).toList();
    var secondLineAlbums = albums.skip(splitPoint).toList();

    // Ajustez selon que vous ayez un nombre pair ou impair d'albums
    if (albums.length % 2 != 0) {
      // Assurez-vous que l'album fictif pour l'alignement a la même structure mais sans contenu
      secondLineAlbums.add(AlbumEntity(name: '', picturePath: []));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: firstLineAlbums
                .map((album) => _buildAlbumWidget(album))
                .toList(),
          ),
          const SizedBox(height: 20), // Espacement entre les deux lignes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: secondLineAlbums
                .map((album) => _buildAlbumWidget(album))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumWidget(AlbumEntity album) {
    String imageUrl =
        album.picturePath.isNotEmpty ? album.picturePath.first : '';
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerImageWidget(imageUrl: imageUrl),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              album.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
