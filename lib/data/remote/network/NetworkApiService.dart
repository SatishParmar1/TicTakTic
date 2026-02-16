import 'dart:io';
import 'package:dio/dio.dart';
import '../../../constants/ConstantMethods.dart';
import '../../sharedpref/app_preferences.dart';
import '../AppException.dart';
import 'BaseApiService.dart';
import 'Logging.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url) async {
    String? token = "";
    token = await ConstantMethods.getcookies();
    dynamic responseJson;
    try {
      Dio _dio =
          Dio(BaseOptions(headers: {'Authorization': 'bearer ' + token}))
            ..interceptors.add(Logging());
      final response = await _dio.get(BaseApiService.BASE_URL + url);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url) async {
    String? api_key = "";
    api_key = await AppPreferences().getApiKey();
    dynamic responseJson;
    try {
      Dio _dio = Dio(BaseOptions(headers: {'Authorization': api_key}))
        ..interceptors.add(Logging());
      final response = await _dio.post(BaseApiService.BASE_URL + url);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future putResponse(String url, dynamic data) async {
    String? token = await AppPreferences().getAppToken();
    dynamic responseJson;
    try {
      Dio _dio =
          Dio(BaseOptions(headers: {'Authorization': 'bearer ' + token!}))
            ..interceptors.add(Logging());
      final response =
          await _dio.put(BaseApiService.BASE_URL + url, data: data);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future deleteResponse(String url, FormData formData) async {
    String? token = "";
    token = await AppPreferences().getAppToken();
    dynamic responseJson;
    try {
      Dio _dio =
          Dio(BaseOptions(headers: {'Authorization': 'bearer ' + token!}))
            ..interceptors.add(Logging());
      final response =
          await _dio.delete(BaseApiService.BASE_URL + url, data: formData);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future patchResponse(String url, dynamic formData) async {
    String? token = "";
    token = await AppPreferences().getAppToken();
    dynamic responseJson;
    try {
      Dio _dio = Dio(BaseOptions(headers: {
        'Authorization': 'bearer ' + token!,
        HttpHeaders.contentTypeHeader: "application/json",
      }))
        ..interceptors.add(Logging());
      final response =
          await _dio.patch(BaseApiService.BASE_URL + url, data: formData);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future patchResponseForm(String url, FormData formData) async {
    String? token = "";
    token = await AppPreferences().getAppToken();
    dynamic responseJson;
    try {
      Dio _dio = Dio(BaseOptions(headers: {
        'Authorization': 'bearer ' + token!,
        HttpHeaders.contentTypeHeader: "application/json",
      }))
        ..interceptors.add(Logging());
      final response =
          await _dio.patch(BaseApiService.BASE_URL + url, data: formData);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getResponseQuery(String url, Map<String, dynamic> formData) async {
    final String api_key = await ConstantMethods.getcookies();
    dynamic responseJson;
    try {
      Dio _dio =
          Dio(BaseOptions(headers: {'Authorization': 'bearer ' + api_key}))
            ..interceptors.add(Logging());
      final response = await _dio.get(BaseApiService.BASE_URL + url,
          queryParameters: formData);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = response.data;
        return responseJson;
      case 201:
        dynamic responseJson = response.data;
        return responseJson;
      case 409:
        dynamic responseJson = response.data;
        return responseJson;
      case 400:
        dynamic responseJson = response.data;
        return responseJson;
      case 401:
      case 403:
        dynamic responseJson = response.data;
        return responseJson;
      case 404:
        dynamic responseJson = response.data;
        return responseJson;
      case 500:
        dynamic responseJson = response.data;
        return responseJson;
      default:
        throw FetchDataException(
            'Error occurred while communication with server with status code : ${response.statusCode}');
    }
  }

  @override
  Future postResponseString(String url, dynamic formData) async {
    String? api_key = "";
    api_key = await ConstantMethods.getcookies();
    dynamic responseJson;
    try {
      Dio _dio =

          Dio(BaseOptions(headers: {'Authorization': 'bearer ' + api_key}))
            ..interceptors.add(Logging());
      final response =
          await _dio.post(BaseApiService.BASE_URL + url, data: formData);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      return returnResponse((e as DioError).response!);
    }
    return responseJson;
  }
}
