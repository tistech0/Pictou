// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlbumList extends AlbumList {
  @override
  final BuiltList<Album> albums;

  factory _$AlbumList([void Function(AlbumListBuilder)? updates]) =>
      (new AlbumListBuilder()..update(updates))._build();

  _$AlbumList._({required this.albums}) : super._() {
    BuiltValueNullFieldError.checkNotNull(albums, r'AlbumList', 'albums');
  }

  @override
  AlbumList rebuild(void Function(AlbumListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlbumListBuilder toBuilder() => new AlbumListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlbumList && albums == other.albums;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, albums.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlbumList')..add('albums', albums))
        .toString();
  }
}

class AlbumListBuilder implements Builder<AlbumList, AlbumListBuilder> {
  _$AlbumList? _$v;

  ListBuilder<Album>? _albums;
  ListBuilder<Album> get albums => _$this._albums ??= new ListBuilder<Album>();
  set albums(ListBuilder<Album>? albums) => _$this._albums = albums;

  AlbumListBuilder() {
    AlbumList._defaults(this);
  }

  AlbumListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _albums = $v.albums.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlbumList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AlbumList;
  }

  @override
  void update(void Function(AlbumListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlbumList build() => _build();

  _$AlbumList _build() {
    _$AlbumList _$result;
    try {
      _$result = _$v ?? new _$AlbumList._(albums: albums.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'albums';
        albums.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AlbumList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
