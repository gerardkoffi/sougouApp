import 'dart:convert';
import 'package:sougou_app/data/apiDatas/end_points.dart';
import 'package:sougou_app/data/model/magasin_model.dart';

import '../../helpers/shared_values.dart';
import '../apiDatas/apiRequest.dart';

class MagasinRepository {
  Future<MagasinsResponse> getMagasins() async {
    String url = ("${EndPoints.getMagasin}");

    Map<String, String> header = {
      "Authorization": "Bearer ${auth_token.$}",
    };

    final response = await ApiRequest.get(url: url, headers: header);

    return MagasinsResponse.fromJson(json.decode(response.body));
  }

/*  Future<ShopInfoResponse> getShopInfo() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/shop/info");
    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);
    // print("shop info " + response.body.toString());
    // return shopInfoResponseFromJson(response.body);
    return ShopInfoResponse.fromJson(json.decode(response.body));
  }

  Future<Top12ProductResponse> getTop12ProductRequest() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/top-12-product");

    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);
    return top12ProductResponseFromJson(response.body);
  }

  Future<Map<String, ChartResponse>> chartRequest() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/sales-stat");

    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);

    // print("chartRequest res" + response.body.toString());
    return chartResponseFromJson(response.body);
  }

  Future<SellerPackageResponse> getSellerPackageRequest() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/seller-packages-list");

    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };

    // print("package url " + url.toString());

    final response = await ApiRequest.get(url: url, headers: header);

    // print("package res body " + response.body.toString());

    return sellerPackageResponseFromJson(response.body);
  }

  Future<CommonResponse> purchaseFreePackageRequest(packageId) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/seller-package/free-package");

    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
    };

    var post_data = jsonEncode(
        {"package_id": packageId, "payment_option": "No Method", "amount": 0});

    final response =
    await ApiRequest.post(url: url, headers: header, body: post_data);

    return commonResponseFromJson(response.body);
  }

  Future<List<CategoryWiseProductResponse>>
  getCategoryWiseProductRequest() async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/dashboard/category-wise-products");
    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);
    return categoryWiseProductResponseFromJson(response.body);
  }

  Future<ShopInfoResponse> getShopInfo() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/shop/info");
    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);
    // print("shop info " + response.body.toString());
    // return shopInfoResponseFromJson(response.body);
    return ShopInfoResponse.fromJson(json.decode(response.body));
  }

  Future<ShopPackageResponse> getShopPackage() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/package/info");
    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    final response = await ApiRequest.get(url: url, headers: header);
    // print("shop info " + response.body.toString());
    return shopPackageResponseFromJson(response.body);
  }

  Future<CommonResponse> updateShopSetting(var post_body) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/shop-update");
    Map<String, String> header = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    // print("updateShopSetting body" + post_body.toString());

    final response =
    await ApiRequest.post(url: url, headers: header, body: post_body);

    // print("shop info " + response.body.toString());
    return commonResponseFromJson(response.body);
  }*/
}
