
import 'dart:convert';

import 'package:sougou_app/data/apiDatas/end_points.dart';
import 'package:sougou_app/data/model/common_reponses.dart';
import 'package:sougou_app/data/model/famille_model.dart' as famille_model;
import 'package:sougou_app/data/model/marques_model.dart' as marques_model;
import 'package:sougou_app/data/model/rayon_model.dart' as rayon_model;
import '../../helpers/shared_values.dart';
import '../apiDatas/apiRequest.dart';
import '../model/delete_model.dart';
import '../model/famille_model.dart';
import '../model/marques_model.dart';
import '../model/origine_model.dart';
import '../model/origine_model.dart' as origine_model;
import '../model/product_model.dart';
import '../model/rayon_model.dart';
import '../model/secteur_model.dart';
import '../model/secteur_model.dart' as secteur_model;
import '../model/sous_famille_model.dart';
import '../model/sous_famille_model.dart' as sous_famille_model;

class ProductRepository {

  Future<ProductsResponse> getProducts(int page) async {
    final url = 'http://207.180.210.22:9000/api/v1/produits?page=$page&size=10&sortBy=id&sortDir=desc';

    try {
      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${auth_token.$ ?? ''}",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));

        // S'assurer que le JSON est valide
        if (decoded is Map<String, dynamic>) {
          return ProductsResponse.fromJson(decoded);
        } else {
          return ProductsResponse(
            statusCode: "500",
            message: "Réponse JSON inattendue",
            corps: CorpsProduits(
              produits: [],
              totalItems: 0,
              totalPages: 0,
              currentPage: 0,
            ),
          );
        }
      } else {
        return ProductsResponse(
          statusCode: response.statusCode.toString(),
          message: "Erreur serveur (${response.statusCode})",
          corps: CorpsProduits(
            produits: [],
            totalItems: 0,
            totalPages: 0,
            currentPage: 0,
          ),
        );
      }
    } catch (e) {
      return ProductsResponse(
        statusCode: "500",
        message: "Erreur lors de la récupération des produits: $e",
        corps: CorpsProduits(
          produits: [],
          totalItems: 0,
          totalPages: 0,
          currentPage: 0,
        ),
      );
    }
  }



  Future<CommonResponse> postProducts(postBody) async {
    try {
      String url = ("${EndPoints.postProduct}");
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

      return commonResponseFromJson(response.body);
    } catch (e, s) {
      print("❌ Erreur dans postProducts: $e");
      print("📍 Stack trace: $s");
      rethrow;
    }
  }



  productDeleteReq({required id}) async {
    String url = ("${EndPoints.deleteProducts}/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "Authorization": "Bearer ${auth_token.$}",
    });
    //print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  Future<List<marques_model.Marque>> getMarque() async {
    String url = ("${EndPoints.getMarques}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return marqueListFromJson(response.body);
  }

  Future<List<rayon_model.Rayon>> getRayon() async {
    String url = ("${EndPoints.getRayons}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return rayonListFromJson(response.body);
  }

  Future<List<famille_model.Famille>> getFamille() async {
    String url = ("${EndPoints.getFamilles}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return familleListFromJson(response.body);

  }

  Future<List<sous_famille_model.SousFamille>> getSousFamilles() async {
    String url = ("${EndPoints.getSousFamille}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return sousFamilleListFromJson(response.body);

  }

  Future<List<origine_model.Origine>> getOrigine() async {
    String url = ("${EndPoints.getOrigines}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return origineListFromJson(response.body);
  }

  Future<List<secteur_model.Secteur>> getSecteur() async {
    String url = ("${EndPoints.getSecteurs}");

    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return secteurListFromJson(response.body);
  }

  productStatusChangeReq({required id, status}) async {
    String url = ("${EndPoints.postChangeStatus}");

    var post_body = jsonEncode({"id": id, "status": status});
    var reqHeader = {
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json"
    };

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: post_body);

    //print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }


/*Future<ProductsResponse> getWholesaleProducts({name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/wholesale-products"
        "?page=${page}&name=${name}");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productsResponseFromJson(response.body);
  }

  Future<AuctionProductListResponse> getAuctionProducts(
      {name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-products"
        "?page=${page}&name=${name}");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return auctionProductListResponseFromJson(response.body);
  }

  Future<AuctionProductEditResponse> auctionProductEdit({id, lang}) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-products/edit/$id");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$!,
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    return auctionProductEditResponseFromJson(response.body);
  }

  Future<CommonResponse> auctionUpdateProductResponse(
      postBody, productId, lang) async {
    // print('auction update product reponse');

    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-products/update/$productId?lang=$lang");

    var reqHeader = {
      "Authorization": "Bearer ${access_token.$}",
    };

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);
    // print(response.body);

    return commonResponseFromJson(response.body);
  }

  Future<AuctionProductBids> auctionProductBids({page = 1, id}) async {
    // print('add auction product bids response');

    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-product-bids/edit/$id"
        "?page=$page");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return auctionProductBidsFromJson(response.body);
  }

  Future<CommonResponse> addAuctionProductResponse(postBody) async {
    // print('add auction product response');
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-products/create");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);
    return commonResponseFromJson(response.body);
  }

  auctionProductDeleteReq({required id}) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/auction-product-bids/destroy/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return deleteProductFromJson(response.body);
  }

  Future<ProductEditResponse> productEdit({required id, lang = "en"}) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/products/edit/$id?lang=$lang");

    //print("product url "+url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    //print("product res  "+response.body.toString());
    return productEditResponseFromJson(response.body);
  }

  Future<WholesaleProductDetailsResponse> wholesaleProductEdit(
      {required id, lang = "en"}) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/wholesale-product/edit/$id?lang=$lang");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    // print("product res  " + response.body.toString());
    return wholesaleProductDetailsResponseFromJson(response.body);
  }

  Future<CommonResponse> addProductResponse(postBody) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/add");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${auth_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    //print(postBody);
    //print(access_token.$);

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    //print("product res  "+response.body.toString());

    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> updateProductResponse(
      postBody, productId, lang) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/products/update/$productId?lang=$lang");
    //print(url.toString());

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    //print(productId);
    //print(postBody);
    //print(access_token.$);

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    //print("product res  "+response.body.toString());

    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> updateWholesaleProductResponse(
      postBody, productId, lang) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/wholesale-product/update/$productId?lang=$lang");
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);
    // print(response.body);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> addWholeSaleProductResponse(postBody) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/wholesale-product/create");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    // print(postBody);
    //
    // print(url.toString());

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);
    // print(response.body);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> updateWholeSaleProductResponse(
      postBody, productId, lang) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/products/update/$productId?lang=$lang");
    //print(url.toString());

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    //print(productId);
    //print(postBody);
    //print(access_token.$);

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    //print("product res  "+response.body.toString());

    return commonResponseFromJson(response.body);
  }

  productDuplicateReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/duplicate/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    //print("product res  "+response.body.toString());
    return productDuplicateResponseFromJson(response.body);
  }

  productDeleteReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/delete/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    //print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  wholesaleProductDeleteReq({required id}) async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/wholesale-product/destroy/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    // print("product res  " + response.body.toString());
    return deleteProductFromJson(response.body);
  }

  productStatusChangeReq({required id, status}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-status");

    var post_body = jsonEncode({"id": id, "status": status});
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: post_body);

    //print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  productFeaturedChangeReq({required id, required featured}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-featured");

    var post_body = jsonEncode({"id": id, "featured_status": featured});
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response =
    await ApiRequest.post(url: url, headers: reqHeader, body: post_body);

    //print("product res  "+response.body.toString());
    return deleteProductFromJson(response.body);
  }

  remainingUploadProducts() async {
    String url =
    ("${AppConfig.BASE_URL_WITH_PREFIX}/products/remaining-uploads");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());
    return remainingProductFromJson(response.body);
  }

  Future<ProductReviewResponse> getProductReviewsReq() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/reviews");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());
    return productReviewResponseFromJson(response.body);
  }

  Future<CategoryResponse> getCategoryRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/categories");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return categoryResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrandRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/brands");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getTaxRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/taxes");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return brandResponseFromJson(response.body);
  }

  Future<AttributeResponse> getAttributeRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/attributes");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return attributeResponseFromJson(response.body);
  }

  Future<ColorResponse> getColorsRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/colors");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    //print("product res  "+response.body.toString());

    return colorResponseFromJson(response.body);
  }*/
}
