// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImagePatch extends ImagePatch {
  @override
  final String? caption;
  @override
  final BuiltList<String>? tags;

  factory _$ImagePatch([void Function(ImagePatchBuilder)? updates]) =>
      (new ImagePatchBuilder()..update(updates))._build();

  _$ImagePatch._({this.caption, this.tags}) : super._();

  @override
  ImagePatch rebuild(void Function(ImagePatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImagePatchBuilder toBuilder() => new ImagePatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImagePatch &&
        caption == other.caption &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImagePatch')
          ..add('caption', caption)
          ..add('tags', tags))
        .toString();
  }
}

class ImagePatchBuilder implements Builder<ImagePatch, ImagePatchBuilder> {
  _$ImagePatch? _$v;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  ImagePatchBuilder() {
    ImagePatch._defaults(this);
  }

  ImagePatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _caption = $v.caption;
      _tags = $v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImagePatch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ImagePatch;
  }

  @override
  void update(void Function(ImagePatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImagePatch build() => _build();

  _$ImagePatch _build() {
    _$ImagePatch _$result;
    try {
      _$result =
          _$v ?? new _$ImagePatch._(caption: caption, tags: _tags?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ImagePatch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
