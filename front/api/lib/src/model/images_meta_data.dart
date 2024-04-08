//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pictouapi/src/model/image_meta_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'images_meta_data.g.dart';

/// ImagesMetaData
///
/// Properties:
/// * [images]
@BuiltValue()
abstract class ImagesMetaData
    implements Built<ImagesMetaData, ImagesMetaDataBuilder> {
  @BuiltValueField(wireName: r'images')
  BuiltList<ImageMetaData> get images;

  ImagesMetaData._();

  factory ImagesMetaData([void updates(ImagesMetaDataBuilder b)]) =
      _$ImagesMetaData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImagesMetaDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImagesMetaData> get serializer =>
      _$ImagesMetaDataSerializer();
}

class _$ImagesMetaDataSerializer
    implements PrimitiveSerializer<ImagesMetaData> {
  @override
  final Iterable<Type> types = const [ImagesMetaData, _$ImagesMetaData];

  @override
  final String wireName = r'ImagesMetaData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImagesMetaData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(ImageMetaData)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImagesMetaData object, {
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
    required ImagesMetaDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImageMetaData)]),
          ) as BuiltList<ImageMetaData>;
          result.images.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImagesMetaData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImagesMetaDataBuilder();
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
