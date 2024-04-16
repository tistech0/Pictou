//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pictouapi/src/model/album.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_list.g.dart';

/// AlbumList
///
/// Properties:
/// * [albums]
@BuiltValue()
abstract class AlbumList implements Built<AlbumList, AlbumListBuilder> {
  @BuiltValueField(wireName: r'albums')
  BuiltList<Album> get albums;

  AlbumList._();

  factory AlbumList([void updates(AlbumListBuilder b)]) = _$AlbumList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumList> get serializer => _$AlbumListSerializer();
}

class _$AlbumListSerializer implements PrimitiveSerializer<AlbumList> {
  @override
  final Iterable<Type> types = const [AlbumList, _$AlbumList];

  @override
  final String wireName = r'AlbumList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'albums';
    yield serializers.serialize(
      object.albums,
      specifiedType: const FullType(BuiltList, [FullType(Album)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlbumListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albums':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Album)]),
          ) as BuiltList<Album>;
          result.albums.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumListBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
