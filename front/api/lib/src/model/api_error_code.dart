//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error_code.g.dart';

class ApiErrorCode extends EnumClass {
  @BuiltValueEnumConst(wireName: r'UNKNOWN')
  static const ApiErrorCode UNKNOWN = _$UNKNOWN;
  @BuiltValueEnumConst(wireName: r'QUERY_PAYLOAD_ERROR')
  static const ApiErrorCode QUERY_PAYLOAD_ERROR = _$QUERY_PAYLOAD_ERROR;
  @BuiltValueEnumConst(wireName: r'JSON_PAYLOAD_ERROR')
  static const ApiErrorCode JSON_PAYLOAD_ERROR = _$JSON_PAYLOAD_ERROR;
  @BuiltValueEnumConst(wireName: r'PATH_ERROR')
  static const ApiErrorCode PATH_ERROR = _$PATH_ERROR;
  @BuiltValueEnumConst(wireName: r'NOT_FOUND_ERROR')
  static const ApiErrorCode NOT_FOUND_ERROR = _$NOT_FOUND_ERROR;
  @BuiltValueEnumConst(wireName: r'UNAUTHORIZED_ERROR')
  static const ApiErrorCode UNAUTHORIZED_ERROR = _$UNAUTHORIZED_ERROR;
  @BuiltValueEnumConst(wireName: r'FORBIDDEN_ERROR')
  static const ApiErrorCode FORBIDDEN_ERROR = _$FORBIDDEN_ERROR;
  @BuiltValueEnumConst(wireName: r'MISSING_IMAGE_PAYLOAD')
  static const ApiErrorCode MISSING_IMAGE_PAYLOAD = _$MISSING_IMAGE_PAYLOAD;
  @BuiltValueEnumConst(wireName: r'IMAGE_PAYLOAD_TOO_LARGE')
  static const ApiErrorCode IMAGE_PAYLOAD_TOO_LARGE = _$IMAGE_PAYLOAD_TOO_LARGE;
  @BuiltValueEnumConst(wireName: r'UNSUPPORTED_IMAGE_TYPE')
  static const ApiErrorCode UNSUPPORTED_IMAGE_TYPE = _$UNSUPPORTED_IMAGE_TYPE;
  @BuiltValueEnumConst(wireName: r'INVALID_ENCODING')
  static const ApiErrorCode INVALID_ENCODING = _$INVALID_ENCODING;
  @BuiltValueEnumConst(wireName: r'READ_ONLY', fallback: true)
  static const ApiErrorCode READ_ONLY = _$READ_ONLY;

  static Serializer<ApiErrorCode> get serializer => _$apiErrorCodeSerializer;

  const ApiErrorCode._(String name) : super(name);

  static BuiltSet<ApiErrorCode> get values => _$values;
  static ApiErrorCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ApiErrorCodeMixin = Object with _$ApiErrorCodeMixin;
