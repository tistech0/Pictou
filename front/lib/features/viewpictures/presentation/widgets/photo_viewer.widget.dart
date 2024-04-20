import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/core/domain/usecase/deleted_picture.use_case.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:provider/provider.dart';

import 'metadata_dialogue.widget.dart';

class PhotoViewer extends StatefulWidget {
  final List<Uint8List> imageList;
  final int initialIndex;
  final String accessToken;
  final String albumId;
  final DeleteImageUseCase deleteImageUseCase;
  final VoidCallback onImageDeleted;

  const PhotoViewer({
    super.key,
    required this.imageList,
    required this.initialIndex,
    required this.accessToken,
    required this.albumId,
    required this.deleteImageUseCase,
    required this.onImageDeleted,
  });

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  String? _currentImageId;
  late int _currentIndex;
  final albumApi = Pictouapi().getAlbumsApi();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _fetchImageId(widget.initialIndex);
  }

  Future<void> _fetchImageId(int index) async {
    String? imageId = await Provider.of<ImagesProvider>(context, listen: false)
        .getImageIdByIndex(widget.accessToken, widget.albumId, index);
    if (mounted) {
      setState(() {
        _currentImageId = imageId;
        _currentIndex = index;
      });
    }
  }

  void _deleteImage() async {
    if (_currentImageId != null) {
      await widget.deleteImageUseCase.execute(_currentImageId!);
      widget.onImageDeleted(); // Appelle le callback après la suppression
      Navigator.of(context)
          .pop(); // Retourner à l'écran précédent après la suppression
    }
  }

  void _showImageDetails() {
    if (_currentImageId != null) {
      // Logique pour afficher les détails de l'image
      print('Affichage des détails pour l\'image avec ID: $_currentImageId');
    }
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
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _deleteImage();
                      },
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
                      "Authorization":
                          "Bearer ${userProvider.user?.accessToken}",
                    },
                  );
                  final Album? albumActual = response.data;
                  final ImageMetaData? imageMetadata =
                      albumActual?.images[_currentIndex];
                  showMetadataDialog(context, imageMetadata!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}