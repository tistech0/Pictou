// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiErrorCode _$UNKNOWN = const ApiErrorCode._('UNKNOWN');
const ApiErrorCode _$QUERY_PAYLOAD_ERROR =
    const ApiErrorCode._('QUERY_PAYLOAD_ERROR');
const ApiErrorCode _$JSON_PAYLOAD_ERROR =
    const ApiErrorCode._('JSON_PAYLOAD_ERROR');
const ApiErrorCode _$PATH_ERROR = const ApiErrorCode._('PATH_ERROR');
const ApiErrorCode _$NOT_FOUND_ERROR = const ApiErrorCode._('NOT_FOUND_ERROR');
const ApiErrorCode _$UNAUTHORIZED_ERROR =
    const ApiErrorCode._('UNAUTHORIZED_ERROR');
const ApiErrorCode _$FORBIDDEN_ERROR = const ApiErrorCode._('FORBIDDEN_ERROR');
const ApiErrorCode _$MISSING_IMAGE_PAYLOAD =
    const ApiErrorCode._('MISSING_IMAGE_PAYLOAD');
const ApiErrorCode _$IMAGE_PAYLOAD_TOO_LARGE =
    const ApiErrorCode._('IMAGE_PAYLOAD_TOO_LARGE');
const ApiErrorCode _$UNSUPPORTED_IMAGE_TYPE =
    const ApiErrorCode._('UNSUPPORTED_IMAGE_TYPE');
const ApiErrorCode _$INVALID_ENCODING =
    const ApiErrorCode._('INVALID_ENCODING');
const ApiErrorCode _$READ_ONLY = const ApiErrorCode._('READ_ONLY');
const ApiErrorCode _$IMAGE_CLASSIFIER_FAILURE =
    const ApiErrorCode._('IMAGE_CLASSIFIER_FAILURE');

ApiErrorCode _$valueOf(String name) {
  switch (name) {
    case 'UNKNOWN':
      return _$UNKNOWN;
    case 'QUERY_PAYLOAD_ERROR':
      return _$QUERY_PAYLOAD_ERROR;
    case 'JSON_PAYLOAD_ERROR':
      return _$JSON_PAYLOAD_ERROR;
    case 'PATH_ERROR':
      return _$PATH_ERROR;
    case 'NOT_FOUND_ERROR':
      return _$NOT_FOUND_ERROR;
    case 'UNAUTHORIZED_ERROR':
      return _$UNAUTHORIZED_ERROR;
    case 'FORBIDDEN_ERROR':
      return _$FORBIDDEN_ERROR;
    case 'MISSING_IMAGE_PAYLOAD':
      return _$MISSING_IMAGE_PAYLOAD;
    case 'IMAGE_PAYLOAD_TOO_LARGE':
      return _$IMAGE_PAYLOAD_TOO_LARGE;
    case 'UNSUPPORTED_IMAGE_TYPE':
      return _$UNSUPPORTED_IMAGE_TYPE;
    case 'INVALID_ENCODING':
      return _$INVALID_ENCODING;
    case 'READ_ONLY':
      return _$READ_ONLY;
    case 'IMAGE_CLASSIFIER_FAILURE':
      return _$IMAGE_CLASSIFIER_FAILURE;
    default:
      return _$IMAGE_CLASSIFIER_FAILURE;
  }
}

final BuiltSet<ApiErrorCode> _$values =
    new BuiltSet<ApiErrorCode>(const <ApiErrorCode>[
  _$UNKNOWN,
  _$QUERY_PAYLOAD_ERROR,
  _$JSON_PAYLOAD_ERROR,
  _$PATH_ERROR,
  _$NOT_FOUND_ERROR,
  _$UNAUTHORIZED_ERROR,
  _$FORBIDDEN_ERROR,
  _$MISSING_IMAGE_PAYLOAD,
  _$IMAGE_PAYLOAD_TOO_LARGE,
  _$UNSUPPORTED_IMAGE_TYPE,
  _$INVALID_ENCODING,
  _$READ_ONLY,
  _$IMAGE_CLASSIFIER_FAILURE,
]);

