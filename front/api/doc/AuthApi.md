# pictou_api.api.AuthApi

## Load the API package
```dart
import 'package:pictou_api/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**callback**](AuthApi.md#callback) | **GET** /auth/callback/{provider} | OAuth2 callback endpoint. Must not be called directly.
[**login**](AuthApi.md#login) | **GET** /auth/login/{provider} | *The* Authorization/Authentication endpoint.
[**logout**](AuthApi.md#logout) | **GET** /auth/logout | Revoke the refresh token of the user.
[**refreshToken**](AuthApi.md#refreshtoken) | **POST** /auth/refresh | Allows the user to request another access token after it expired.


# **callback**
> AuthenticationResponse callback(provider)

OAuth2 callback endpoint. Must not be called directly.

OAuth2 callback endpoint. Must not be called directly.  This endpoint is called by the OAuth provider after the user has authenticated. This documentation is here to show the structure of the body received by this endpoint, not to call this endpoint.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAuthApi();
final String provider = provider_example; // String | 

try {
    final response = api.callback(provider);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->callback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider** | **String**|  | 

### Return type

[**AuthenticationResponse**](AuthenticationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> login(provider)

*The* Authorization/Authentication endpoint.

*The* Authorization/Authentication endpoint.  User information is sent to /auth/callback/{provider} when the user is authenticated.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAuthApi();
final String provider = provider_example; // String | 

try {
    api.login(provider);
} catch on DioException (e) {
    print('Exception when calling AuthApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout()

Revoke the refresh token of the user.

Revoke the refresh token of the user. The user may still be authenticated with the access token (for up to 3 minutes, by default), but the refresh token is invalidated.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAuthApi();

try {
    api.logout();
} catch on DioException (e) {
    print('Exception when calling AuthApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshToken**
> AuthenticationResponse refreshToken(refreshTokenParams)

Allows the user to request another access token after it expired.

Allows the user to request another access token after it expired. This route checks the opaque refresh token against the database before granting (or not) the new access token.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAuthApi();
final RefreshTokenParams refreshTokenParams = ; // RefreshTokenParams | User id and refresh token

try {
    final response = api.refreshToken(refreshTokenParams);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->refreshToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenParams** | [**RefreshTokenParams**](RefreshTokenParams.md)| User id and refresh token | 

### Return type

[**AuthenticationResponse**](AuthenticationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

