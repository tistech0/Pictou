# pictou_api.api.UsersApi

## Load the API package
```dart
import 'package:pictou_api/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteUser**](UsersApi.md#deleteuser) | **DELETE** /users/self | Delete the user account
[**editSelf**](UsersApi.md#editself) | **PATCH** /users/self | Modify user (self) properties
[**getSelf**](UsersApi.md#getself) | **GET** /users/self | Get user (self) properties
[**getUsers**](UsersApi.md#getusers) | **GET** /users | Get a list of users


# **deleteUser**
> deleteUser()

Delete the user account

Delete the user account

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getUsersApi();

try {
    api.deleteUser();
} catch on DioException (e) {
    print('Exception when calling UsersApi->deleteUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editSelf**
> User editSelf(userPost)

Modify user (self) properties

Modify user (self) properties

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getUsersApi();
final UserPost userPost = ; // UserPost | User to edit

try {
    final response = api.editSelf(userPost);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->editSelf: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userPost** | [**UserPost**](UserPost.md)| User to edit | 

### Return type

[**User**](User.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSelf**
> User getSelf()

Get user (self) properties

Get user (self) properties

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getUsersApi();

try {
    final response = api.getSelf();
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->getSelf: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**User**](User.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsers**
> UserList getUsers()

Get a list of users

Get a list of users

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getUsersApi();

try {
    final response = api.getUsers();
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->getUsers: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserList**](UserList.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

