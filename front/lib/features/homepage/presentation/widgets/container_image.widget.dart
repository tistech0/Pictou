import 'package:flutter/material.dart';
import 'package:front/features/home_configuration/domain/entities/album.entity.dart';
import 'package:front/features/viewpictures/presentation/screens/viewpictures.screen.dart'; // Importez AlbumEntity

class ContainerImageWidget extends StatelessWidget {
  final AlbumEntity album;

  const ContainerImageWidget(
      {Key? key,
      required this.album,
      required String imageUrl,
      required String title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // Utilisez l'ID de l'album pour la navigation
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPictures(albumId: album.id)),
            );
          },
          child: Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(album.picturePath
                    .first), // Utilisez la première image de l'album
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
