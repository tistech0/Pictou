//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_patch.g.dart';

/// UserPatch
///
/// Properties:
/// * [familyName]
/// * [givenName]
/// * [name]
@BuiltValue()
abstract class UserPatch implements Built<UserPatch, UserPatchBuilder> {
  @BuiltValueField(wireName: r'family_name')
  String? get familyName;

  @BuiltValueField(wireName: r'given_name')
  String? get givenName;

  @BuiltValueField(wireName: r'name')
  String? get name;

  UserPatch._();

  factory UserPatch([void updates(UserPatchBuilder b)]) = _$UserPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserPatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserPatch> get serializer => _$UserPatchSerializer();
}

class _$UserPatchSerializer implements PrimitiveSerializer<UserPatch> {
  @override
  final Iterable<Type> types = const [UserPatch, _$UserPatch];

  @override
  final String wireName = r'UserPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.familyName != null) {
      yield r'family_name';
      yield serializers.serialize(
        object.familyName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.givenName != null) {
      yield r'given_name';
      yield serializers.serialize(
        object.givenName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserPatch object, {
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
    required UserPatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'family_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.familyName = valueDes;
          break;
        case r'given_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.givenName = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserPatchBuilder();
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
