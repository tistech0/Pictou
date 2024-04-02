// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticationResponse extends AuthenticationResponse {
  @override
  final DateTime accessTokenExp;
  @override
  final String accessToken;
  @override
  final String email;
  @override
  final DateTime refreshTokenExp;
  @override
  final String userId;
  @override
  final String? familyName;
  @override
  final String? givenName;
  @override
  final String? name;
  @override
  final String? refreshToken;

  factory _$AuthenticationResponse(
          [void Function(AuthenticationResponseBuilder)? updates]) =>
      (new AuthenticationResponseBuilder()..update(updates))._build();

  _$AuthenticationResponse._(
      {required this.accessTokenExp,
      required this.accessToken,
      required this.email,
      required this.refreshTokenExp,
      required this.userId,
      this.familyName,
      this.givenName,
      this.name,
      this.refreshToken})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        accessTokenExp, r'AuthenticationResponse', 'accessTokenExp');
    BuiltValueNullFieldError.checkNotNull(
        accessToken, r'AuthenticationResponse', 'accessToken');
    BuiltValueNullFieldError.checkNotNull(
        email, r'AuthenticationResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        refreshTokenExp, r'AuthenticationResponse', 'refreshTokenExp');
    BuiltValueNullFieldError.checkNotNull(
        userId, r'AuthenticationResponse', 'userId');
  }

  @override
  AuthenticationResponse rebuild(
          void Function(AuthenticationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticationResponseBuilder toBuilder() =>
      new AuthenticationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticationResponse &&
        accessTokenExp == other.accessTokenExp &&
        accessToken == other.accessToken &&
        email == other.email &&
        refreshTokenExp == other.refreshTokenExp &&
        userId == other.userId &&
        familyName == other.familyName &&
        givenName == other.givenName &&
        name == other.name &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessTokenExp.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, refreshTokenExp.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, familyName.hashCode);
    _$hash = $jc(_$hash, givenName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthenticationResponse')
          ..add('accessTokenExp', accessTokenExp)
          ..add('accessToken', accessToken)
          ..add('email', email)
          ..add('refreshTokenExp', refreshTokenExp)
          ..add('userId', userId)
          ..add('familyName', familyName)
          ..add('givenName', givenName)
          ..add('name', name)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class AuthenticationResponseBuilder
    implements
        Builder<AuthenticationResponse, AuthenticationResponseBuilder>,
        PersistedUserInfoBuilder {
  _$AuthenticationResponse? _$v;

  DateTime? _accessTokenExp;
  DateTime? get accessTokenExp => _$this._accessTokenExp;
  set accessTokenExp(covariant DateTime? accessTokenExp) =>
      _$this._accessTokenExp = accessTokenExp;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(covariant String? accessToken) =>
      _$this._accessToken = accessToken;

  String? _email;
  String? get email => _$this._email;
  set email(covariant String? email) => _$this._email = email;

  DateTime? _refreshTokenExp;
  DateTime? get refreshTokenExp => _$this._refreshTokenExp;
  set refreshTokenExp(covariant DateTime? refreshTokenExp) =>
      _$this._refreshTokenExp = refreshTokenExp;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _familyName;
  String? get familyName => _$this._familyName;
  set familyName(covariant String? familyName) =>
      _$this._familyName = familyName;

  String? _givenName;
  String? get givenName => _$this._givenName;
  set givenName(covariant String? givenName) => _$this._givenName = givenName;

  String? _name;
  String? get name => _$this._name;
  set name(covariant String? name) => _$this._name = name;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(covariant String? refreshToken) =>
      _$this._refreshToken = refreshToken;

  AuthenticationResponseBuilder() {
    AuthenticationResponse._defaults(this);
  }

  AuthenticationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessTokenExp = $v.accessTokenExp;
      _accessToken = $v.accessToken;
      _email = $v.email;
      _refreshTokenExp = $v.refreshTokenExp;
      _userId = $v.userId;
      _familyName = $v.familyName;
      _givenName = $v.givenName;
      _name = $v.name;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant AuthenticationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticationResponse;
  }

  @override
  void update(void Function(AuthenticationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticationResponse build() => _build();

  _$AuthenticationResponse _build() {
    final _$result = _$v ??
        new _$AuthenticationResponse._(
            accessTokenExp: BuiltValueNullFieldError.checkNotNull(
                accessTokenExp, r'AuthenticationResponse', 'accessTokenExp'),
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'AuthenticationResponse', 'accessToken'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'AuthenticationResponse', 'email'),
            refreshTokenExp: BuiltValueNullFieldError.checkNotNull(
                refreshTokenExp, r'AuthenticationResponse', 'refreshTokenExp'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'AuthenticationResponse', 'userId'),
            familyName: familyName,
            givenName: givenName,
            name: name,
            refreshToken: refreshToken);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
