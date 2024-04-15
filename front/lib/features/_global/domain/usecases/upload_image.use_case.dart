import 'package:dio/dio.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:pictouapi/src/model/image_upload_response.dart';

class UploadImageUseCase {
  final Dio _dio;
  final Pictouapi _pictouApi;

  UploadImageUseCase(this._dio, this._pictouApi);

  Future<Response<ImageUploadResponse>> uploadImage({
    required MultipartFile image,
    String? accessToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/images';
    final _options = Options(
      method: r'POST',
      headers: {
        "Authorization": "Bearer $accessToken",
      },
      contentType: 'multipart/form-data',
    );

    FormData _bodyData = FormData.fromMap({
      'image': image,
    });

    try {
      final _response = await _dio.request<ImageUploadResponse>(
        _path,
        data: _bodyData,
        options: _options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _response; // Retourne directement la réponse Dio
    } catch (e, stackTrace) {
      // Vous pouvez gérer l'exception plus spécifiquement ou la relancer
      print("Exception lors de l'upload de l'image: $e");
      print(stackTrace);
      throw e; // Renvoyer l'exception pour gestion externe
    }
  }
}
