// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserList extends UserList {
  @override
  final BuiltList<User> users;

  factory _$UserList([void Function(UserListBuilder)? updates]) =>
      (new UserListBuilder()..update(updates))._build();

  _$UserList._({required this.users}) : super._() {
    BuiltValueNullFieldError.checkNotNull(users, r'UserList', 'users');
  }

  @override
  UserList rebuild(void Function(UserListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserListBuilder toBuilder() => new UserListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserList && users == other.users;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserList')..add('users', users))
        .toString();
  }
}

class UserListBuilder implements Builder<UserList, UserListBuilder> {
  _$UserList? _$v;

  ListBuilder<User>? _users;
  ListBuilder<User> get users => _$this._users ??= new ListBuilder<User>();
  set users(ListBuilder<User>? users) => _$this._users = users;

  UserListBuilder() {
    UserList._defaults(this);
  }

  UserListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _users = $v.users.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserList;
  }

  @override
  void update(void Function(UserListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserList build() => _build();

  _$UserList _build() {
    _$UserList _$result;
    try {
      _$result = _$v ?? new _$UserList._(users: users.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'users';
        users.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
