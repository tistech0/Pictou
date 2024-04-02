// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images_meta_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImagesMetaData extends ImagesMetaData {
  @override
  final BuiltList<ImageMetaData> images;

  factory _$ImagesMetaData([void Function(ImagesMetaDataBuilder)? updates]) =>
      (new ImagesMetaDataBuilder()..update(updates))._build();

  _$ImagesMetaData._({required this.images}) : super._() {
    BuiltValueNullFieldError.checkNotNull(images, r'ImagesMetaData', 'images');
  }

  @override
  ImagesMetaData rebuild(void Function(ImagesMetaDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImagesMetaDataBuilder toBuilder() =>
      new ImagesMetaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImagesMetaData && images == other.images;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImagesMetaData')
          ..add('images', images))
        .toString();
  }
}

class ImagesMetaDataBuilder
    implements Builder<ImagesMetaData, ImagesMetaDataBuilder> {
  _$ImagesMetaData? _$v;

  ListBuilder<ImageMetaData>? _images;
  ListBuilder<ImageMetaData> get images =>
      _$this._images ??= new ListBuilder<ImageMetaData>();
  set images(ListBuilder<ImageMetaData>? images) => _$this._images = images;

  ImagesMetaDataBuilder() {
    ImagesMetaData._defaults(this);
  }

  ImagesMetaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _images = $v.images.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImagesMetaData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ImagesMetaData;
  }

  @override
  void update(void Function(ImagesMetaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImagesMetaData build() => _build();

  _$ImagesMetaData _build() {
    _$ImagesMetaData _$result;
    try {
      _$result = _$v ?? new _$ImagesMetaData._(images: images.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'images';
        images.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ImagesMetaData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
