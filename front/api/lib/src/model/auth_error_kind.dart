//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_error_kind.g.dart';

class AuthErrorKind extends EnumClass {
  @BuiltValueEnumConst(wireName: r'INVALID_CREDENTIALS')
  static const AuthErrorKind INVALID_CREDENTIALS = _$INVALID_CREDENTIALS;
  @BuiltValueEnumConst(wireName: r'INVALID_AUTHORIZATION_HEADER')
  static const AuthErrorKind INVALID_AUTHORIZATION_HEADER =
      _$INVALID_AUTHORIZATION_HEADER;
  @BuiltValueEnumConst(wireName: r'INVALID_TOKEN')
  static const AuthErrorKind INVALID_TOKEN = _$INVALID_TOKEN;
  @BuiltValueEnumConst(wireName: r'OAUTH2_PROVIDER_ERROR')
  static const AuthErrorKind oAUTH2PROVIDERERROR = _$oAUTH2PROVIDERERROR;
  @BuiltValueEnumConst(wireName: r'OAUTH2_AUTHORIZATION_DENIED')
  static const AuthErrorKind oAUTH2AUTHORIZATIONDENIED =
      _$oAUTH2AUTHORIZATIONDENIED;
  @BuiltValueEnumConst(wireName: r'OAUTH2_INVALID_STATE')
  static const AuthErrorKind oAUTH2INVALIDSTATE = _$oAUTH2INVALIDSTATE;
  @BuiltValueEnumConst(wireName: r'OAUTH2_FORBIDDEN')
  static const AuthErrorKind oAUTH2FORBIDDEN = _$oAUTH2FORBIDDEN;
  @BuiltValueEnumConst(wireName: r'INVALID_CLIENT_TYPE')
  static const AuthErrorKind INVALID_CLIENT_TYPE = _$INVALID_CLIENT_TYPE;
  @BuiltValueEnumConst(wireName: r'INTERNAL_ERROR', fallback: true)
  static const AuthErrorKind INTERNAL_ERROR = _$INTERNAL_ERROR;

  static Serializer<AuthErrorKind> get serializer => _$authErrorKindSerializer;

  const AuthErrorKind._(String name) : super(name);

  static BuiltSet<AuthErrorKind> get values => _$values;
  static AuthErrorKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AuthErrorKindMixin = Object with _$AuthErrorKindMixin;
