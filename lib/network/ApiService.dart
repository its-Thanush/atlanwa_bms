import 'package:atlanwa_bms/allImports.dart';
import 'package:dio/dio.dart';

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

  // GET Operating Logs
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
}