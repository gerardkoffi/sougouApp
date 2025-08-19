
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:sougou_app/ui/screens/settings_screen/forfait_screen.dart';
import 'package:sougou_app/ui/screens/products/updateProduct.dart';
import 'package:toast/toast.dart';

import '../../../data/model/magasin_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/magasin_repositories.dart';
import '../../../data/repositories/product_repositories.dart';
import '../../../helpers/shimmerHelpers.dart';
import '../../../my_theme.dart';
import '../../../utils/decoration.dart';
import '../../custom/app_style.dart';
import '../../custom/buttoms.dart';
import '../../custom/commun_style.dart';
import '../../custom/devices_info.dart';
import '../../custom/dropdown_model.dart';
import '../../custom/input_decoration.dart';
import '../../custom/loading.dart';
import '../../custom/my_appbar.dart';
import '../../custom/my_widget.dart';
import '../../custom/route_transaction.dart';
import '../../custom/submit_buttom.dart';
import '../../custom/toast_component.dart';
import 'newproduct_screen.dart';

class SearchProducts extends StatefulWidget {
  final bool fromBottomBar;

  const SearchProducts({Key? key, this.fromBottomBar = false}) : super(key: key);

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  bool _isProductInit = false;
  bool _showMoreProductLoadingContainer = false;

  List<Produit> _productList = [];

  int _remainingProduct = 100000;

  String? _currentMagasinName = "Riviera 2";
  late BuildContext loadingContext;
  late BuildContext switchContext;
  late BuildContext featuredSwitchContext;

  ScrollController _scrollController =
  new ScrollController(initialScrollOffset: 0);

  List<CommonDropDownItem> magasins = [];
  CommonDropDownItem? selectedMagasins;
  TextEditingController  prixAchatEditTextController = TextEditingController();
  TextEditingController  prixVenteEditTextController = TextEditingController();
  String? id,magasinId;
  int? prixAchat,prixVente;
  bool? statu;

  // double variables
  double mHeight = 0.0, mWidht = 0.0;
  String? _nomProduit;
  int _totalPages = 1;
  int _totalItem = 0;
  int _currentPage = 0;
  int _restProduct = 0;

  getProductSearch() async {
      if (_nomProduit == null || _nomProduit!.trim().isEmpty) {
        // Ne rien faire si le champ est vide
        return;
      }

      var productResponse = await ProductRepository().getSearchProducts(_nomProduit!);
      print("📦Ma Réponse brute: $productResponse");

      final produits = productResponse.corps?.produits ?? [];
      if (produits.isEmpty) {
        if (OneContext.hasContext) {
          ToastComponent.showDialog(
            "Pas de produits",
            gravity: Toast.center,
            bgColor: MyTheme.white,
            textStyle: const TextStyle(color: Colors.black),
          );
        }
        return;
      }

      _productList.clear(); // Optionnel : vide la liste précédente
      _productList.addAll(produits);
      _showMoreProductLoadingContainer = false;
      _isProductInit = true;
      setState(() {});
    }
  void _getMagasin() async {
    try {
      List<MagasinModel> magasinList = await MagasinRepository().getMagasins();

      // 🔁 Évite la duplication
      magasins.clear();

      magasins = magasinList
          .map((e) => CommonDropDownItem("${e.id}", e.nom))
          .toList();

      setState(() {});
    } catch (e) {
      print("Erreur chargement magasins : $e");
    }
  }

  deleteProduct(String id) async {
    loading();
    var response = await ProductRepository().productDeleteReq(id: id);
    Navigator.pop(loadingContext);

    if (response.statusCode == '200' && response.codeText == 'DELETE') {
      resetAll();
    }

    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }


  productStatusChange(int? index, bool value, setState, id) async {
    loading();
    var response = await ProductRepository().productStatusChangeReq(
      id: id,
      status: value, // true = activer, false = désactiver
    );
    Navigator.pop(loadingContext);

    if (response.statusCode == "200") {
      resetAll();
    }
    Navigator.pop(switchContext);

    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }

