import 'package:atlanwa_bms/allImports.dart';
import 'package:dio/dio.dart';

import '../model/loginModel.dart';
import 'ApiUrls.dart';


class ApiServices{

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
}
