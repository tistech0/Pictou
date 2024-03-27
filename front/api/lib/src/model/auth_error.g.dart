// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_INVALID_CREDENTIALS =
    const AuthErrorErrorCodeEnum._('INVALID_CREDENTIALS');
const AuthErrorErrorCodeEnum
    _$authErrorErrorCodeEnum_INVALID_AUTHORIZATION_HEADER =
    const AuthErrorErrorCodeEnum._('INVALID_AUTHORIZATION_HEADER');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_INVALID_TOKEN =
    const AuthErrorErrorCodeEnum._('INVALID_TOKEN');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_oAUTH2PROVIDERERROR =
    const AuthErrorErrorCodeEnum._('oAUTH2PROVIDERERROR');
const AuthErrorErrorCodeEnum
    _$authErrorErrorCodeEnum_oAUTH2AUTHORIZATIONDENIED =
    const AuthErrorErrorCodeEnum._('oAUTH2AUTHORIZATIONDENIED');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_oAUTH2INVALIDSTATE =
    const AuthErrorErrorCodeEnum._('oAUTH2INVALIDSTATE');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_oAUTH2FORBIDDEN =
    const AuthErrorErrorCodeEnum._('oAUTH2FORBIDDEN');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_INVALID_CLIENT_TYPE =
    const AuthErrorErrorCodeEnum._('INVALID_CLIENT_TYPE');
const AuthErrorErrorCodeEnum _$authErrorErrorCodeEnum_INTERNAL_ERROR =
    const AuthErrorErrorCodeEnum._('INTERNAL_ERROR');

AuthErrorErrorCodeEnum _$authErrorErrorCodeEnumValueOf(String name) {
  switch (name) {
    case 'INVALID_CREDENTIALS':
      return _$authErrorErrorCodeEnum_INVALID_CREDENTIALS;
    case 'INVALID_AUTHORIZATION_HEADER':
      return _$authErrorErrorCodeEnum_INVALID_AUTHORIZATION_HEADER;
    case 'INVALID_TOKEN':
      return _$authErrorErrorCodeEnum_INVALID_TOKEN;
    case 'oAUTH2PROVIDERERROR':
      return _$authErrorErrorCodeEnum_oAUTH2PROVIDERERROR;
    case 'oAUTH2AUTHORIZATIONDENIED':
      return _$authErrorErrorCodeEnum_oAUTH2AUTHORIZATIONDENIED;
    case 'oAUTH2INVALIDSTATE':
      return _$authErrorErrorCodeEnum_oAUTH2INVALIDSTATE;
    case 'oAUTH2FORBIDDEN':
      return _$authErrorErrorCodeEnum_oAUTH2FORBIDDEN;
    case 'INVALID_CLIENT_TYPE':
      return _$authErrorErrorCodeEnum_INVALID_CLIENT_TYPE;
    case 'INTERNAL_ERROR':
      return _$authErrorErrorCodeEnum_INTERNAL_ERROR;
    default:
      return _$authErrorErrorCodeEnum_INTERNAL_ERROR;
  }
}

final BuiltSet<AuthErrorErrorCodeEnum> _$authErrorErrorCodeEnumValues =
    new BuiltSet<AuthErrorErrorCodeEnum>(const <AuthErrorErrorCodeEnum>[
  _$authErrorErrorCodeEnum_INVALID_CREDENTIALS,
  _$authErrorErrorCodeEnum_INVALID_AUTHORIZATION_HEADER,
  _$authErrorErrorCodeEnum_INVALID_TOKEN,
  _$authErrorErrorCodeEnum_oAUTH2PROVIDERERROR,
  _$authErrorErrorCodeEnum_oAUTH2AUTHORIZATIONDENIED,
  _$authErrorErrorCodeEnum_oAUTH2INVALIDSTATE,
  _$authErrorErrorCodeEnum_oAUTH2FORBIDDEN,
  _$authErrorErrorCodeEnum_INVALID_CLIENT_TYPE,
  _$authErrorErrorCodeEnum_INTERNAL_ERROR,
]);

Serializer<AuthErrorErrorCodeEnum> _$authErrorErrorCodeEnumSerializer =
    new _$AuthErrorErrorCodeEnumSerializer();

class _$AuthErrorErrorCodeEnumSerializer
    implements PrimitiveSerializer<AuthErrorErrorCodeEnum> {
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
  final Iterable<Type> types = const <Type>[AuthErrorErrorCodeEnum];
  @override
  final String wireName = 'AuthErrorErrorCodeEnum';

  @override
  Object serialize(Serializers serializers, AuthErrorErrorCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AuthErrorErrorCodeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AuthErrorErrorCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AuthError extends AuthError {
  @override
  final String description;
  @override
  final AuthErrorErrorCodeEnum errorCode;
  @override
  final int httpStatus;

  factory _$AuthError([void Function(AuthErrorBuilder)? updates]) =>
      (new AuthErrorBuilder()..update(updates))._build();

  _$AuthError._(
      {required this.description,
      required this.errorCode,
      required this.httpStatus})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'AuthError', 'description');
    BuiltValueNullFieldError.checkNotNull(errorCode, r'AuthError', 'errorCode');
    BuiltValueNullFieldError.checkNotNull(
        httpStatus, r'AuthError', 'httpStatus');
  }

  @override
  AuthError rebuild(void Function(AuthErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthErrorBuilder toBuilder() => new AuthErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthError &&
        description == other.description &&
        errorCode == other.errorCode &&
        httpStatus == other.httpStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, errorCode.hashCode);
    _$hash = $jc(_$hash, httpStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthError')
          ..add('description', description)
          ..add('errorCode', errorCode)
          ..add('httpStatus', httpStatus))
        .toString();
  }
}

class AuthErrorBuilder implements Builder<AuthError, AuthErrorBuilder> {
  _$AuthError? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AuthErrorErrorCodeEnum? _errorCode;
  AuthErrorErrorCodeEnum? get errorCode => _$this._errorCode;
  set errorCode(AuthErrorErrorCodeEnum? errorCode) =>
      _$this._errorCode = errorCode;

  int? _httpStatus;
  int? get httpStatus => _$this._httpStatus;
  set httpStatus(int? httpStatus) => _$this._httpStatus = httpStatus;

  AuthErrorBuilder() {
    AuthError._defaults(this);
  }

  AuthErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _errorCode = $v.errorCode;
      _httpStatus = $v.httpStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthError;
  }

  @override
  void update(void Function(AuthErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthError build() => _build();

  _$AuthError _build() {
    final _$result = _$v ??
        new _$AuthError._(
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'AuthError', 'description'),
            errorCode: BuiltValueNullFieldError.checkNotNull(
                errorCode, r'AuthError', 'errorCode'),
            httpStatus: BuiltValueNullFieldError.checkNotNull(
                httpStatus, r'AuthError', 'httpStatus'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
