import 'package:flutter/material.dart';

class ContainerImageWidget extends StatelessWidget {
  final String imageUrl;

  const ContainerImageWidget({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.lightBlueAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
