// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlbumPost extends AlbumPost {
  @override
  final BuiltList<String> images;
  @override
  final String name;
  @override
  final BuiltList<String> sharedWith;
  @override
  final BuiltList<String> tags;

  factory _$AlbumPost([void Function(AlbumPostBuilder)? updates]) =>
      (new AlbumPostBuilder()..update(updates))._build();

  _$AlbumPost._(
      {required this.images,
      required this.name,
      required this.sharedWith,
      required this.tags})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(images, r'AlbumPost', 'images');
    BuiltValueNullFieldError.checkNotNull(name, r'AlbumPost', 'name');
    BuiltValueNullFieldError.checkNotNull(
        sharedWith, r'AlbumPost', 'sharedWith');
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
    return other is AlbumPost &&
        images == other.images &&
        name == other.name &&
        sharedWith == other.sharedWith &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sharedWith.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlbumPost')
          ..add('images', images)
          ..add('name', name)
          ..add('sharedWith', sharedWith)
          ..add('tags', tags))
        .toString();
  }
}

class AlbumPostBuilder implements Builder<AlbumPost, AlbumPostBuilder> {
  _$AlbumPost? _$v;

  ListBuilder<String>? _images;
  ListBuilder<String> get images =>
      _$this._images ??= new ListBuilder<String>();
  set images(ListBuilder<String>? images) => _$this._images = images;

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

  AlbumPostBuilder() {
    AlbumPost._defaults(this);
  }

  AlbumPostBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _images = $v.images.toBuilder();
      _name = $v.name;
      _sharedWith = $v.sharedWith.toBuilder();
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
              images: images.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'AlbumPost', 'name'),
              sharedWith: sharedWith.build(),
              tags: tags.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'images';
        images.build();

        _$failedField = 'sharedWith';
        sharedWith.build();
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
