
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:sougou_app/ui/screens/settings_screen/forfait_screen.dart';
import 'package:toast/toast.dart';

import '../../data/model/product_model.dart';
import '../../data/repositories/magasin_repositories.dart';
import '../../data/repositories/product_repositories.dart';
import '../../helpers/shimmerHelpers.dart';
import '../../my_theme.dart';
import '../custom/app_style.dart';
import '../custom/buttoms.dart';
import '../custom/commun_style.dart';
import '../custom/devices_info.dart';
import '../custom/my_appbar.dart';
import '../custom/my_widget.dart';
import '../custom/route_transaction.dart';
import '../custom/submit_buttom.dart';
import '../custom/toast_component.dart';
import 'newproduct_screen.dart';

class Products extends StatefulWidget {
  final bool fromBottomBar;

  const Products({Key? key, this.fromBottomBar = false}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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

  // double variables
  double mHeight = 0.0, mWidht = 0.0;
  int _page = 0;
  int _totalPages = 1;
  int _totalItem = 0;
  int _currentPage = 0;
  int _restProduct = 0;
  getProductList() async {

    var productResponse = await ProductRepository().getProducts(_page);
    print("📦 Réponse brute: $productResponse");
    _totalPages = productResponse.corps?.totalPages ?? 1;
    _totalItem = productResponse.corps?.totalItems ?? 1;
    _currentPage = productResponse.corps?.currentPage ?? 1;
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
    _productList.addAll(productResponse.corps!.produits);
    _page; // ⬅️ n'incrémente que si des produits sont récupérés
    _currentPage++;
    _showMoreProductLoadingContainer = false;
    _isProductInit = true;
    setState(() {});
  }


  Future<bool> _getAccountInfo() async {
    var response = await MagasinRepository().getMagasins();

    if (response.corps == null) {
      // Gérer le cas où il n'y a pas de magasin
      //_currentMagasinName = "Nom non disponible";
      setState(() {});
      return false;
    }

    _currentMagasinName = response.corps!.nom ?? "Nom non disponible";
    setState(() {});
    return true;
  }


/*  getProductRemainingUpload() async {
    var productResponse = await ProductRepository().remainingUploadProducts();
    _remainingProduct = productResponse.ramainingProduct.toString();

    setState(() {});
  }

  duplicateProduct(int? id) async {
    loading();
    var response = await ProductRepository().productDuplicateReq(id: id);
    Navigator.pop(loadingContext);
    if (response.result) {
      resetAll();
    }
    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: TextStyle(color: MyTheme.black),
    );
  }*/

  deleteProduct(int? id) async {
    loading();
    var response = await ProductRepository().productDeleteReq(id: id);
    Navigator.pop(loadingContext);
    if (response.result) {
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
    var response = await ProductRepository()
        .productStatusChangeReq(id: id, status: value ? 1 : 0);
    Navigator.pop(loadingContext);
    if (response.result) {
      // _productStatus[index] = value;
      //_productList[index!].status = value;
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


  scrollControllerPosition() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _showMoreProductLoadingContainer = true;
        setState(() {
          _page++;
        });
        getProductList();
      }
    });
  }

  cleanAll() {
    _isProductInit = false;
    _showMoreProductLoadingContainer = false;
    _productList = [];
    _page = 0;
    _currentPage++;
    _currentMagasinName = "Riviera 2";
    setState(() {});
  }
  fowardAll() {
      _isProductInit = false;
      _showMoreProductLoadingContainer = false;
      _productList = [];
      _page ++;
      setState(() {});
  }
  backAll() {
      _isProductInit = false;
      _showMoreProductLoadingContainer = false;
      _productList = [];
      _page --;
      setState(() {});
  }

  fetchAll() {
    getProductList();
    _getAccountInfo();
    _restProduct = _remainingProduct - _totalItem;
    //getProductRemainingUpload();
    setState(() {});
  }

  resetAll() {
    cleanAll();
    fetchAll();
  }
  backresetAll() {
    if (_page > 0) {
      print("➡️ Page arriere : $_page");
    backAll();
    fetchAll();
  }}
  fowardresetAll() {
    if (_page < _totalPages) {
      print("➡️ Page suivante : $_page");
      fowardAll();
      fetchAll();
    }
  }

