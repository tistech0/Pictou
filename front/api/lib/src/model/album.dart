//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pictouapi/src/model/image_meta_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'album.g.dart';

/// Album
///
/// Properties:
/// * [id]
/// * [images]
/// * [name]
/// * [ownerId]
/// * [sharedWith]
/// * [tags]
@BuiltValue()
abstract class Album implements Built<Album, AlbumBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'images')
  BuiltList<ImageMetaData> get images;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'owner_id')
  String get ownerId;

  @BuiltValueField(wireName: r'shared_with')
  BuiltList<String> get sharedWith;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String> get tags;

  Album._();

  factory Album([void updates(AlbumBuilder b)]) = _$Album;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlbumBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Album> get serializer => _$AlbumSerializer();
}

class _$AlbumSerializer implements PrimitiveSerializer<Album> {
  @override
  final Iterable<Type> types = const [Album, _$Album];

  @override
  final String wireName = r'Album';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Album object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(ImageMetaData)]),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'owner_id';
    yield serializers.serialize(
      object.ownerId,
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
    Album object, {
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
    required AlbumBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImageMetaData)]),
          ) as BuiltList<ImageMetaData>;
          result.images.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'owner_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
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
  Album deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlbumBuilder();
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
