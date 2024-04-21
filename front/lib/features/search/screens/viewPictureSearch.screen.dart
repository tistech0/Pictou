import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/search/widgets/photo_viewer.widget.dart';

class ViewPicturesSearchScreen extends StatefulWidget {
  final List<String> imageIds;

  const ViewPicturesSearchScreen({super.key, required this.imageIds});

  @override
  State<ViewPicturesSearchScreen> createState() => _ViewPicturesSearchState(imageIds);
}

class _ViewPicturesSearchState extends State<ViewPicturesSearchScreen> {
  Stream<List<Uint8List>>? imageStream;
  late final List<String> _imageIds;

  _ViewPicturesSearchState(this._imageIds);

  @override
  void initState() {
    super.initState();
    _loadPictures();
  }

  Future<void> _loadPictures() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (userProvider.user?.accessToken != null) {
      imageStream = imageProvider.fetchImagesByIds(
          userProvider.user!.accessToken!, _imageIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result of search'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<Uint8List>>(
              stream: imageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final imageList = snapshot.data!;
                  return GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16),
                    children: List.generate(min(imageList.length, 3), (index) {
                      return GestureDetector(
                        onTap: () {
                          print('Image ID: ${_imageIds[index]}');
                        },
                        child: Image.memory(
                          imageList[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur lors du chargement des images: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
