// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_params.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefreshTokenParams extends RefreshTokenParams {
  @override
  final String refreshToken;
  @override
  final String userId;

  factory _$RefreshTokenParams(
          [void Function(RefreshTokenParamsBuilder)? updates]) =>
      (new RefreshTokenParamsBuilder()..update(updates))._build();

  _$RefreshTokenParams._({required this.refreshToken, required this.userId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        refreshToken, r'RefreshTokenParams', 'refreshToken');
    BuiltValueNullFieldError.checkNotNull(
        userId, r'RefreshTokenParams', 'userId');
  }

  @override
  RefreshTokenParams rebuild(
          void Function(RefreshTokenParamsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefreshTokenParamsBuilder toBuilder() =>
      new RefreshTokenParamsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefreshTokenParams &&
        refreshToken == other.refreshToken &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefreshTokenParams')
          ..add('refreshToken', refreshToken)
          ..add('userId', userId))
        .toString();
  }
}

class RefreshTokenParamsBuilder
    implements Builder<RefreshTokenParams, RefreshTokenParamsBuilder> {
  _$RefreshTokenParams? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  RefreshTokenParamsBuilder() {
    RefreshTokenParams._defaults(this);
  }

  RefreshTokenParamsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefreshTokenParams other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RefreshTokenParams;
  }

  @override
  void update(void Function(RefreshTokenParamsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefreshTokenParams build() => _build();

  _$RefreshTokenParams _build() {
    final _$result = _$v ??
        new _$RefreshTokenParams._(
            refreshToken: BuiltValueNullFieldError.checkNotNull(
                refreshToken, r'RefreshTokenParams', 'refreshToken'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'RefreshTokenParams', 'userId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
