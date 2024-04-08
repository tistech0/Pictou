// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImageUploadResponse extends ImageUploadResponse {
  @override
  final String id;

  factory _$ImageUploadResponse(
          [void Function(ImageUploadResponseBuilder)? updates]) =>
      (new ImageUploadResponseBuilder()..update(updates))._build();

  _$ImageUploadResponse._({required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ImageUploadResponse', 'id');
  }

  @override
  ImageUploadResponse rebuild(
          void Function(ImageUploadResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageUploadResponseBuilder toBuilder() =>
      new ImageUploadResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageUploadResponse && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImageUploadResponse')..add('id', id))
        .toString();
  }
}

class ImageUploadResponseBuilder
    implements Builder<ImageUploadResponse, ImageUploadResponseBuilder> {
  _$ImageUploadResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ImageUploadResponseBuilder() {
    ImageUploadResponse._defaults(this);
  }

  ImageUploadResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageUploadResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ImageUploadResponse;
  }

  @override
  void update(void Function(ImageUploadResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImageUploadResponse build() => _build();

  _$ImageUploadResponse _build() {
    final _$result = _$v ??
        new _$ImageUploadResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ImageUploadResponse', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
