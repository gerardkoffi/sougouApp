import 'dart:convert';
import 'package:sougou_app/data/apiDatas/end_points.dart';
import 'package:sougou_app/data/model/magasin_model.dart';

import '../../helpers/shared_values.dart';
import '../apiDatas/apiRequest.dart';
import '../model/common_reponses.dart';

class MagasinRepository {
  Future<List<MagasinModel>> getMagasins() async {
    String url = ("${EndPoints.getMagasin}");

    Map<String, String> header = {
      "Authorization": "Bearer ${auth_token.$}",
    };

    final response = await ApiRequest.get(url: url, headers: header);

    final decodedBody = utf8.decode(response.bodyBytes);

    return magasinListFromJson(decodedBody);
  }

  Future<CommonResponse> postAssortiment(postBody) async {
    try {
      String url = ("${EndPoints.postAssortiment}");
      var reqHeader = {
        "Authorization": "Bearer ${auth_token.$}",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      print("🌐 POST vers $url");
      print("🟨 Headers: $reqHeader");
      print("📦 Body: $postBody");

      final response = await ApiRequest.post(
        url: url,
        headers: reqHeader,
        body: postBody,
      );

      print("📥 Status: ${response.statusCode}");
      print("📥 Body: ${response.body}");
      final decodedBody = utf8.decode(response.bodyBytes);
      return commonResponseFromJson(decodedBody);
    } catch (e, s) {
      print("❌ Erreur dans postProducts: $e");
      print("📍 Stack trace: $s");
      rethrow;
    }
  }
}
