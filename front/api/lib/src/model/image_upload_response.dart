//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'image_upload_response.g.dart';

/// ImageUploadResponse
///
/// Properties:
/// * [id]
@BuiltValue()
abstract class ImageUploadResponse
    implements Built<ImageUploadResponse, ImageUploadResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  ImageUploadResponse._();

  factory ImageUploadResponse([void updates(ImageUploadResponseBuilder b)]) =
      _$ImageUploadResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImageUploadResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImageUploadResponse> get serializer =>
      _$ImageUploadResponseSerializer();
}

class _$ImageUploadResponseSerializer
    implements PrimitiveSerializer<ImageUploadResponse> {
  @override
  final Iterable<Type> types = const [
    ImageUploadResponse,
    _$ImageUploadResponse
  ];

  @override
  final String wireName = r'ImageUploadResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImageUploadResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImageUploadResponse object, {
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
    required ImageUploadResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImageUploadResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImageUploadResponseBuilder();
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
