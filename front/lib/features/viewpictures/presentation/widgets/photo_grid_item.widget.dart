import 'package:flutter/material.dart';
import 'package:front/features/viewpictures/presentation/widgets/photo_viewer.widget.dart';

class PhotoGridItem extends StatelessWidget {
  final List<String> allImagePaths;

  final String imagePath;

  const PhotoGridItem({
    super.key,
    required this.imagePath,
    required this.allImagePaths,
  });

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
    final initialIndex = allImagePaths.indexOf(imagePath);
    showDialog(
      context: context,
      builder: (BuildContext context) => PhotoViewer(
        imagePaths: allImagePaths,
        initialIndex: initialIndex,
      ),
    );
  }
}
