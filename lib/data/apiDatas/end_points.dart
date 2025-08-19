
class EndPoints{
  static const String dataUrl = "http://207.180.210.22:9000/api/v1/";

  //GET
  static String getProducts = '${dataUrl}produits';
  static String getProductsById = '${dataUrl}produits';
  static String deleteProducts = '${dataUrl}produits';
  static String getMagasin = '${dataUrl}magasins';
  static String createMagasin = '${dataUrl}magasins';
  static String fecthbyIdMagasin = '${dataUrl}magasins';
  static String fecthbyCodeMagasin = '${dataUrl}magasins/code';
  static String getMarques = '${dataUrl}marques';
  static String getFamilles = '${dataUrl}familles';
  static String getOrigines = '${dataUrl}origines';
  static String getRayons = '${dataUrl}rayons';
  static String getSecteurs = '${dataUrl}secteurs';
  static String getSousFamille = '${dataUrl}sous-familles';

  //POST
  static String postProduct = '${dataUrl}produits';
  static String postAssortiment = '${dataUrl}assortiments';
  static String putProductStatus = '${dataUrl}produits';

}