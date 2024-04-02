// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persisted_user_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class PersistedUserInfoBuilder {
  void replace(PersistedUserInfo other);
  void update(void Function(PersistedUserInfoBuilder) updates);
  String? get email;
  set email(String? email);

  DateTime? get refreshTokenExp;
  set refreshTokenExp(DateTime? refreshTokenExp);

  String? get userId;
  set userId(String? userId);

  String? get familyName;
  set familyName(String? familyName);

  String? get givenName;
  set givenName(String? givenName);

  String? get name;
  set name(String? name);

  String? get refreshToken;
  set refreshToken(String? refreshToken);
}

class _$$PersistedUserInfo extends $PersistedUserInfo {
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

  factory _$$PersistedUserInfo(
          [void Function($PersistedUserInfoBuilder)? updates]) =>
      (new $PersistedUserInfoBuilder()..update(updates))._build();

  _$$PersistedUserInfo._(
      {required this.email,
      required this.refreshTokenExp,
      required this.userId,
      this.familyName,
      this.givenName,
      this.name,
      this.refreshToken})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        email, r'$PersistedUserInfo', 'email');
    BuiltValueNullFieldError.checkNotNull(
        refreshTokenExp, r'$PersistedUserInfo', 'refreshTokenExp');
    BuiltValueNullFieldError.checkNotNull(
        userId, r'$PersistedUserInfo', 'userId');
  }

  @override
  $PersistedUserInfo rebuild(
          void Function($PersistedUserInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $PersistedUserInfoBuilder toBuilder() =>
      new $PersistedUserInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $PersistedUserInfo &&
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
    return (newBuiltValueToStringHelper(r'$PersistedUserInfo')
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

class $PersistedUserInfoBuilder
    implements
        Builder<$PersistedUserInfo, $PersistedUserInfoBuilder>,
        PersistedUserInfoBuilder {
  _$$PersistedUserInfo? _$v;

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

  $PersistedUserInfoBuilder() {
    $PersistedUserInfo._defaults(this);
  }

  $PersistedUserInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(covariant $PersistedUserInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$$PersistedUserInfo;
  }

  @override
  void update(void Function($PersistedUserInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $PersistedUserInfo build() => _build();

  _$$PersistedUserInfo _build() {
    final _$result = _$v ??
        new _$$PersistedUserInfo._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'$PersistedUserInfo', 'email'),
            refreshTokenExp: BuiltValueNullFieldError.checkNotNull(
                refreshTokenExp, r'$PersistedUserInfo', 'refreshTokenExp'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'$PersistedUserInfo', 'userId'),
            familyName: familyName,
            givenName: givenName,
            name: name,
            refreshToken: refreshToken);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
