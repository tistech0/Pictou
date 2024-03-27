//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pictou_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_list.g.dart';

/// UserList
///
/// Properties:
/// * [users]
@BuiltValue()
abstract class UserList implements Built<UserList, UserListBuilder> {
  @BuiltValueField(wireName: r'users')
  BuiltList<User> get users;

  UserList._();

  factory UserList([void updates(UserListBuilder b)]) = _$UserList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserList> get serializer => _$UserListSerializer();
}

class _$UserListSerializer implements PrimitiveSerializer<UserList> {
  @override
  final Iterable<Type> types = const [UserList, _$UserList];

  @override
  final String wireName = r'UserList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(BuiltList, [FullType(User)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserList object, {
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
    required UserListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(User)]),
          ) as BuiltList<User>;
          result.users.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserListBuilder();
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
