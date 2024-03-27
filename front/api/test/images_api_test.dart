import 'package:test/test.dart';
import 'package:pictou_api/pictou_api.dart';

/// tests for ImagesApi
void main() {
  final instance = PictouApi().getImagesApi();

  group(ImagesApi, () {
    // Delete an image
    //
    // Delete an image
    //
    //Future deleteImage(String id) async
    test('test deleteImage', () async {
      // TODO
    });

    // Set/modfiy image metadata, share/unshare, ...
    //
    // Set/modfiy image metadata, share/unshare, ...
    //
    //Future<ImageMetaData> editImage(String id, ImagePatch imagePatch) async
    test('test editImage', () async {
      // TODO
    });

    // Get an image by its id.
    //
    // Get an image by its id.
    //
    //Future<Uint8List> getImage(String id, { ImageQuality quality }) async
    test('test getImage', () async {
      // TODO
    });

    // Get the images owned by or shared with the user
    //
    // Get the images owned by or shared with the user  This method returns the metadata of the images not the effective images. The client must make a request for each image independently. The list can be filtered by quality, and paginated.
    //
    //Future<ImagesMetaData> getImages({ int limit, int offset, ImageQuality quality }) async
    test('test getImages', () async {
      // TODO
    });

    // Upload an image
    //
    // Upload an image
    //
    //Future<ImageUploadResponse> uploadImage(MultipartFile image) async
    test('test uploadImage', () async {
      // TODO
    });
  });
}
