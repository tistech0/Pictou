// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_meta_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImageMetaData extends ImageMetaData {
  @override
  final String caption;
  @override
  final String id;
  @override
  final String ownerId;
  @override
  final BuiltList<String> sharedWith;
  @override
  final BuiltList<String> tags;

  factory _$ImageMetaData([void Function(ImageMetaDataBuilder)? updates]) =>
      (new ImageMetaDataBuilder()..update(updates))._build();

  _$ImageMetaData._(
      {required this.caption,
      required this.id,
      required this.ownerId,
      required this.sharedWith,
      required this.tags})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(caption, r'ImageMetaData', 'caption');
    BuiltValueNullFieldError.checkNotNull(id, r'ImageMetaData', 'id');
    BuiltValueNullFieldError.checkNotNull(ownerId, r'ImageMetaData', 'ownerId');
    BuiltValueNullFieldError.checkNotNull(
        sharedWith, r'ImageMetaData', 'sharedWith');
    BuiltValueNullFieldError.checkNotNull(tags, r'ImageMetaData', 'tags');
  }

  @override
  ImageMetaData rebuild(void Function(ImageMetaDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageMetaDataBuilder toBuilder() => new ImageMetaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageMetaData &&
        caption == other.caption &&
        id == other.id &&
        ownerId == other.ownerId &&
        sharedWith == other.sharedWith &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, sharedWith.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImageMetaData')
          ..add('caption', caption)
          ..add('id', id)
          ..add('ownerId', ownerId)
          ..add('sharedWith', sharedWith)
          ..add('tags', tags))
        .toString();
  }
}

class ImageMetaDataBuilder
    implements Builder<ImageMetaData, ImageMetaDataBuilder> {
  _$ImageMetaData? _$v;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  ImageMetaDataBuilder() {
    ImageMetaData._defaults(this);
  }

  ImageMetaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _caption = $v.caption;
      _id = $v.id;
      _ownerId = $v.ownerId;
      _sharedWith = $v.sharedWith.toBuilder();
      _tags = $v.tags.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageMetaData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ImageMetaData;
  }

  @override
  void update(void Function(ImageMetaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImageMetaData build() => _build();

  _$ImageMetaData _build() {
    _$ImageMetaData _$result;
    try {
      _$result = _$v ??
          new _$ImageMetaData._(
              caption: BuiltValueNullFieldError.checkNotNull(
                  caption, r'ImageMetaData', 'caption'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ImageMetaData', 'id'),
              ownerId: BuiltValueNullFieldError.checkNotNull(
                  ownerId, r'ImageMetaData', 'ownerId'),
              sharedWith: sharedWith.build(),
              tags: tags.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sharedWith';
        sharedWith.build();
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ImageMetaData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
