import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sougou_app/utils/constants.dart';

class ApiException implements Exception {
  final String errorMessage;
  ApiException(this.errorMessage);

  @override
    String toString() => errorMessage;
}


class ApiCall {
  static Map<String, dynamic> headers() {
    const jwtToken = '20000';

    return {
      'Authorization': 'Bearer $jwtToken',
      'Accept': 'application/json',
    };
  }

// Api Url
  static String getSystemSettings = '${databaseUrl}get-system-settings';
  //static String getDrawerItems = '${databaseUrl}get-drawer-items';
  //static String getOnbording = '${databaseUrl}get-onboarding-list';
  static String setFcm = '${databaseUrl}add-fcm';

  static Future<Map<String, dynamic>> postapi({
    required String url,
    required Map<String, dynamic> body,
    required bool useAuthtoken,
  }) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap(body, ListFormat.multiCompatible);

      print('API Called POST: $url with $body');
      print('Body Params: $body');

      final response = await dio.post(
        url,
        data: formData,
        options: useAuthtoken ? Options(headers: headers()) : null,
      );

      print('Response: $response');

      return response.data;
    } on DioException catch (e) {
      ApiException(e.toString());
    } on ApiException catch (e) {
      throw ApiException(e.toString());
    } catch (e) {
      throw ApiException(e.toString());
    }
    return {};
  }

  static Future<Map<String, dynamic>> getapi({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dio = Dio();

      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      final resp = response.data;

      return resp;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Url is $url');
        print(e.response?.data);
        print(e.response?.statusCode);
      }
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      print(e);
    }
    return {};
  }
}


class ApiSougou {
  static const String dataUrl = "http://207.180.210.22:9000/api/v1/"; // À remplacer

  static Map<String, dynamic> headers() {
    const jwtToken = '20000';

    return {
      'Authorization': 'Bearer $jwtToken',
      'Accept': 'application/json',
    };
  }

  // API Endpoints
  static String getGenerateOtp = '${dataUrl}users/generate-otp';
  static String getVerifyOtp = '${dataUrl}users/verify-otp';
  static String getLogin = '${dataUrl}users/login';
  static String getLogout = '${dataUrl}users/logout';


  static Future<Map<String, dynamic>> postapi({
    required String url,
    required Map<String, dynamic> body,
    bool useAuthToken = true, // Valeur par défaut
  }) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap(body, ListFormat.multiCompatible);

      if (kDebugMode) {
        debugPrint('🔵 API POST: $url');
        debugPrint('📦 Body: $body');
      }

      final response = await dio.post(
        url,
        data: formData,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      if (kDebugMode) debugPrint('✅ Response: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e, url);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
    return {"error": true, "message": "Something went wrong"};
  }

  static Future<Map<String, dynamic>> getapi({
    required String url,
    bool useAuthToken = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dio = Dio();

      if (kDebugMode) debugPrint('🔵 API GET: $url');

      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e, url);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
    return {"error": true, "message": "Something went wrong"};
  }

  static void _handleDioError(DioException e, String url) {
    if (kDebugMode) {
      debugPrint('❌ API ERROR at $url');
      debugPrint('🚨 Status Code: ${e.response?.statusCode}');
      debugPrint('📜 Response: ${e.response?.data}');
    }
    throw ApiException(e.message ?? 'Unknown Dio error');
  }
}
