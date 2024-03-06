import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  final String imagePath;

  const PhotoViewer({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
