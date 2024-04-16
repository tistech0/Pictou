import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/features/viewpictures/presentation/screens/viewpictures.screen.dart';

class ContainerImageWidget extends StatelessWidget {
  final AlbumEntity album;
  final String title;
  final Uint8List? imageByte;

  const ContainerImageWidget({
    super.key,
    required this.album,
    required this.title,
    this.imageByte,
  });

  @override
  Widget build(BuildContext context) {
    // Use default image if imageByte is null
    final image = imageByte != null
        ? Image.memory(imageByte!).image
        : const AssetImage('assets/images/default_image.jpeg'); // Set default image path here

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (album.id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPicture(albumId: album.id),
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
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 175,
          child: Text(
            title,
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
