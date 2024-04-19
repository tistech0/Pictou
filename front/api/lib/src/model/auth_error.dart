//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_error.g.dart';

/// AuthError
///
/// Properties:
/// * [description]
/// * [errorCode]
/// * [httpStatus]
@BuiltValue()
abstract class AuthError implements Built<AuthError, AuthErrorBuilder> {
  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'error_code')
  AuthErrorErrorCodeEnum get errorCode;
  // enum errorCodeEnum {  INVALID_CREDENTIALS,  INVALID_AUTHORIZATION_HEADER,  INVALID_TOKEN,  OAUTH2_PROVIDER_ERROR,  OAUTH2_AUTHORIZATION_DENIED,  OAUTH2_INVALID_STATE,  OAUTH2_FORBIDDEN,  INVALID_CLIENT_TYPE,  INTERNAL_ERROR,  };

  @BuiltValueField(wireName: r'http_status')
  int get httpStatus;

  AuthError._();

  factory AuthError([void updates(AuthErrorBuilder b)]) = _$AuthError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthError> get serializer => _$AuthErrorSerializer();
}

class _$AuthErrorSerializer implements PrimitiveSerializer<AuthError> {
  @override
  final Iterable<Type> types = const [AuthError, _$AuthError];

  @override
  final String wireName = r'AuthError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthError object, {
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
      specifiedType: const FullType(AuthErrorErrorCodeEnum),
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
    AuthError object, {
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
    required AuthErrorBuilder result,
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
            specifiedType: const FullType(AuthErrorErrorCodeEnum),
          ) as AuthErrorErrorCodeEnum;
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
  AuthError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthErrorBuilder();
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

class AuthErrorErrorCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'INVALID_CREDENTIALS')
  static const AuthErrorErrorCodeEnum INVALID_CREDENTIALS =
      _$authErrorErrorCodeEnum_INVALID_CREDENTIALS;
  @BuiltValueEnumConst(wireName: r'INVALID_AUTHORIZATION_HEADER')
  static const AuthErrorErrorCodeEnum INVALID_AUTHORIZATION_HEADER =
      _$authErrorErrorCodeEnum_INVALID_AUTHORIZATION_HEADER;
  @BuiltValueEnumConst(wireName: r'INVALID_TOKEN')
  static const AuthErrorErrorCodeEnum INVALID_TOKEN =
      _$authErrorErrorCodeEnum_INVALID_TOKEN;
  @BuiltValueEnumConst(wireName: r'OAUTH2_PROVIDER_ERROR')
  static const AuthErrorErrorCodeEnum oAUTH2PROVIDERERROR =
      _$authErrorErrorCodeEnum_oAUTH2PROVIDERERROR;
  @BuiltValueEnumConst(wireName: r'OAUTH2_AUTHORIZATION_DENIED')
  static const AuthErrorErrorCodeEnum oAUTH2AUTHORIZATIONDENIED =
      _$authErrorErrorCodeEnum_oAUTH2AUTHORIZATIONDENIED;
  @BuiltValueEnumConst(wireName: r'OAUTH2_INVALID_STATE')
  static const AuthErrorErrorCodeEnum oAUTH2INVALIDSTATE =
      _$authErrorErrorCodeEnum_oAUTH2INVALIDSTATE;
  @BuiltValueEnumConst(wireName: r'OAUTH2_FORBIDDEN')
  static const AuthErrorErrorCodeEnum oAUTH2FORBIDDEN =
      _$authErrorErrorCodeEnum_oAUTH2FORBIDDEN;
  @BuiltValueEnumConst(wireName: r'INVALID_CLIENT_TYPE')
  static const AuthErrorErrorCodeEnum INVALID_CLIENT_TYPE =
      _$authErrorErrorCodeEnum_INVALID_CLIENT_TYPE;
  @BuiltValueEnumConst(wireName: r'INTERNAL_ERROR', fallback: true)
  static const AuthErrorErrorCodeEnum INTERNAL_ERROR =
      _$authErrorErrorCodeEnum_INTERNAL_ERROR;

  static Serializer<AuthErrorErrorCodeEnum> get serializer =>
      _$authErrorErrorCodeEnumSerializer;

  const AuthErrorErrorCodeEnum._(String name) : super(name);

  static BuiltSet<AuthErrorErrorCodeEnum> get values =>
      _$authErrorErrorCodeEnumValues;
  static AuthErrorErrorCodeEnum valueOf(String name) =>
      _$authErrorErrorCodeEnumValueOf(name);
}
