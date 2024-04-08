import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/core/domain/entities/image.entity.dart'; // Assurez-vous d'importer ImageEntity
import 'package:front/features/viewpictures/presentation/screens/viewpictures.screen.dart';

class ContainerImageWidget extends StatelessWidget {
  final AlbumEntity album;
  final String
      title; // Il semble que le paramètre 'imageUrl' n'est pas utilisé. Supprimez-le si c'est le cas.

  const ContainerImageWidget({
    super.key,
    required this.album,
    required this.title,
    required imageUrl, // 'imageUrl' retiré puisqu'il n'est pas utilisé.
  });

  @override
  Widget build(BuildContext context) {
    // Assurez-vous d'avoir au moins une image par défaut ou un chemin d'image par défaut si 'images' est vide.
    String firstImagePath = album.images.isNotEmpty
        ? 'assets/images/default_image.webp' // Ajustez 'path' selon la structure de ImageEntity
        : 'assets/images/default_image.jpeg'; // Mettez un chemin par défaut valide ici

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (album.id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPictures(albumId: album.id),
                ),
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
                image: AssetImage(firstImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 175,
          child: Text(
            title, // Utilisez le paramètre 'title' au lieu de 'album.name' si c'était votre intention initiale.
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
