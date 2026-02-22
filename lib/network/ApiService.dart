import 'package:atlanwa_bms/allImports.dart';
import 'package:dio/dio.dart';

import '../model/FireFetchModel.dart';
import '../model/FireSubmitModel.dart';
import '../model/GuardEntryModel.dart';
import '../model/LiftFetchModel.dart';
import '../model/OpLogEntryModel.dart';
import '../model/OperationalLogModel.dart';
import '../model/loginModel.dart';
import 'ApiUrls.dart';

class ApiServices {
  static Future<LoginRS> invokeLogin(LoginRQ requestModel) async {
    try {
      final url = ApiUrls.login;

      // Create a new dio instance without auth interceptor for login
      final dioWithoutAuth = Dio();
      dioWithoutAuth.options.baseUrl = ApiUrls.baseUrl;
      dioWithoutAuth.options.connectTimeout = const Duration(seconds: 30);
      dioWithoutAuth.options.receiveTimeout = const Duration(seconds: 30);
      dioWithoutAuth.options.headers['Content-Type'] = 'application/json';

      final response = await dioWithoutAuth.post(
        url,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginRS.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      print('Dio Error: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      throw Exception('Login Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<List<OperationallogsModel>> getOperatingLogs() async {
    try {
      final url = ApiUrls.operatingLog;

      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      // Add your auth token here if needed
      // dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<OperationallogsModel> logs = [];
        if (response.data is List) {
          logs = (response.data as List)
              .map((json) => OperationallogsModel.fromJson(json))
              .toList();
        }
        return logs;
      } else {
        throw Exception('Failed to fetch logs: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      print('Dio Error: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      throw Exception('Fetch Logs Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<LiftFetchModel> getLiftsStatus() async {
    try {
      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.get(ApiUrls.Lifts);

      if (response.statusCode == 200) {
        return LiftFetchModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch logs: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      throw Exception('Fetch Logs Error: ${dioError.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  static Future<GuardEntryRS> GuardEntry(GuardEntryRQ requestModel) async {
    try {
      final url = ApiUrls.GuardEntry;

      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        url,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GuardEntryRS.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to submit guard entry: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      print('Dio Error: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      print('Error Response: ${dioError.response?.data}');
      throw Exception('Guard Entry Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<FireFetchRS> FireFetch (FireFetchRQ requestModel) async {
    try {
      final url = ApiUrls.fireFetch;

      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        url,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FireFetchRS.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      throw Exception('Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<FireSubmitRS> FireSubmit (FireSubmitRQ requestModel) async {
    try {
      final url = ApiUrls.fireSubmit;

      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        url,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FireSubmitRS.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed : ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      throw Exception('Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<OpLogEntryRS> OperatorLogEntry (OpLogEntryRQ requestModel) async {
    try {
      final url = ApiUrls.operatingLog;

      final dio = Dio();
      dio.options.baseUrl = ApiUrls.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        url,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OpLogEntryRS.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed : ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      throw Exception('Error: ${dioError.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error occurred');
    }
  }



}