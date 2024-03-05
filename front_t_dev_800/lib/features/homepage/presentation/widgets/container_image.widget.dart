import 'package:flutter/material.dart';

class ContainerImageWidget extends StatelessWidget {
  final String imageUrl;
  final String title; // Ajout du titre de l'album

  const ContainerImageWidget(
      {Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 175,
          height: 175,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8), // Espacement entre l'image et le titre
        SizedBox(
          width: 175, // Largeur fixe identique à celle de l'image
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1, // Limite le texte à une seule ligne
            overflow: TextOverflow
                .ellipsis, // Ajoute des points de suspension si le texte dépasse
          ),
        ),
      ],
    );
  }
}
