import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/core/domain/services/api_service.dart';

class SignInWithGoogleUseCase {
  final ApiService apiService;

  SignInWithGoogleUseCase(this.apiService);

  Future<void> execute(BuildContext context) async {
    // Logique d'authentification en utilisant apiService.dio
    // Ceci est un exemple basique. Adaptez-le selon votre logique backend.
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
}
