import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiUrls.dart';


/// Dio Helper with Singleton Pattern
class DioHelper {
  static DioHelper? _instance;
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Private constructor
  DioHelper._internal() {
    _dio = Dio();
    _setupDio();
  }

  // Singleton instance getter
  static DioHelper get instance {
    _instance ??= DioHelper._internal();
    return _instance!;
  }

  // Get Dio instance
  Dio get dio => _dio;

  /// Setup Dio configurations
  void _setupDio() {
    _dio.options.baseUrl = ApiUrls.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';

    // Setup JSON transformer for background parsing
    // _dio.transformer = JsonTransformer();

    // Validate status codes
    _dio.options.validateStatus = (int? status) {
      return status != null && status < 400;
    };

    // Add interceptors
    _setupDebugInterceptor();
    _setupAuthInterceptor();
    // _setupRetryInterceptor(); // Uncomment if retry is needed
  }

  /// Debug interceptor for logging (only in debug mode)
  void _setupDebugInterceptor() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  /// Setup retry interceptor
  void _setupRetryInterceptor() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        logPrint: (message) => debugPrint('Retry: $message'),
      ),
    );
  }

  /// Auth interceptor to add token to requests
  void _setupAuthInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token from secure storage if available
          String? token = await _storage.read(key: 'auth_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          debugPrint('🚀 Request: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint('❌ Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
          await _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }

  /// Handle Dio errors
  Future<void> _handleError(DioException error) async {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 401:
          await _handleUnauthorized();
          break;
        case 403:
          await _handleForbidden();
          break;
        case 404:
          _showToast('Resource not found');
          break;
        case 429:
          _showToast('Too many requests. Please try again later');
          break;
        case 500:
          _showToast('Server error. Please try again later');
          break;
        case 503:
          _showToast('Service unavailable');
          break;
        default:
          _showToast('Something went wrong');
      }
    } else {
      // Handle timeout and connection errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          _showToast('Connection timeout. Please try again');
          break;
        case DioExceptionType.sendTimeout:
          _showToast('Send timeout. Please try again');
          break;
        case DioExceptionType.receiveTimeout:
          _showToast('Receive timeout. Please try again');
          break;
        case DioExceptionType.connectionError:
          _showToast('No internet connection');
          break;
        default:
          _showToast('Network error occurred');
      }
    }
  }

  /// Handle 401 Unauthorized
  Future<void> _handleUnauthorized() async {
    _showToast('Session expired. Please login again');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _storage.deleteAll();

    // Navigate to login - implement your navigation logic here
    // NavigationService.navigateTo('/login');
  }

  /// Handle 403 Forbidden
  Future<void> _handleForbidden() async {
    _showToast('Access denied');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _storage.deleteAll();

    // Navigate to login
    // NavigationService.navigateTo('/login');
  }

  /// Show toast message - implement your toast logic here
  void _showToast(String message) {
    debugPrint('Toast: $message');
    // Implement your toast logic here
    // Example: Fluttertoast.showToast(msg: message);
  }

  /// Check internet connection
  // Future<bool> hasInternetConnection() async {
  //   return await InternetConnectionChecker().hasConnection;
  // }

  /// Save auth token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// Get auth token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Clear auth token
  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

/// JSON Transformer for background JSON parsing
// class JsonTransformer extends BackgroundTransformer {
//   JsonTransformer() : super();
//
//   @override
//   Future<String> transformRequest(RequestOptions options) async {
//     if (options.data is Map || options.data is List) {
//       return jsonEncode(options.data);
//     }
//     return options.data?.toString() ?? '';
//   }
//
//   @override
//   Future transformResponse(RequestOptions options, ResponseBody response) async {
//     final String responseData = await response.stream.transform(utf8.decoder).join();
//
//     if (responseData.isEmpty) {
//       return responseData;
//     }
//
//     return compute(_parseJson, responseData);
//   }
//
//   static dynamic _parseJson(String text) {
//     return jsonDecode(text);
//   }
// }

/// Convenience methods for Dio instance
Dio dioInstance() {
  return DioHelper.instance.dio;
}

Dio dioLogin() {
  return DioHelper.instance.dio;
}

Dio dioWonder() {
  return DioHelper.instance.dio;
}