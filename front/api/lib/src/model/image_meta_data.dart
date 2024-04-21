//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'image_meta_data.g.dart';

/// ImageMetaData
///
/// Properties:
/// * [caption]
/// * [id]
/// * [ownerId]
/// * [sharedWith]
/// * [tags]
@BuiltValue()
abstract class ImageMetaData
    implements Built<ImageMetaData, ImageMetaDataBuilder> {
  @BuiltValueField(wireName: r'caption')
  String get caption;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'owner_id')
  String get ownerId;

  @BuiltValueField(wireName: r'shared_with')
  BuiltList<String> get sharedWith;

  @BuiltValueField(wireName: r'tags')
  BuiltList<String> get tags;

  ImageMetaData._();

  factory ImageMetaData([void updates(ImageMetaDataBuilder b)]) =
      _$ImageMetaData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImageMetaDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImageMetaData> get serializer =>
      _$ImageMetaDataSerializer();
}

class _$ImageMetaDataSerializer implements PrimitiveSerializer<ImageMetaData> {
  @override
  final Iterable<Type> types = const [ImageMetaData, _$ImageMetaData];

  @override
  final String wireName = r'ImageMetaData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImageMetaData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'caption';
    yield serializers.serialize(
      object.caption,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
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
    ImageMetaData object, {
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
    required ImageMetaDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caption = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
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
  ImageMetaData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImageMetaDataBuilder();
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