  _tabOption(int index, productId, listIndex) {
    switch (index) {
      /*case 0:
        slideRightWidget(
            newPage: UpdateProduct(
              productId: productId,
            ),
            context: context)
            .then((value) {
          resetAll();
        });*/
        //break;
      case 1:
        showPublishUnPublishDialog(listIndex, productId);
        break;
      case 2:
        showDeleteWarningDialog(productId);
        //deleteProduct(productId);
        break;
      case 3:
        print(productId);
        //duplicateProduct(productId);
        break;
      default:
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
        appBar: !widget.fromBottomBar
            ? MyAppBar(
            context: context,
            title: "Produits")
            .show()
            : null,
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
                buildTop2BoxContainer(context),
                Visibility(
                    visible: true,
                    child: buildPackageUpgradeContainer(context)),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child:
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tous les produits",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyTheme.app_accent_color),
                                ),
                                Row(
                                  children: [
                                    _page == _totalPages-2?
                                    IconButton(
                                      onPressed: () async{
                                        //backresetAll();
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: MyTheme.grey_153,
                                        size: 24.0,
                                      ),
                                    ):IconButton(
                                      onPressed: () async{
                                        backresetAll();
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: MyTheme.app_accent_color,
                                        size: 24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text("$_currentPage"),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    _page+1 == _totalPages?
                                    IconButton(
                                      onPressed: () async{
                                        //fowardresetAll();
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: MyTheme.grey_153,
                                        size: 24.0,
                                      ),
                                    ):IconButton(
                                      onPressed: () async{
                                        fowardresetAll();
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: MyTheme.app_accent_color,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
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
  Widget buildPackageUpgradeContainer(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppStyles.itemMargin,
        ),
        MyWidget().myContainer(
            marginY: 15,
            height: 40,
            width: DeviceInfo(context).getWidth(),
            borderRadius: 6,
            borderColor: MyTheme.accent_color,
            bgColor: MyTheme.white,
            child: InkWell(
              onTap: () {
                MyTransaction(context: context).push(Packages());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icon/shop_setting.png",
                        height: 20, width: 20, color: MyTheme.app_accent_color,),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Magasin:",
                        style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _currentMagasinName!,
                        style: TextStyle(
                            fontSize: 13,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text("Changer",
                        style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset("assets/icon/next_arrow.png",
                          color: MyTheme.app_accent_color,
                          height: 8.7,
                          width: 7),
                    ],
                  ),
                ],
              ),
            )),
      ],
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
        //String? imageUrl,
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
            //MyTransaction(context: context).push(NewProduct(siModifie:false, siNouveau:true));
          },
          child: Row(
            children: [
              MyWidget.imageWithPlaceholder(
                width: 84.0,
                height: 90.0,
                fit: BoxFit.cover,
                url: null,
                radius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              // Image.asset(ImageUrl,width: 80,height: 80,fit: BoxFit.contain,),
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
                                  "En ligne",
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
                                  "Hors ligne",
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

  showDeleteWarningDialog(id) {
    showDialog(
        context: context,
        builder: (context) => Container(
          width: DeviceInfo(context).getWidth() * 1.5,
          child: AlertDialog(
            title: Text(
              "Attention",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: MyTheme.red),
            ),
            content: Text(
              "Voullez-vous supprimer ce produit?",
              style: const TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14),
            ),
            actions: [
              Buttons(
                  color: MyTheme.app_accent_color,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                   "Non",
                    style: TextStyle(color: MyTheme.white, fontSize: 12),
                  )),
              Buttons(
                  color: MyTheme.app_accent_color,
                  onPressed: () {
                    Navigator.pop(context);
                    deleteProduct(id);
                  },
                  child: Text(
                      "Oui",
                      style:
                      TextStyle(color: MyTheme.white, fontSize: 12))),
            ],
          ),
        ));
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
            value: MenuOptions.Edit,
            child: Text("Modifier"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Published,
            child: Text("Mettre en ligne"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text("Supprimer"),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Duplicate,
            child: Text("Dupliquer"),
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
                          ? "En ligne"
                          : "Non en ligne",
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

enum MenuOptions { Edit, Published, Featured, Delete, Duplicate }
