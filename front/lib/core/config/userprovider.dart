import 'package:flutter/material.dart';
import '../domain/entities/user.entity.dart';

class UserProvider with ChangeNotifier {
  UserEntity? _user;

  UserProvider(this._user);

  UserEntity? get user => _user;

  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