  setAssotimentValues() async {
    id;
    magasinId;
    statu;
    prixAchat;
    prixVente;

    if (selectedMagasins != null) magasinId = selectedMagasins?.key;
    prixAchat = int.tryParse(prixAchatEditTextController.text.trim()) ?? 0;
    prixVente = int.tryParse(prixVenteEditTextController.text.trim()) ?? 0;
    statu = true;

  }
  bool requiredFieldVerification() {
    if (prixAchatEditTextController.text.trim().isEmpty) {
      _showToast("prix d'achat requis");
      return false;
    } else if (selectedMagasins == null) {
      _showToast("Le magasin est requis");
      return false;
    } else if (prixVenteEditTextController.text.trim().isEmpty) {
      _showToast("prix de vente requis");
      return false;
    }else if (int.tryParse(prixVenteEditTextController.text.trim())! < int.tryParse(prixAchatEditTextController.text.trim())! ){
      _showToast("Prix Vente inferieur au Prix Achat");
      return false;
    }
    return true;
  }

  void _showToast(String message) {
    if (OneContext.hasContext) {
      ToastComponent.showDialog(
        message,
        gravity: Toast.center,
      );
    } else {
      debugPrint("Toast non affiché car OneContext n’est pas prêt : $message");
    }
  }


  Future<void> submitAssortiment(String button ,String productId) async {
    if (!requiredFieldVerification()) return;

    print("📍 setProductValues");
    await setAssotimentValues();

    print("📍 Validation des champs obligatoires");
    if (prixAchat == null || prixVente == null || magasinId == null) {
      Loading.hide();
      ToastComponent.showDialog(
        "Certains champs obligatoires sont manquants",
        gravity: Toast.center,
      );
      return;
    }

    final postValue = {

      "produitId": productId ?? '',
      "magasinId": magasinId ?? '',
      "statut": statu ?? '',
      "prixAchat": prixAchat ?? '',
      "prixVente": prixVente ?? '',
    };

    try {
      await Loading.show(context, timeout: Duration(seconds: 3));
      final postBody = jsonEncode(postValue);
      print("📤 Envoi postBody: $postBody");

      final response = await MagasinRepository().postAssortiment(postBody);

      print("✅ Réponse reçue: ${response.toString()}");
      Loading.hide();

      if (response.statusCode == '200' && response.corps != null) {
        ToastComponent.showDialog("Le produit enregistre", gravity: Toast.center);

        final productId = response.corps["id"]; // <- Assure-toi que ton backend retourne bien l'id
        if (productId != null) {
          print("🧪 corps: ${response.corps} (${response.corps.runtimeType})");
        }
        // Petite pause pour laisser le temps de voir le toast
        await Future.delayed(Duration(seconds: 1));

        // Revenir à la page précédente
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      } else {
        final errorMessages = response.message;
        if (errorMessages is String) {
          ToastComponent.showDialog(errorMessages, gravity: Toast.center);
        } else if (errorMessages is List) {
          ToastComponent.showDialog(errorMessages, gravity: Toast.center);
        } else {
          ToastComponent.showDialog("Une erreur est survenue", gravity: Toast.center);
        }
      }
    } catch (e, s) {
      print("❌ Exception: $e");
      print("📍 Stack: $s");
      Loading.hide();
      ToastComponent.showDialog("Erreur: ${e.toString()}", gravity: Toast.center);
    }
  }

