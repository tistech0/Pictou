import 'dart:typed_data';

import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  final List<Uint8List> imageList;
  final int initialIndex;

  const PhotoViewer(
      {super.key, required this.imageList, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: imageList.length,
                    controller: PageController(initialPage: initialIndex),
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        child: Image.memory(
                          imageList[index],
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
