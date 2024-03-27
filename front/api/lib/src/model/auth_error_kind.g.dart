// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AuthErrorKind _$INVALID_CREDENTIALS =
    const AuthErrorKind._('INVALID_CREDENTIALS');
const AuthErrorKind _$INVALID_AUTHORIZATION_HEADER =
    const AuthErrorKind._('INVALID_AUTHORIZATION_HEADER');
const AuthErrorKind _$INVALID_TOKEN = const AuthErrorKind._('INVALID_TOKEN');
const AuthErrorKind _$oAUTH2PROVIDERERROR =
    const AuthErrorKind._('oAUTH2PROVIDERERROR');
const AuthErrorKind _$oAUTH2AUTHORIZATIONDENIED =
    const AuthErrorKind._('oAUTH2AUTHORIZATIONDENIED');
const AuthErrorKind _$oAUTH2INVALIDSTATE =
    const AuthErrorKind._('oAUTH2INVALIDSTATE');
const AuthErrorKind _$oAUTH2FORBIDDEN =
    const AuthErrorKind._('oAUTH2FORBIDDEN');
const AuthErrorKind _$INVALID_CLIENT_TYPE =
    const AuthErrorKind._('INVALID_CLIENT_TYPE');
const AuthErrorKind _$INTERNAL_ERROR = const AuthErrorKind._('INTERNAL_ERROR');

AuthErrorKind _$valueOf(String name) {
  switch (name) {
    case 'INVALID_CREDENTIALS':
      return _$INVALID_CREDENTIALS;
    case 'INVALID_AUTHORIZATION_HEADER':
      return _$INVALID_AUTHORIZATION_HEADER;
    case 'INVALID_TOKEN':
      return _$INVALID_TOKEN;
    case 'oAUTH2PROVIDERERROR':
      return _$oAUTH2PROVIDERERROR;
    case 'oAUTH2AUTHORIZATIONDENIED':
      return _$oAUTH2AUTHORIZATIONDENIED;
    case 'oAUTH2INVALIDSTATE':
      return _$oAUTH2INVALIDSTATE;
    case 'oAUTH2FORBIDDEN':
      return _$oAUTH2FORBIDDEN;
    case 'INVALID_CLIENT_TYPE':
      return _$INVALID_CLIENT_TYPE;
    case 'INTERNAL_ERROR':
      return _$INTERNAL_ERROR;
    default:
      return _$INTERNAL_ERROR;
  }
}

final BuiltSet<AuthErrorKind> _$values =
    new BuiltSet<AuthErrorKind>(const <AuthErrorKind>[
  _$INVALID_CREDENTIALS,
  _$INVALID_AUTHORIZATION_HEADER,
  _$INVALID_TOKEN,
  _$oAUTH2PROVIDERERROR,
  _$oAUTH2AUTHORIZATIONDENIED,
  _$oAUTH2INVALIDSTATE,
  _$oAUTH2FORBIDDEN,
  _$INVALID_CLIENT_TYPE,
  _$INTERNAL_ERROR,
]);

class _$AuthErrorKindMeta {
  const _$AuthErrorKindMeta();
  AuthErrorKind get INVALID_CREDENTIALS => _$INVALID_CREDENTIALS;
  AuthErrorKind get INVALID_AUTHORIZATION_HEADER =>
      _$INVALID_AUTHORIZATION_HEADER;
  AuthErrorKind get INVALID_TOKEN => _$INVALID_TOKEN;
  AuthErrorKind get oAUTH2PROVIDERERROR => _$oAUTH2PROVIDERERROR;
  AuthErrorKind get oAUTH2AUTHORIZATIONDENIED => _$oAUTH2AUTHORIZATIONDENIED;
  AuthErrorKind get oAUTH2INVALIDSTATE => _$oAUTH2INVALIDSTATE;
  AuthErrorKind get oAUTH2FORBIDDEN => _$oAUTH2FORBIDDEN;
  AuthErrorKind get INVALID_CLIENT_TYPE => _$INVALID_CLIENT_TYPE;
  AuthErrorKind get INTERNAL_ERROR => _$INTERNAL_ERROR;
  AuthErrorKind valueOf(String name) => _$valueOf(name);
  BuiltSet<AuthErrorKind> get values => _$values;
}

abstract class _$AuthErrorKindMixin {
  // ignore: non_constant_identifier_names
  _$AuthErrorKindMeta get AuthErrorKind => const _$AuthErrorKindMeta();
}

Serializer<AuthErrorKind> _$authErrorKindSerializer =
    new _$AuthErrorKindSerializer();

class _$AuthErrorKindSerializer implements PrimitiveSerializer<AuthErrorKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INVALID_CREDENTIALS': 'INVALID_CREDENTIALS',
    'INVALID_AUTHORIZATION_HEADER': 'INVALID_AUTHORIZATION_HEADER',
    'INVALID_TOKEN': 'INVALID_TOKEN',
    'oAUTH2PROVIDERERROR': 'OAUTH2_PROVIDER_ERROR',
    'oAUTH2AUTHORIZATIONDENIED': 'OAUTH2_AUTHORIZATION_DENIED',
    'oAUTH2INVALIDSTATE': 'OAUTH2_INVALID_STATE',
    'oAUTH2FORBIDDEN': 'OAUTH2_FORBIDDEN',
    'INVALID_CLIENT_TYPE': 'INVALID_CLIENT_TYPE',
    'INTERNAL_ERROR': 'INTERNAL_ERROR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INVALID_CREDENTIALS': 'INVALID_CREDENTIALS',
    'INVALID_AUTHORIZATION_HEADER': 'INVALID_AUTHORIZATION_HEADER',
    'INVALID_TOKEN': 'INVALID_TOKEN',
    'OAUTH2_PROVIDER_ERROR': 'oAUTH2PROVIDERERROR',
    'OAUTH2_AUTHORIZATION_DENIED': 'oAUTH2AUTHORIZATIONDENIED',
    'OAUTH2_INVALID_STATE': 'oAUTH2INVALIDSTATE',
    'OAUTH2_FORBIDDEN': 'oAUTH2FORBIDDEN',
    'INVALID_CLIENT_TYPE': 'INVALID_CLIENT_TYPE',
    'INTERNAL_ERROR': 'INTERNAL_ERROR',
  };

  @override
  final Iterable<Type> types = const <Type>[AuthErrorKind];
  @override
  final String wireName = 'AuthErrorKind';

  @override
  Object serialize(Serializers serializers, AuthErrorKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AuthErrorKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AuthErrorKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
