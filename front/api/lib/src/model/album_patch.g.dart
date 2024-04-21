// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlbumPatch extends AlbumPatch {
  @override
  final String? name;
  @override
  final BuiltList<String>? sharedWith;
  @override
  final BuiltList<String>? tags;

  factory _$AlbumPatch([void Function(AlbumPatchBuilder)? updates]) =>
      (new AlbumPatchBuilder()..update(updates))._build();

  _$AlbumPatch._({this.name, this.sharedWith, this.tags}) : super._();

  @override
  AlbumPatch rebuild(void Function(AlbumPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlbumPatchBuilder toBuilder() => new AlbumPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlbumPatch &&
        name == other.name &&
        sharedWith == other.sharedWith &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sharedWith.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlbumPatch')
          ..add('name', name)
          ..add('sharedWith', sharedWith)
          ..add('tags', tags))
        .toString();
  }
}

class AlbumPatchBuilder implements Builder<AlbumPatch, AlbumPatchBuilder> {
  _$AlbumPatch? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _sharedWith;
  ListBuilder<String> get sharedWith =>
      _$this._sharedWith ??= new ListBuilder<String>();
  set sharedWith(ListBuilder<String>? sharedWith) =>
      _$this._sharedWith = sharedWith;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  AlbumPatchBuilder() {
    AlbumPatch._defaults(this);
  }

  AlbumPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _sharedWith = $v.sharedWith?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlbumPatch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AlbumPatch;
  }

  @override
  void update(void Function(AlbumPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlbumPatch build() => _build();

  _$AlbumPatch _build() {
    _$AlbumPatch _$result;
    try {
      _$result = _$v ??
          new _$AlbumPatch._(
              name: name,
              sharedWith: _sharedWith?.build(),
              tags: _tags?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sharedWith';
        _sharedWith?.build();
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AlbumPatch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
