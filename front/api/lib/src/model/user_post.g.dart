// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserPost extends UserPost {
  @override
  final String name;

  factory _$UserPost([void Function(UserPostBuilder)? updates]) =>
      (new UserPostBuilder()..update(updates))._build();

  _$UserPost._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'UserPost', 'name');
  }

  @override
  UserPost rebuild(void Function(UserPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserPostBuilder toBuilder() => new UserPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserPost && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserPost')..add('name', name))
        .toString();
  }
}

class UserPostBuilder implements Builder<UserPost, UserPostBuilder> {
  _$UserPost? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UserPostBuilder() {
    UserPost._defaults(this);
  }

  UserPostBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserPost other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserPost;
  }

  @override
  void update(void Function(UserPostBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserPost build() => _build();

  _$UserPost _build() {
    final _$result = _$v ??
        new _$UserPost._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'UserPost', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
