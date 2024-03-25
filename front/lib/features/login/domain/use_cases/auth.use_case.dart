import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/core/domain/services/api_service.dart';

enum AuthAction { signInWithGoogle, signOut, refreshToken }

class AuthUseCase {
  final ApiService apiService;

  AuthUseCase(this.apiService);

  Future<void> execute(AuthAction action, BuildContext context) async {
    switch (action) {
      case AuthAction.signInWithGoogle:
        await _signInWithGoogle(context);
        break;
      case AuthAction.signOut:
        await _signOut(context);
        break;
      case AuthAction.refreshToken:
        await _refreshToken(context);
        break;
      default:
        throw Exception('Action non supportée');
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      var response = await apiService.dio.get('/auth/google');
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Gérer la réponse non réussie
      }
    } on DioError catch (e) {
      // Gérer l'erreur de réseau ou du serveur
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      var response = await apiService.dio.get('/auth/signout');
      if (response.statusCode == 200) {
        // Gérer la déconnexion avec succès
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // Gérer la réponse non réussie
      }
    } on DioError catch (e) {
      // Gérer l'erreur de réseau ou du serveur
    }
  }

  Future<void> _refreshToken(BuildContext context) async {
    try {
      var response = await apiService.dio.get('/auth/refresh');
      if (response.statusCode == 200) {
        // Gérer le rafraîchissement du token avec succès
      } else {
        // Gérer la réponse non réussie
      }
    } on DioError catch (e) {
      // Gérer l'erreur de réseau ou du serveur
    }
  }
}
