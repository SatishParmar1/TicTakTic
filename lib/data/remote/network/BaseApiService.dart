import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class BaseApiService {
 /* final String _baseUrl = dotenv.env['BASE_URL']!;
   String get baseUrl => _baseUrl;*/
  static  final String _stagingURL = dotenv.env['BASE_URL']!;
  static const String _prodEndpoint = "https://api.tyrebook.in/api/v1";
  // static const String _debugLocalEndpoint = "http://10.0.2.2:8000/";
  //static const String _productionEndpoint = "https://api.kelola.co/";
//"https://staging.regripindia.com/"
  static final String BASE_URL = kReleaseMode ? _stagingURL : _stagingURL;
  static final String STAGING_URL = kReleaseMode ? _stagingURL : _stagingURL;

  Future getResponse(
    String url,
  );

  static const String BASE_URL_IMAGE = "http://13.200.120.232/";

  Future getResponseQuery(String url, Map<String, dynamic> queryData);

  Future postResponse(String url);

  Future postResponseString(String url, dynamic formData);

  Future putResponse(String path, dynamic data);

  Future deleteResponse(String url, FormData formData);

  Future patchResponseForm(String url, FormData formData);

  Future patchResponse(String url, String formData);
}
