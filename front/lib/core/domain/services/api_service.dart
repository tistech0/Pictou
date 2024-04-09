import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  Dio dio = Dio();
  final baseUrl = dotenv.env['BASE_URL'];

  ApiService() {
    dio.options.baseUrl = '$baseUrl';

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ici, vous pourriez ajouter le token d'authentification si disponible
          // options.headers["Authorization"] = "Bearer $token";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Traitement des réponses
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // Gestion des erreurs
          return handler.next(e);
        },
      ),
      LogInterceptor(
          responseBody: true), // Afficher les logs pour le développement
    ]);
  }
}
