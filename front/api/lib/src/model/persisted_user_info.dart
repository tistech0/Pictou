//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'persisted_user_info.g.dart';

/// PersistedUserInfo
///
/// Properties:
/// * [email]
/// * [refreshTokenExp]
/// * [userId]
/// * [familyName]
/// * [givenName]
/// * [name]
/// * [refreshToken]
@BuiltValue(instantiable: false)
abstract class PersistedUserInfo {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'refresh_token_exp')
  DateTime get refreshTokenExp;

  @BuiltValueField(wireName: r'user_id')
  String get userId;

  @BuiltValueField(wireName: r'family_name')
  String? get familyName;

  @BuiltValueField(wireName: r'given_name')
  String? get givenName;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'refresh_token')
  String? get refreshToken;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersistedUserInfo> get serializer =>
      _$PersistedUserInfoSerializer();
}

class _$PersistedUserInfoSerializer
    implements PrimitiveSerializer<PersistedUserInfo> {
  @override
  final Iterable<Type> types = const [PersistedUserInfo];

  @override
  final String wireName = r'PersistedUserInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersistedUserInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'refresh_token_exp';
    yield serializers.serialize(
      object.refreshTokenExp,
      specifiedType: const FullType(DateTime),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
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
    if (object.refreshToken != null) {
      yield r'refresh_token';
      yield serializers.serialize(
        object.refreshToken,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PersistedUserInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  @override
  PersistedUserInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized,
        specifiedType: FullType($PersistedUserInfo)) as $PersistedUserInfo;
  }
}

/// a concrete implementation of [PersistedUserInfo], since [PersistedUserInfo] is not instantiable
@BuiltValue(instantiable: true)
abstract class $PersistedUserInfo
    implements
        PersistedUserInfo,
        Built<$PersistedUserInfo, $PersistedUserInfoBuilder> {
  $PersistedUserInfo._();

  factory $PersistedUserInfo(
          [void Function($PersistedUserInfoBuilder)? updates]) =
      _$$PersistedUserInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($PersistedUserInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$PersistedUserInfo> get serializer =>
      _$$PersistedUserInfoSerializer();
}

class _$$PersistedUserInfoSerializer
    implements PrimitiveSerializer<$PersistedUserInfo> {
  @override
  final Iterable<Type> types = const [$PersistedUserInfo, _$$PersistedUserInfo];

  @override
  final String wireName = r'$PersistedUserInfo';

  @override
  Object serialize(
    Serializers serializers,
    $PersistedUserInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object,
        specifiedType: FullType(PersistedUserInfo))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersistedUserInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'refresh_token_exp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.refreshTokenExp = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
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
        case r'refresh_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $PersistedUserInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $PersistedUserInfoBuilder();
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
