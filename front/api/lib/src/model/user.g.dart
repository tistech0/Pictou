// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String id;
  @override
  final String name;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (new UserBuilder()..update(updates))._build();

  _$User._({required this.id, required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'User', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'User', 'name');
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UserBuilder() {
    User._defaults(this);
  }

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    final _$result = _$v ??
        new _$User._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'User', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'User', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
