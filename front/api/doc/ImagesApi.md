# pictou_api.api.ImagesApi

## Load the API package
```dart
import 'package:pictou_api/api.dart';
```

All URIs are relative to */api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteImage**](ImagesApi.md#deleteimage) | **DELETE** /images/{id} | Delete an image
[**editImage**](ImagesApi.md#editimage) | **PATCH** /images/{id} | Set/modfiy image metadata, share/unshare, ...
[**getImage**](ImagesApi.md#getimage) | **GET** /images/{id} | Get an image by its id.
[**getImages**](ImagesApi.md#getimages) | **GET** /images | Get the images owned by or shared with the user
[**uploadImage**](ImagesApi.md#uploadimage) | **POST** /images | Upload an image


# **deleteImage**
> deleteImage(id)

Delete an image

Delete an image

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getImagesApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Image to delete

try {
    api.deleteImage(id);
} catch on DioException (e) {
    print('Exception when calling ImagesApi->deleteImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Image to delete | 

### Return type

void (empty response body)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editImage**
> ImageMetaData editImage(id, imagePatch)

Set/modfiy image metadata, share/unshare, ...

Set/modfiy image metadata, share/unshare, ...

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getImagesApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Image to edit
final ImagePatch imagePatch = ; // ImagePatch | Image to edit

try {
    final response = api.editImage(id, imagePatch);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ImagesApi->editImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Image to edit | 
 **imagePatch** | [**ImagePatch**](ImagePatch.md)| Image to edit | 

### Return type

[**ImageMetaData**](ImageMetaData.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImage**
> Uint8List getImage(id, quality)

Get an image by its id.

Get an image by its id.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getImagesApi();
final String id = e58ed763-928c-4155-bee9-fdbaaadc15f3; // String | Identifier of the image
final ImageQuality quality = Low; // ImageQuality | Image quality

try {
    final response = api.getImage(id, quality);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ImagesApi->getImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Identifier of the image | 
 **quality** | [**ImageQuality**](.md)| Image quality | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/jpeg, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImages**
> ImagesMetaData getImages(limit, offset, quality)

Get the images owned by or shared with the user

Get the images owned by or shared with the user  This method returns the metadata of the images not the effective images. The client must make a request for each image independently. The list can be filtered by quality, and paginated.

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getImagesApi();
final int limit = 10; // int | Number of images to return
final int offset = 0; // int | Offset of the query in the image list to return
final ImageQuality quality = low; // ImageQuality | Image quality

try {
    final response = api.getImages(limit, offset, quality);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ImagesApi->getImages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Number of images to return | [optional] 
 **offset** | **int**| Offset of the query in the image list to return | [optional] 
 **quality** | [**ImageQuality**](.md)| Image quality | [optional] 

### Return type

[**ImagesMetaData**](ImagesMetaData.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadImage**
> ImageUploadResponse uploadImage(image)

Upload an image

Upload an image

### Example
```dart
import 'package:pictou_api/api.dart';

final api = PictouApi().getImagesApi();
final MultipartFile image = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.uploadImage(image);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ImagesApi->uploadImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **image** | **MultipartFile**|  | 

### Return type

[**ImageUploadResponse**](ImageUploadResponse.md)

### Authorization

[JWT_Access_Token](../README.md#JWT_Access_Token)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

