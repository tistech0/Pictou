import 'package:dio/dio.dart';

class ApiService {
  Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = 'http://localhost:8000/api';

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
