// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserPatch extends UserPatch {
  @override
  final String? familyName;
  @override
  final String? givenName;
  @override
  final String? name;

  factory _$UserPatch([void Function(UserPatchBuilder)? updates]) =>
      (new UserPatchBuilder()..update(updates))._build();

  _$UserPatch._({this.familyName, this.givenName, this.name}) : super._();

  @override
  UserPatch rebuild(void Function(UserPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserPatchBuilder toBuilder() => new UserPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserPatch &&
        familyName == other.familyName &&
        givenName == other.givenName &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, familyName.hashCode);
    _$hash = $jc(_$hash, givenName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserPatch')
          ..add('familyName', familyName)
          ..add('givenName', givenName)
          ..add('name', name))
        .toString();
  }
}

class UserPatchBuilder implements Builder<UserPatch, UserPatchBuilder> {
  _$UserPatch? _$v;

  String? _familyName;
  String? get familyName => _$this._familyName;
  set familyName(String? familyName) => _$this._familyName = familyName;

  String? _givenName;
  String? get givenName => _$this._givenName;
  set givenName(String? givenName) => _$this._givenName = givenName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UserPatchBuilder() {
    UserPatch._defaults(this);
  }

  UserPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _familyName = $v.familyName;
      _givenName = $v.givenName;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserPatch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserPatch;
  }

  @override
  void update(void Function(UserPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserPatch build() => _build();

  _$UserPatch _build() {
    final _$result = _$v ??
        new _$UserPatch._(
            familyName: familyName, givenName: givenName, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
