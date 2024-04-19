// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Album extends Album {
  @override
  final String id;
  @override
  final BuiltList<ImageMetaData> images;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  final BuiltList<String> sharedWith;
  @override
  final BuiltList<String> tags;

  factory _$Album([void Function(AlbumBuilder)? updates]) =>
      (new AlbumBuilder()..update(updates))._build();

  _$Album._(
      {required this.id,
      required this.images,
      required this.name,
      required this.ownerId,
      required this.sharedWith,
      required this.tags})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Album', 'id');
    BuiltValueNullFieldError.checkNotNull(images, r'Album', 'images');
    BuiltValueNullFieldError.checkNotNull(name, r'Album', 'name');
    BuiltValueNullFieldError.checkNotNull(ownerId, r'Album', 'ownerId');
    BuiltValueNullFieldError.checkNotNull(sharedWith, r'Album', 'sharedWith');
    BuiltValueNullFieldError.checkNotNull(tags, r'Album', 'tags');
  }

  @override
  Album rebuild(void Function(AlbumBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlbumBuilder toBuilder() => new AlbumBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Album &&
        id == other.id &&
        images == other.images &&
        name == other.name &&
        ownerId == other.ownerId &&
        sharedWith == other.sharedWith &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, sharedWith.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Album')
          ..add('id', id)
          ..add('images', images)
          ..add('name', name)
          ..add('ownerId', ownerId)
          ..add('sharedWith', sharedWith)
          ..add('tags', tags))
        .toString();
  }
}

class AlbumBuilder implements Builder<Album, AlbumBuilder> {
  _$Album? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ListBuilder<ImageMetaData>? _images;
  ListBuilder<ImageMetaData> get images =>
      _$this._images ??= new ListBuilder<ImageMetaData>();
  set images(ListBuilder<ImageMetaData>? images) => _$this._images = images;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _ownerId;
  String? get ownerId => _$this._ownerId;
  set ownerId(String? ownerId) => _$this._ownerId = ownerId;

  ListBuilder<String>? _sharedWith;
  ListBuilder<String> get sharedWith =>
      _$this._sharedWith ??= new ListBuilder<String>();
  set sharedWith(ListBuilder<String>? sharedWith) =>
      _$this._sharedWith = sharedWith;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  AlbumBuilder() {
    Album._defaults(this);
  }

  AlbumBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _images = $v.images.toBuilder();
      _name = $v.name;
      _ownerId = $v.ownerId;
      _sharedWith = $v.sharedWith.toBuilder();
      _tags = $v.tags.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Album other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Album;
  }

  @override
  void update(void Function(AlbumBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Album build() => _build();

  _$Album _build() {
    _$Album _$result;
    try {
      _$result = _$v ??
          new _$Album._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Album', 'id'),
              images: images.build(),
              name:
                  BuiltValueNullFieldError.checkNotNull(name, r'Album', 'name'),
              ownerId: BuiltValueNullFieldError.checkNotNull(
                  ownerId, r'Album', 'ownerId'),
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
            r'Album', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
