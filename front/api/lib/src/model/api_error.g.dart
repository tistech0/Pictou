// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiError extends ApiError {
  @override
  final String description;
  @override
  final ApiErrorCode errorCode;
  @override
  final int httpStatus;

  factory _$ApiError([void Function(ApiErrorBuilder)? updates]) =>
      (new ApiErrorBuilder()..update(updates))._build();

  _$ApiError._(
      {required this.description,
      required this.errorCode,
      required this.httpStatus})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'ApiError', 'description');
    BuiltValueNullFieldError.checkNotNull(errorCode, r'ApiError', 'errorCode');
    BuiltValueNullFieldError.checkNotNull(
        httpStatus, r'ApiError', 'httpStatus');
  }

  @override
  ApiError rebuild(void Function(ApiErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiErrorBuilder toBuilder() => new ApiErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiError &&
        description == other.description &&
        errorCode == other.errorCode &&
        httpStatus == other.httpStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, errorCode.hashCode);
    _$hash = $jc(_$hash, httpStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiError')
          ..add('description', description)
          ..add('errorCode', errorCode)
          ..add('httpStatus', httpStatus))
        .toString();
  }
}

class ApiErrorBuilder implements Builder<ApiError, ApiErrorBuilder> {
  _$ApiError? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ApiErrorCode? _errorCode;
  ApiErrorCode? get errorCode => _$this._errorCode;
  set errorCode(ApiErrorCode? errorCode) => _$this._errorCode = errorCode;

  int? _httpStatus;
  int? get httpStatus => _$this._httpStatus;
  set httpStatus(int? httpStatus) => _$this._httpStatus = httpStatus;

  ApiErrorBuilder() {
    ApiError._defaults(this);
  }

  ApiErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _errorCode = $v.errorCode;
      _httpStatus = $v.httpStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiError;
  }

  @override
  void update(void Function(ApiErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiError build() => _build();

  _$ApiError _build() {
    final _$result = _$v ??
        new _$ApiError._(
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ApiError', 'description'),
            errorCode: BuiltValueNullFieldError.checkNotNull(
                errorCode, r'ApiError', 'errorCode'),
            httpStatus: BuiltValueNullFieldError.checkNotNull(
                httpStatus, r'ApiError', 'httpStatus'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
