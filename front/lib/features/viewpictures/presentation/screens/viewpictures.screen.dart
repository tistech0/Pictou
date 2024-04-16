import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/imagesprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/_global/presentation/widgets/bottom_bar.widget.dart';

class ViewPicture extends StatefulWidget {
  final String albumId;

  const ViewPicture({Key? key, required this.albumId}) : super(key: key);

  @override
  _ViewPicturesState createState() => _ViewPicturesState();
}

class _ViewPicturesState extends State<ViewPicture> {
  late Future<List<Uint8List>> imageAlbumFuture;

  @override
  void initState() {
    super.initState();
    _loadPicture();
  }

  Future<void> _loadPicture() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    if (userProvider.user?.accessToken != null) {
      imageAlbumFuture = imageProvider.fetchImages(
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
              // Logique pour partager l'album
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeletion(context, albumProvider),
          ),
        ],
      ),
      body: FutureBuilder<List<Uint8List>>(
        future: imageAlbumFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Image.memory(snapshot.data![index], fit: BoxFit.cover);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return const Center(child: Text('Aucune image dans cet album.'));
          }
        },
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
