//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pictouapi/src/model/api_error_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error.g.dart';

/// ApiError
///
/// Properties:
/// * [description]
/// * [errorCode]
/// * [httpStatus]
@BuiltValue()
abstract class ApiError implements Built<ApiError, ApiErrorBuilder> {
  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'error_code')
  ApiErrorCode get errorCode;
  // enum errorCodeEnum {  UNKNOWN,  QUERY_PAYLOAD_ERROR,  JSON_PAYLOAD_ERROR,  PATH_ERROR,  NOT_FOUND_ERROR,  UNAUTHORIZED_ERROR,  FORBIDDEN_ERROR,  MISSING_IMAGE_PAYLOAD,  IMAGE_PAYLOAD_TOO_LARGE,  UNSUPPORTED_IMAGE_TYPE,  INVALID_ENCODING,  READ_ONLY,  IMAGE_CLASSIFIER_FAILURE,  };

  @BuiltValueField(wireName: r'http_status')
  int get httpStatus;

  ApiError._();

  factory ApiError([void updates(ApiErrorBuilder b)]) = _$ApiError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiError> get serializer => _$ApiErrorSerializer();
}

class _$ApiErrorSerializer implements PrimitiveSerializer<ApiError> {
  @override
  final Iterable<Type> types = const [ApiError, _$ApiError];

  @override
  final String wireName = r'ApiError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'error_code';
    yield serializers.serialize(
      object.errorCode,
      specifiedType: const FullType(ApiErrorCode),
    );
    yield r'http_status';
    yield serializers.serialize(
      object.httpStatus,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'error_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiErrorCode),
          ) as ApiErrorCode;
          result.errorCode = valueDes;
          break;
        case r'http_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.httpStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiErrorBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
