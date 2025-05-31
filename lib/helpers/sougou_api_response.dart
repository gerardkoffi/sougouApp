
import 'package:http/http.dart' as http;

import '../data/middleware/groupe_middleware.dart';
import '../data/middleware/maintenace.dart';
import '../data/middleware/middleware.dart';

class SougouApiResponse {
  static http.Response check(http.Response response,
      {Middleware? middleware, GroupMiddleware? groupMiddleWare}) {
    _commonCheck(response);
    if (middleware != null) {
      middleware.next(response);
    }
    if (groupMiddleWare != null) {
      groupMiddleWare.next(response);
    }
    return response;
  }

  static _commonCheck(http.Response response) {
    try {
      MaintenanceMiddleware().next(response);
    } catch (e, s) {
      print("❌ Exception dans MaintenanceMiddleware: $e");
      print("📍 Stack trace:\n$s");
      rethrow; // ou supprime ce rethrow temporairement pour éviter le crash
    }
  }

}