import 'package:flutter/material.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_viewer.widget.dart';

class PhotoGridItem extends StatelessWidget {
  final String imagePath;

  const PhotoGridItem({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoViewer(context),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  void _showPhotoViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => PhotoViewer(imagePath: imagePath),
    );
  }
}