class _$ApiErrorCodeMeta {
  const _$ApiErrorCodeMeta();
  ApiErrorCode get UNKNOWN => _$UNKNOWN;
  ApiErrorCode get QUERY_PAYLOAD_ERROR => _$QUERY_PAYLOAD_ERROR;
  ApiErrorCode get JSON_PAYLOAD_ERROR => _$JSON_PAYLOAD_ERROR;
  ApiErrorCode get PATH_ERROR => _$PATH_ERROR;
  ApiErrorCode get NOT_FOUND_ERROR => _$NOT_FOUND_ERROR;
  ApiErrorCode get UNAUTHORIZED_ERROR => _$UNAUTHORIZED_ERROR;
  ApiErrorCode get FORBIDDEN_ERROR => _$FORBIDDEN_ERROR;
  ApiErrorCode get MISSING_IMAGE_PAYLOAD => _$MISSING_IMAGE_PAYLOAD;
  ApiErrorCode get IMAGE_PAYLOAD_TOO_LARGE => _$IMAGE_PAYLOAD_TOO_LARGE;
  ApiErrorCode get UNSUPPORTED_IMAGE_TYPE => _$UNSUPPORTED_IMAGE_TYPE;
  ApiErrorCode get INVALID_ENCODING => _$INVALID_ENCODING;
  ApiErrorCode get READ_ONLY => _$READ_ONLY;
  ApiErrorCode get IMAGE_CLASSIFIER_FAILURE => _$IMAGE_CLASSIFIER_FAILURE;
  ApiErrorCode valueOf(String name) => _$valueOf(name);
  BuiltSet<ApiErrorCode> get values => _$values;
}

abstract class _$ApiErrorCodeMixin {
  // ignore: non_constant_identifier_names
  _$ApiErrorCodeMeta get ApiErrorCode => const _$ApiErrorCodeMeta();
}

Serializer<ApiErrorCode> _$apiErrorCodeSerializer =
    new _$ApiErrorCodeSerializer();

class _$ApiErrorCodeSerializer implements PrimitiveSerializer<ApiErrorCode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNKNOWN': 'UNKNOWN',
    'QUERY_PAYLOAD_ERROR': 'QUERY_PAYLOAD_ERROR',
    'JSON_PAYLOAD_ERROR': 'JSON_PAYLOAD_ERROR',
    'PATH_ERROR': 'PATH_ERROR',
    'NOT_FOUND_ERROR': 'NOT_FOUND_ERROR',
    'UNAUTHORIZED_ERROR': 'UNAUTHORIZED_ERROR',
    'FORBIDDEN_ERROR': 'FORBIDDEN_ERROR',
    'MISSING_IMAGE_PAYLOAD': 'MISSING_IMAGE_PAYLOAD',
    'IMAGE_PAYLOAD_TOO_LARGE': 'IMAGE_PAYLOAD_TOO_LARGE',
    'UNSUPPORTED_IMAGE_TYPE': 'UNSUPPORTED_IMAGE_TYPE',
    'INVALID_ENCODING': 'INVALID_ENCODING',
    'READ_ONLY': 'READ_ONLY',
    'IMAGE_CLASSIFIER_FAILURE': 'IMAGE_CLASSIFIER_FAILURE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNKNOWN': 'UNKNOWN',
    'QUERY_PAYLOAD_ERROR': 'QUERY_PAYLOAD_ERROR',
    'JSON_PAYLOAD_ERROR': 'JSON_PAYLOAD_ERROR',
    'PATH_ERROR': 'PATH_ERROR',
    'NOT_FOUND_ERROR': 'NOT_FOUND_ERROR',
    'UNAUTHORIZED_ERROR': 'UNAUTHORIZED_ERROR',
    'FORBIDDEN_ERROR': 'FORBIDDEN_ERROR',
    'MISSING_IMAGE_PAYLOAD': 'MISSING_IMAGE_PAYLOAD',
    'IMAGE_PAYLOAD_TOO_LARGE': 'IMAGE_PAYLOAD_TOO_LARGE',
    'UNSUPPORTED_IMAGE_TYPE': 'UNSUPPORTED_IMAGE_TYPE',
    'INVALID_ENCODING': 'INVALID_ENCODING',
    'READ_ONLY': 'READ_ONLY',
    'IMAGE_CLASSIFIER_FAILURE': 'IMAGE_CLASSIFIER_FAILURE',
  };

  @override
  final Iterable<Type> types = const <Type>[ApiErrorCode];
  @override
  final String wireName = 'ApiErrorCode';

  @override
  Object serialize(Serializers serializers, ApiErrorCode object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiErrorCode deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiErrorCode.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
