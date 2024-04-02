//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album_post.g.dart';

/// AlbumPost
///
/// Properties:
/// * [images]
/// * [name]
/// * [sharedWith]
/// * [tags]
@BuiltValue()
abstract class AlbumPost implements Built<AlbumPost, AlbumPostBuilder> {
  @BuiltValueField(wireName: r'images')
  BuiltList<String> get images;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'shared_with')
  BuiltList<String> get sharedWith;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String> get tags;

  AlbumPost._();

  factory AlbumPost([void updates(AlbumPostBuilder b)]) = _$AlbumPost;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumPostBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlbumPost> get serializer => _$AlbumPostSerializer();
}

class _$AlbumPostSerializer implements PrimitiveSerializer<AlbumPost> {
  @override
  final Iterable<Type> types = const [AlbumPost, _$AlbumPost];

  @override
  final String wireName = r'AlbumPost';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlbumPost object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'shared_with';
    yield serializers.serialize(
      object.sharedWith,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlbumPost object, {
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
    required AlbumPostBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.images.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'shared_with':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.sharedWith.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlbumPost deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumPostBuilder();
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
