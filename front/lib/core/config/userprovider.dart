import 'package:flutter/material.dart';
import 'package:front/core/domain/entities/user.entity.dart';

class UserProvider with ChangeNotifier {
  late final UserEntity _user;

  UserProvider();

  UserEntity get user => _user;

  void updateUserAccessToken(String newAccessToken) {
    _user.accessToken = newAccessToken;
    notifyListeners();
  }

  void setUser(UserEntity newUser) {
    _user = newUser;
    notifyListeners();
  }
}
