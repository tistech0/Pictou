// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_quality.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ImageQuality _$low = const ImageQuality._('low');
const ImageQuality _$medium = const ImageQuality._('medium');
const ImageQuality _$high = const ImageQuality._('high');

ImageQuality _$valueOf(String name) {
  switch (name) {
    case 'low':
      return _$low;
    case 'medium':
      return _$medium;
    case 'high':
      return _$high;
    default:
      return _$high;
  }
}

final BuiltSet<ImageQuality> _$values =
    new BuiltSet<ImageQuality>(const <ImageQuality>[
  _$low,
  _$medium,
  _$high,
]);

class _$ImageQualityMeta {
  const _$ImageQualityMeta();
  ImageQuality get low => _$low;
  ImageQuality get medium => _$medium;
  ImageQuality get high => _$high;
  ImageQuality valueOf(String name) => _$valueOf(name);
  BuiltSet<ImageQuality> get values => _$values;
}

abstract class _$ImageQualityMixin {
  // ignore: non_constant_identifier_names
  _$ImageQualityMeta get ImageQuality => const _$ImageQualityMeta();
}

Serializer<ImageQuality> _$imageQualitySerializer =
    new _$ImageQualitySerializer();

class _$ImageQualitySerializer implements PrimitiveSerializer<ImageQuality> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
  };

  @override
  final Iterable<Type> types = const <Type>[ImageQuality];
  @override
  final String wireName = 'ImageQuality';

  @override
  Object serialize(Serializers serializers, ImageQuality object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ImageQuality deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ImageQuality.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
