import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/user.entity.dart';

class UserProvider with ChangeNotifier {
  final UserEntity _user;

  UserProvider(this._user);

  UserEntity get user => _user;

  void updateUserAccessToken(String newAccessToken) {
    _user.accessToken = newAccessToken;
    notifyListeners();
  }
}
