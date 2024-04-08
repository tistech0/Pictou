//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'image_quality.g.dart';

class ImageQuality extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const ImageQuality low = _$low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const ImageQuality medium = _$medium;
  @BuiltValueEnumConst(wireName: r'high', fallback: true)
  static const ImageQuality high = _$high;

  static Serializer<ImageQuality> get serializer => _$imageQualitySerializer;

  const ImageQuality._(String name) : super(name);

  static BuiltSet<ImageQuality> get values => _$values;
  static ImageQuality valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ImageQualityMixin = Object with _$ImageQualityMixin;
