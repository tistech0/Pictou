import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:front/core/domain/usecase/shared_album.use_case.dart';
import 'package:front/features/viewpictures/presentation/widgets/shared_album.widget.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/_global/presentation/widgets/bottom_bar.widget.dart';

import '../../../../core/domain/usecase/deleted_picture.use_case.dart';
import '../widgets/photo_viewer.widget.dart';

class ViewPicture extends StatefulWidget {
  final String albumId;

  const ViewPicture({super.key, required this.albumId});

  @override
  _ViewPicturesState createState() => _ViewPicturesState();
}

class _ViewPicturesState extends State<ViewPicture> {
  Stream<List<Uint8List>>? imageAlbumStream;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _loadPicture();
  }

  void _shareAlbum() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    ShareAlbumUseCase useCase = ShareAlbumUseCase(
      albumProvider: albumProvider,
      accessToken: userProvider.user!.accessToken!,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => ShareAlbumDialog(
        albumId: widget.albumId,
        useCase: useCase,
      ),
    );
  }

  Future<void> _loadPicture() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    final album = albumProvider.albums
        .firstWhereOrNull((album) => album.id == widget.albumId);

    if (userProvider.user?.accessToken != null && album != null) {
      _tags = album.tags;
      imageAlbumStream = imageProvider.fetchImagesAlbum(
          userProvider.user!.accessToken!, widget.albumId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final albumProvider = Provider.of<AlbumProvider>(context);
    final album = albumProvider.albums
        .firstWhereOrNull((album) => album.id == widget.albumId);

    if (album == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Album introuvable')),
        body: const Center(child: Text('Cet album n\'existe pas.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareAlbum();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeletion(context, albumProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<Uint8List>>(
              stream: imageAlbumStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final imageAlbum = snapshot.data!;
                  return GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16),
                    children: List.generate(imageAlbum.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PhotoViewer(
                                  imageList: imageAlbum,
                                  initialIndex: index,
                                  accessToken: userProvider.user!.accessToken!,
                                  albumId: widget.albumId,
                                  deleteImageUseCase: DeleteImageUseCase(
                                      Provider.of<ImagesProvider>(context,
                                          listen: false),
                                      userProvider.user!.accessToken!),
                                  onImageDeleted: () {
                                    _loadPicture();
                                  });
                            },
                          );
                        },
                        child: Image.memory(
                          imageAlbum[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  // Gère les erreurs lors du chargement des images
                  return Center(
                      child: Text(
                          'Erreur lors du chargement des images: ${snapshot.error}'));
                } else {
                  // Fallback pour tout autre cas non traité
                  return const Center(
                      child: Text("Quelque chose s'est mal passé"));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarWidget(
        selectedAlbum: album,
        accessToken: userProvider.user?.accessToken ?? '',
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Les images ont été ajoutées avec succès à l\'album')));
          _loadPicture();
        },
      ),
    );
  }

  void _confirmDeletion(BuildContext context, AlbumProvider albumProvider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer l\'album'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cet album ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Supprimer'),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () =>
                  _deleteAlbum(context, albumProvider, dialogContext),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAlbum(BuildContext context, AlbumProvider albumProvider,
      BuildContext dialogContext) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.accessToken != null) {
      await albumProvider.deleteAlbum(
          widget.albumId, userProvider.user!.accessToken!);
      if (userProvider.user?.accessToken != null) {
        albumProvider.fetchAlbums(userProvider.user!.accessToken!);
      }
      Navigator.of(dialogContext).pop();
      Navigator.of(context).pop();
    }
  }
}
