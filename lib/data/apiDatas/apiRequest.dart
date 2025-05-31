import 'package:http/http.dart' as http;
import 'package:sougou_app/helpers/sougou_api_response.dart';

import '../../helpers/main_helper.dart';
import '../middleware/groupe_middleware.dart';
import '../middleware/middleware.dart';

class ApiRequest {
  static Future<http.Response> get(
      {required String url,
        Map<String, String>? headers,
        Middleware? middleware,
        GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.get(uri, headers: headerMap);
    return SougouApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    required String body,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }

    print("📤 POST vers $url");
    print("🟨 Headers: $headerMap");
    print("📦 Body: $body");

    final response = await http.post(uri, headers: headerMap, body: body);

    print("✅ Réponse HTTP reçue: ${response.statusCode}");
    print("📥 Body brut: ${response.body}");

    // ATTENTION ICI
    final checkedResponse = SougouApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );

    print("✅ Réponse après check()");
    return checkedResponse;
  }


  static Future<http.Response> delete(
      {required String url,
        Map<String, String>? headers,
        Middleware? middleware,
        GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.delete(uri, headers: headerMap);
    return SougouApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }
}
