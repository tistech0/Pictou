import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/album.entity.dart';
import 'package:front/core/domain/entities/metadata.entity.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/userprovider.dart';
import 'metadata_dialogue.widget.dart';

class PhotoViewer extends StatefulWidget {
  final List<Uint8List> imageList;
  final int initialIndex;
  final String albumId;

  const PhotoViewer(
      {super.key, required this.imageList, required this.albumId, this.initialIndex = 0});

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  int _currentIndex = 0;
  final albumApi = Pictouapi().getAlbumsApi();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                    itemCount: widget.imageList.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        child: Image.memory(
                          widget.imageList[index],
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
                icon: Icon(Icons.info_outline, color: Colors.black),
                onPressed: () async {
                  final Response<Album> response = await albumApi.getAlbum(
                    id: widget.albumId,
                    headers: {
                      "Authorization": "Bearer ${userProvider.user
                          ?.accessToken}",
                    },
                  );
                  final Album? albumActual = response.data;
                  final ImageMetaData? imageMetadata = albumActual
                      ?.images[_currentIndex];
                  showMetadataDialog(context, imageMetadata!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
