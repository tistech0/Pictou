// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlbumPost extends AlbumPost {
  @override
  final String name;
  @override
  final BuiltList<String> tags;

  factory _$AlbumPost([void Function(AlbumPostBuilder)? updates]) =>
      (new AlbumPostBuilder()..update(updates))._build();

  _$AlbumPost._({required this.name, required this.tags}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'AlbumPost', 'name');
    BuiltValueNullFieldError.checkNotNull(tags, r'AlbumPost', 'tags');
  }

  @override
  AlbumPost rebuild(void Function(AlbumPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlbumPostBuilder toBuilder() => new AlbumPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlbumPost && name == other.name && tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlbumPost')
          ..add('name', name)
          ..add('tags', tags))
        .toString();
  }
}

class AlbumPostBuilder implements Builder<AlbumPost, AlbumPostBuilder> {
  _$AlbumPost? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  AlbumPostBuilder() {
    AlbumPost._defaults(this);
  }

  AlbumPostBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _tags = $v.tags.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlbumPost other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AlbumPost;
  }

  @override
  void update(void Function(AlbumPostBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlbumPost build() => _build();

  _$AlbumPost _build() {
    _$AlbumPost _$result;
    try {
      _$result = _$v ??
          new _$AlbumPost._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'AlbumPost', 'name'),
              tags: tags.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AlbumPost', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
