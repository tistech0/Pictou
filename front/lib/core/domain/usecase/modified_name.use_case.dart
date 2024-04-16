import 'package:front/core/config/userprovider.dart';

class ModifiedNameUseCase {
  UserProvider userProvider;
  String accessToken;

  ModifiedNameUseCase({
    required this.userProvider,
    required this.accessToken,
  });

  Future<void> execute(String name) async {}
}
