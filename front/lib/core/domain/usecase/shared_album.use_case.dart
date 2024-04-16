import 'package:front/core/config/albumprovider.dart';

class ShareAlbumUseCase {
  AlbumProvider albumProvider;
  String accessToken;

  ShareAlbumUseCase({
    required this.albumProvider,
    required this.accessToken,
  });

  Future<void> execute(String albumId, String userEmail) async {
    await albumProvider.addShared(albumId, userEmail, accessToken);
    print(albumId);
    print(userEmail);
  }
}
