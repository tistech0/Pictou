import 'package:test/test.dart';
import 'package:pictou_api/pictou_api.dart';

/// tests for AlbumsApi
void main() {
  final instance = PictouApi().getAlbumsApi();

  group(AlbumsApi, () {
    // Add an image to an album
    //
    // Add an image to an album
    //
    //Future<Album> addImageToAlbum(String id, String imageId) async
    test('test addImageToAlbum', () async {
      // TODO
    });

    // Create a new album
    //
    // Create a new album
    //
    //Future<Album> createAlbum(AlbumPost albumPost) async
    test('test createAlbum', () async {
      // TODO
    });

    // Delete an album
    //
    // Delete an album
    //
    //Future deleteAlbum(String id) async
    test('test deleteAlbum', () async {
      // TODO
    });

    // Modify an album
    //
    // Modify an album
    //
    //Future<Album> editAlbum(String id, AlbumPost albumPost) async
    test('test editAlbum', () async {
      // TODO
    });

    // Get an album by its id.
    //
    // Get an album by its id.
    //
    //Future<Album> getAlbum(String id) async
    test('test getAlbum', () async {
      // TODO
    });

    // Get a list of albums
    //
    // Get a list of albums
    //
    //Future<AlbumList> getAlbums({ int limit, int offset }) async
    test('test getAlbums', () async {
      // TODO
    });

    // Remove an image from an album
    //
    // Remove an image from an album
    //
    //Future<Album> removeImageFromAlbum(String id, String imageId) async
    test('test removeImageFromAlbum', () async {
      // TODO
    });
  });
}
