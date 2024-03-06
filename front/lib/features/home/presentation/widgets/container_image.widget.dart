import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/features/viewpictures/presentation/screens/viewpictures.screen.dart'; // Importez AlbumEntity

class ContainerImageWidget extends StatelessWidget {
  final AlbumEntity album;

  const ContainerImageWidget(
      {super.key,
      required this.album,
      required String imageUrl,
      required String title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (album.id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewPictures(albumId: album.id)),
              );
            }
          },
          child: Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(album.picturePath.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 175,
          child: Text(
            album.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