  scrollControllerPosition() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _showMoreProductLoadingContainer = true;
        setState(() {
        });
        getProductSearch();
      }
    });
  }

  cleanAll() {
    _isProductInit = false;
    _showMoreProductLoadingContainer = false;
    _productList = [];
    _currentPage++;
    _currentMagasinName = "Riviera 2";
    setState(() {});
  }

  fetchAll() {
    getProductSearch();
    _restProduct = _remainingProduct - _totalItem;
    _getMagasin();
    setState(() {});
  }

  resetAll() {
    cleanAll();
    fetchAll();
  }


  _tabOption(int index, productId, listIndex) {
    switch (index) {
      case 0:
        showAssotimentDialog(productId);
        break;
      case 1:
        slideRightWidget(
            newPage: UpdateProduct(
                productId: productId,
                siModifie: true, siNouveau: false
            ),
            context: context)
            .then((value) {
          resetAll();
        });
        break;
      case 2:
        showPublishUnPublishDialog(listIndex, productId);
        break;
      case 3:
        showDeleteWarningDialog(productId);
        break;
      default:
        print("index par défaut: $index");
        break;

    }
  }


  @override
  void initState() {
    scrollControllerPosition();
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 0.0,
          centerTitle: false,
          elevation: 0.0,
          title: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                child: IconButton(
                  splashRadius: 15,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: Image.asset(
                    'assets/icon/back_arrow.png',
                    height: 20,
                    width: 20,
                    color: MyTheme.app_accent_color,
                    //color: MyTheme.dark_grey,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Rechercher un produit",
                style: MyTextStyle().appbarText(),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {resetAll();},
          child: SingleChildScrollView(
            //physics: AlwaysScrollableScrollPhysics(),
            //controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Visibility(
                    visible: true,
                    child: buildPackageSearchField(context)),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child:
                    Column(
                      children: [
                        _isProductInit
                            ? productsContainer()
                            : ShimmerHelper()
                            .buildListShimmer(item_count: 20, item_height: 80.0),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildPackageSearchField(BuildContext context) {
    return MyWidget().myContainer(
      marginY: 15,
      height: 40,
      width: DeviceInfo(context).getWidth(),
      borderRadius: 20,
      borderColor: MyTheme.accent_color,
      bgColor: MyTheme.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset(
              "assets/icon/search.png",
              height: 20,
              width: 20,
              color: MyTheme.app_accent_color,
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                  onChanged: (value) async {
                    _nomProduit = value;
                    if (value.trim().isEmpty) {
                      setState(() {
                        _productList.clear();
                        _isProductInit = false;
                      });
                      return;
                    }

                    final response = await ProductRepository().getSearchProducts(value);

                    if (response.corps!.produits.isEmpty) {
                      if (OneContext.hasContext) {
                        ToastComponent.showDialog(
                          "Ce produit n'existe pas!",
                          gravity: Toast.center,
                          bgColor: MyTheme.white,
                          textStyle: const TextStyle(color: Colors.black),
                        );
                      }

                      setState(() {
                        _productList.clear(); // 🧹 Vide la liste précédente
                        _isProductInit = false;
                      });
                    } else {
                      setState(() {
                        _productList = response.corps!.produits;
                        _isProductInit = true;
                      });
                    }
                  },
                onSubmitted: (value) {
                  _nomProduit = value;
                  getProductSearch();
                },
                style: TextStyle(
                  fontSize: 13,
                  color: MyTheme.app_accent_color,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Rechercher un produit ...",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: MyTheme.grey_153,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Container buildTop2BoxContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: MyTheme.app_accent_border),
                color: MyTheme.app_accent_color,
              ),
              height: mWidht > 750 ? 95 : 75,
              width: mWidht / 2 - 23,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Limite Produit",
                      style: MyTextStyle().dashboardBoxText(context),
                    ),
                    Text(
                      "$_restProduct",
                      style: TextStyle(
                          fontSize: (DeviceInfo(context).getWidth()/100)*5.5,
                          color: MyTheme.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: AppStyles.itemMargin,
          ),
          Container(
              child: SubmitBtn.show(
                onTap: () async {
                  final result = await MyTransaction(context: context)
                      .push(NewProduct(siModifie: false, siNouveau: true));

                  if (result == true) {
                    resetAll(); // recharge les produits à partir de la page 0
                  }
                },
                borderColor: MyTheme.app_accent_color,
                backgroundColor: MyTheme.app_accent_color_extra_light,
                height: mWidht > 750 ? 95 : 75,
                width: mWidht / 2 - 23,
                radius: 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: mWidht > 750 ? 95 : 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Nouveau",
                        style: MyTextStyle()
                            .dashboardBoxText(context)
                            .copyWith(color: MyTheme.app_accent_color),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon/add.png',
                            color: MyTheme.app_accent_color,
                            height: 24,
                            width: 42,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget productsContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _productList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(index);
                if (index == _productList.length) {
                  return moreProductLoading();
                }
                return
                  productItem(
                    index: index,
                    productId: _productList[index].id,
                    photoUrl:_productList[index].fullPhotoUrl,
                    code: _productList[index].code,
                    nomProduit: _productList[index].nom,
                    description: _productList[index].description,
                    secteur: _productList[index].secteur?.libelle ?? 'N/A',
                    famille: _productList[index].famille?.libelle ?? 'N/A',
                    sousFamille: _productList[index].sousFamille?.libelle ?? 'N/A',
                    rayon: _productList[index].rayon?.libelle ?? 'N/A',
                    marque: _productList[index].marque?.nom ?? 'N/A',
                    origine: _productList[index].origine?.nom ?? 'N/A',
                    colisage: _productList[index].colisage.toString(),
                    poidsProduit: _productList[index].poids.toString(),
                    status: _productList[index].statut,
                  );
              }),
        ],
      ),
    );
  }

  Container productItem(
      {int? index,
        required String productId,
        required String photoUrl,
        required String code,
        required String nomProduit,
        required String description,
        required String secteur,
        required String famille,
        required String sousFamille,
        required String rayon,
        required String marque,
        required String origine,
        required String colisage,
        required String poidsProduit,
        required bool status,
      }) {
    return MyWidget.customCardView(
        elevation: 5,
        backgroundColor: MyTheme.white,
        height: 90,
        width: mWidht,
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        padding: EdgeInsets.only(top: 5,bottom: 5),
        borderColor: MyTheme.light_grey,
        borderRadius: 6,
        child: InkWell(
          onTap: () {
            print(photoUrl);
            //MyTransaction(context: context).push(NewProduct(siModifie:false, siNouveau:true));
          },
          child: Row(
            children: [
              SizedBox(
                width: 2,
              ),
              MyWidget.imageWithPlaceholder(
                width: 80.0,
                height: 90.0,
                fit: BoxFit.cover,
                url: photoUrl,
                radius: BorderRadius.circular(5),
              ),
              //Image.asset(photoUrl,width: 80,height: 80,fit: BoxFit.contain,),
              SizedBox(
                width: 11,
              ),
              Container(
                width: mWidht - 129,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: mWidht - 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Code produit : $code",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 3,
                                ),Text(
                                  "Nom: $nomProduit",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Secteur : $secteur",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: showOptions(
                                listIndex: index, productId: productId),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                    "Colisage : $colisage",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MyTheme.font_grey,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          status == true?
                          Row(
                            children: [
                              Text(
                                  "Activé",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w600)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8),
                                  child:  Image.asset(
                                    "assets/icon/verify.png",
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  )
                              ),
                            ],
                          ):
                          Row(
                            children: [
                              Text(
                                  "Desactivé",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w600)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8),
                                  child:  Image.asset(
                                    "assets/icon/unverify.png",
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )) as Container;
  }


  Widget _buildDropDownField(String title, dynamic onchange,
      CommonDropDownItem? selectedValue, List<CommonDropDownItem> itemList,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title, _buildDropDown(onchange, selectedValue, itemList, width: width),
        isMandatory: isMandatory);
  }
  buildCommonSingleField(title, Widget child, {isMandatory = false}) {
    return Column(
      children: [
        Row(
          children: [
            buildFieldTitle(title),
            if (isMandatory)
              Text(
                " *",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.red),
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        child,
      ],
    );
  }

  setChange() {
    setState(() {});
  }

  Text buildFieldTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }
  Widget _buildDropDown(dynamic onchange, CommonDropDownItem? selectedValue,
      List<CommonDropDownItem> itemList,
      {double? width}) {
    return DropdownButton2<CommonDropDownItem>(
      isExpanded: true,
      value: selectedValue,
      onChanged: (CommonDropDownItem? value) {
        onchange(value);
      },
      underline: SizedBox(), // ✅ Ceci supprime complètement le trait
      items: itemList.map((CommonDropDownItem item) {
        return DropdownMenuItem<CommonDropDownItem>(
          value: item,
          child: Text(item.value!),
        );
      }).toList(),
      buttonStyleData: ButtonStyleData(
        height: 46,
        width: width ?? mWidht,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: MDecoration.decoration1(),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: Colors.grey[100], // ✅ Couleur de fond du menu déroulant
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
      ),
      style: TextStyle(color: MyTheme.app_accent_color),
    );
  }
  Widget itemSpacer({double height = 24}) {
    return SizedBox(
      height: height,
    );
  }
  Widget buildIntTextField(
      String title,
      String hint,
      TextEditingController controller, {
        bool isMandatory = false,
      }) {
    return Container(
      child: buildCommonSingleField(
        title,
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          elevation: 5,
          width: DeviceInfo(context).getWidth(),
          height: 46,
          borderRadius: 10,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecorations.buildInputDecoration_1(
              hint_text: hint,
              borderColor: MyTheme.noColor,
              hintTextColor: MyTheme.grey_153,
            ),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MyTheme.app_accent_color
            ),
          ),
        ),
        isMandatory: isMandatory,
      ),
    );
  }

  void showAssotimentDialog(id) {

    prixAchatEditTextController.clear();
    prixVenteEditTextController.clear();
    selectedMagasins = null;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "Ajoutez l'assortiment",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: MyTheme.accent_color,
                  ),
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Attribuer le produit à un magasin",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    itemSpacer(),
                    _buildDropDownField(
                      "Magasin",
                          (value) {
                        setState(() {
                          selectedMagasins = value;
                        });
                      },
                      selectedMagasins,
                      magasins,
                    ),
                    itemSpacer(),
                    buildIntTextField(
                      "Prix d'achat",
                      "Entrez le prix d'achat",
                      prixAchatEditTextController,
                      isMandatory: true,
                    ),
                    itemSpacer(),
                    buildIntTextField(
                      "Prix de vente",
                      "Entrez le prix de vente",
                      prixVenteEditTextController,
                      isMandatory: true,
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Buttons(
                      color: MyTheme.red,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Annuler",
                        style: TextStyle(color: MyTheme.white, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Buttons(
                      color: MyTheme.app_accent_color,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () {
                        submitAssortiment("Valider", id);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Valider",
                        style: TextStyle(color: MyTheme.white, fontSize: 14,fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDeleteWarningDialog(id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Attention",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: MyTheme.red,
          ),
        ),
        content: Text(
          "Voulez-vous supprimer ce produit ?",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Buttons(
                color: MyTheme.app_accent_color,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Non",
                  style: TextStyle(color: MyTheme.white, fontSize: 12),
                ),
              ),
              Buttons(
                color: MyTheme.app_accent_color,
                onPressed: () {
                  Navigator.pop(context);
                  deleteProduct(id);
                },
                child: Text(
                  "Oui",
                  style: TextStyle(color: MyTheme.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget showOptions({listIndex, productId}) {
    return Container(
      width: 35,
      child: PopupMenuButton<MenuOptions>(
        offset: Offset(-12, 0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: 35,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/icon/more.png",
                width: 3,
                height: 15,
                fit: BoxFit.contain,
                color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, productId, listIndex);
          // setState(() {
          //   //_menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Assortiment,
            child: Text("Assortiment"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Edit,
            child: Text("Modifier"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Published,
            child: Text("Changer le status"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void showPublishUnPublishDialog(int? index, id) {
    showDialog(
        context: context,
        builder: (context) {
          switchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 75,
              width: DeviceInfo(context).getWidth(),
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index!].statut
                          ? "Desactiver ?"
                          : "Activer ?",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].statut,
                      activeColor: MyTheme.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productStatusChange(index, value, setState, id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }


  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Veuillez patienter"),
                ],
              ));
        });
  }

  Widget moreProductLoading() {
    return _showMoreProductLoadingContainer
        ? Container(
      alignment: Alignment.center,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Row(
          children: [
            SizedBox(
              width: 2,
              height: 2,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    )
        : SizedBox(
      height: 5,
      width: 5,
    );
  }
}

enum MenuOptions { Assortiment, Edit, Published, Delete}
