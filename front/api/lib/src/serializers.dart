//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:pictouapi/src/date_serializer.dart';
import 'package:pictouapi/src/model/date.dart';

import 'package:pictouapi/src/model/album.dart';
import 'package:pictouapi/src/model/album_list.dart';
import 'package:pictouapi/src/model/album_post.dart';
import 'package:pictouapi/src/model/api_error.dart';
import 'package:pictouapi/src/model/api_error_code.dart';
import 'package:pictouapi/src/model/auth_error.dart';
import 'package:pictouapi/src/model/auth_error_kind.dart';
import 'package:pictouapi/src/model/authentication_response.dart';
import 'package:pictouapi/src/model/image_meta_data.dart';
import 'package:pictouapi/src/model/image_patch.dart';
import 'package:pictouapi/src/model/image_quality.dart';
import 'package:pictouapi/src/model/image_upload_response.dart';
import 'package:pictouapi/src/model/images_meta_data.dart';
import 'package:pictouapi/src/model/persisted_user_info.dart';
import 'package:pictouapi/src/model/refresh_token_params.dart';
import 'package:pictouapi/src/model/user.dart';
import 'package:pictouapi/src/model/user_list.dart';
import 'package:pictouapi/src/model/user_post.dart';

part 'serializers.g.dart';

@SerializersFor([
  Album,
  AlbumList,
  AlbumPost,
  ApiError,
  ApiErrorCode,
  AuthError,
  AuthErrorKind,
  AuthenticationResponse,
  ImageMetaData,
  ImagePatch,
  ImageQuality,
  ImageUploadResponse,
  ImagesMetaData,
  PersistedUserInfo,
  $PersistedUserInfo,
  RefreshTokenParams,
  User,
  UserList,
  UserPost,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(PersistedUserInfo.serializer)
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
