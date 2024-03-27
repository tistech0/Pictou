# pictou_api.api.AlbumsApi

## Load the API package
```dart
import 'package:pictou_api/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addImageToAlbum**](AlbumsApi.md#addimagetoalbum) | **POST** /albums/{id}/images/{image_id} | Add an image to an album
[**createAlbum**](AlbumsApi.md#createalbum) | **POST** /albums | Create a new album
[**deleteAlbum**](AlbumsApi.md#deletealbum) | **DELETE** /albums/{id} | Delete an album
[**editAlbum**](AlbumsApi.md#editalbum) | **PATCH** /albums/{id} | Modify an album
[**getAlbum**](AlbumsApi.md#getalbum) | **GET** /albums/{id} | Get an album by its id.
[**getAlbums**](AlbumsApi.md#getalbums) | **GET** /albums | Get a list of albums
[**removeImageFromAlbum**](AlbumsApi.md#removeimagefromalbum) | **DELETE** /albums/{id}/images/{image_id} | Remove an image from an album


# **addImageToAlbum**
> Album addImageToAlbum(id, imageId)

Add an image to an album

Add an image to an album

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Album to add the image to
final String imageId = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Image to add

try {
    final response = api.addImageToAlbum(id, imageId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->addImageToAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album to add the image to | 
 **imageId** | **String**| Image to add | 

### Return type

[**Album**](Album.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createAlbum**
> Album createAlbum(albumPost)

Create a new album

Create a new album

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final AlbumPost albumPost = ; // AlbumPost | Album to create

try {
    final response = api.createAlbum(albumPost);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->createAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **albumPost** | [**AlbumPost**](AlbumPost.md)| Album to create | 

### Return type

[**Album**](Album.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAlbum**
> deleteAlbum(id)

Delete an album

Delete an album

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Album to delete

try {
    api.deleteAlbum(id);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->deleteAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album to delete | 

### Return type

void (empty response body)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editAlbum**
> Album editAlbum(id, albumPost)

Modify an album

Modify an album

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Album to edit
final AlbumPost albumPost = ; // AlbumPost | Album to edit

try {
    final response = api.editAlbum(id, albumPost);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->editAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album to edit | 
 **albumPost** | [**AlbumPost**](AlbumPost.md)| Album to edit | 

### Return type

[**Album**](Album.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAlbum**
> Album getAlbum(id)

Get an album by its id.

Get an album by its id.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Identifier of the album

try {
    final response = api.getAlbum(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->getAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Identifier of the album | 

### Return type

[**Album**](Album.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAlbums**
> AlbumList getAlbums(limit, offset)

Get a list of albums

Get a list of albums

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final int limit = 10; // int | Number of albums to return
final int offset = 0; // int | Offset of the query in the albums list to return

try {
    final response = api.getAlbums(limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->getAlbums: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Number of albums to return | [optional] 
 **offset** | **int**| Offset of the query in the albums list to return | [optional] 

### Return type

[**AlbumList**](AlbumList.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeImageFromAlbum**
> Album removeImageFromAlbum(id, imageId)

Remove an image from an album

Remove an image from an album

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getAlbumsApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Album to remove the image from
final String imageId = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Image to remove

try {
    final response = api.removeImageFromAlbum(id, imageId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlbumsApi->removeImageFromAlbum: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Album to remove the image from | 
 **imageId** | **String**| Image to remove | 

### Return type

[**Album**](Album.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

