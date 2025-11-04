import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';
import '../../../data/model/categorie_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/product_repositories.dart';
import '../../../helpers/shimmerHelpers.dart';
import '../../../my_theme.dart';
import '../../../utils/decoration.dart';
import '../../../utils/pos_add_products.dart';
import '../../../utils/pos_btn.dart';
import '../../../utils/pos_price.dart';
import '../../custom/buttoms.dart';
import '../../custom/devices_info.dart';
import '../../custom/input_decoration.dart';
import '../../custom/my_appbar.dart';
import '../../custom/my_widget.dart';
import '../../custom/route_transaction.dart';
import '../../custom/toast_component.dart';
import 'invoice_screen.dart';


class PosManager extends StatefulWidget {
  const PosManager({Key? key}) : super(key: key);

  @override
  State<PosManager> createState() => _PosManagerState();
}

class Product {
  final String name;

  Product(this.name);
}

class _PosManagerState extends State<PosManager> {
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  //shipping address controllers
  final TextEditingController _shippingAddressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  final TextEditingController _paymentMethodController =
  TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  ScrollController _scrollController =
  new ScrollController(initialScrollOffset: 0);

  bool isSetCustomerInfo = false;
  List<Product> products = [];
  List<Produit> _productList = [];
  bool showAddAddressBtn = true;
  int? _selected_shipping_address;
  bool _isProductInit = false;

// category
  Category? selectedCategory;
  List<Category> categories = [];
  int _page = 0;
  int _totalPages = 1;
  int _totalItem = 0;
  int _currentPage = 0;
  int _restProduct = 0;
  String? sessionUser;
  double mHeight = 0.0, mWidht = 0.0;
  int? selectedProduct;
  String? tempUserdata;

  bool _isPosProductInit = false;
  bool _isUserCartData = false;
  bool _showMoreProductLoadingContainer = false;
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  Map walkCustomerPostValue = {};
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

  selectProduct() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selectionnez",
                style: const TextStyle(
                    fontSize: 16, color: MyTheme.app_accent_color),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  'assets/icon/cross.png',
                  width: 16,
                  height: 16,
                ),
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              if (!_isPosProductInit) {
                //getPosProduct(setState);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildSearchBox(setState),
                    //itemSpacer(height: 10.0),
                    //buildSelectCategoryBrand(setState),
                    itemSpacer(height: 20.0),
                    SizedBox(
                      height: 533,
                      width: 400,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: 30,
                        itemBuilder: (BuildContext context, int index) {
                          return _isProductInit
                              ? GestureDetector(
                            onTap: () {
                              //onTapSelectProduct(index, setState);
                            },
                            child: productsContainer(),
                          )
                              : ShimmerHelper().buildBoxShimmer();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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

  filterProduct(setState) {

  }

/*  onSubmitPOS(paymentType) async {
    String? offline_trx_id,
        offline_payment_method,
        offline_payment_amount,
        offline_payment_proof;

    if (paymentType == "offline_payment") {
      offline_payment_amount = _amountController.text.trim().toString();
      offline_payment_method = _paymentMethodController.text.trim();
      offline_trx_id = _transactionController.text.trim();
      //offline_payment_proof = (paymentProof?.id ?? 0).toString();
    }

    var shippingInfo = {
      "name": tmpShippingAddress?.name,
      "email": tmpShippingAddress?.email,
      "address": tmpShippingAddress?.address,
      "country": tmpShippingAddress?.countryName,
      "state": tmpShippingAddress?.stateName,
      "city": tmpShippingAddress?.cityName,
      "postal_code": tmpShippingAddress?.postalCode,
      "phone": tmpShippingAddress?.phone,
    };
    OneContextLoading.show();

    var response = await PosRepository().createPOS(
        discount: _discountController.text,
        userId: selectedCustomer?.key,
        tmpUserId: tempUserdata,
        paymentType: paymentType,
        shippingCost: posUserCartData?.shippingCost,
        offlinePaymentAmount: offline_payment_amount,
        offlinePaymentMethod: offline_payment_method,
        offlinePaymentProof: offline_payment_proof,
        offlineTrxId: offline_trx_id,
        shippingInfo: shippingInfo);

    Navigator.pop(OneContext().context!);
    OneContextLoading.hide();

    ToastComponent.showDialog(response.message);
    reFresh();
  }*/

  fetchAll() {

  }
  String? selectedCustomer;
  List<String> customers = ['Client', 'Client 1', 'Client 2'];
  reset() {
    products.clear();
    _selected_shipping_address = null;
    showAddAddressBtn = true;

    _nameController.clear();
    _emailController.clear();
    _shippingAddressController.clear();
    _postalCodeController.clear();
    _phoneController.clear();
    selectedProduct = null;
    _countryController.clear();
    _stateController.clear();
    _cityController.clear();
    _shippingController.clear();
    _discountController.clear();
  }

  reFresh() {
    reset();
    fetchAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAll();
    super.initState();
  }

  @override
  void dispose() {
    _shippingController.dispose();
    _discountController.dispose();
    _searchController.dispose();
    _shippingAddressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _paymentMethodController.dispose();
    _amountController.dispose();
    _transactionController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:TextDirection.ltr,
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: "Point de Vente",
        ).show(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return
        //? ShimmerHelper().buildPosShimmer()
         Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget.customCardView(
                borderRadius: 6,
                elevation: 3,
                borderColor: MyTheme.app_accent_color,
                backgroundColor: MyTheme.app_accent_color_extra_light,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 0),
                height: 6,
                width: DeviceInfo(context).getWidth() * .7,
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  value: selectedCustomer ?? customers[0],
                  onChanged: (String? value) {
                    setState(() {
                      selectedCustomer = value;
                    });
                  },
                  items: customers.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
          ),
              GestureDetector(
                onTap: () => {
                  setClient(),
                },
                child: MyWidget.customCardView(
                  borderRadius: 6,
                  elevation: 3,
                  borderWidth: 2,
                  borderColor: MyTheme.accent_color,
                  backgroundColor: MyTheme.app_accent_color_extra_light,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 11),
                  height: 36,
                  width: DeviceInfo(context).getWidth() * .14,
                  child: Icon(Icons.add)
                ),
              ),
            ],
          ),
        ),
        itemSpacer(),
        // product list view and add button


          PosAddProductWidget(
            height: 245,
            onTap: selectProduct,
          ),


          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4),
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) =>
                    itemSpacer(height: 10.0),
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                },
              ),
            ),
          ),
        const Spacer(),

        itemSpacer(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 127.0,
            child: Column(
              children: [
                PosTextPrice(
                    title: "Sous total",
                    price: "0 FCFA"),
                itemSpacer(height: 5.0),
                PosTextPrice(
                    title: "Remise",
                    price: "0 FCFA"),
                itemSpacer(),
                itemDivider(),
                itemSpacer(height: 8.0),
                PosTextPrice(
                    title: "Total",
                    price: "0 FCFA"),
              ],
            ),
          ),
        ),
        itemSpacer(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(
              right: 20.0, left: 20.0, bottom: 17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  itemSpacer(width: 10.0),
                  PosBtn(
                      text: "Remise",
                      icon: Icons.keyboard_arrow_up,
                      color: MyTheme.app_accent_color_extra_light,
                      onTap: discount)
                ],
              ),
              PosBtn(
                  text: "Valider la vente",
                  color: MyTheme.app_accent_color,
                  textColor: MyTheme.white,
                  fontWeight: FontWeight.bold,
                  onTap: orderSummery)
            ],
          ),
        )
      ],
    );
  }

  itemSpacer({height = 10.0, width = 0.0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  itemDivider() {
    return const Divider(
      height: 3,
      color: MyTheme.grey_153,
    );
  }



  Widget buildSelectCategoryBrand(setState) {
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Secteur",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.font_grey),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Famille",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.font_grey),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 46,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: MDecoration.decoration1(),
                      child: DropdownButton<Category>(
                        menuMaxHeight: 300,
                        isDense: true,
                        underline: Container(),
                        isExpanded: true,
                        onChanged: (Category? value) {
                          selectedCategory = value;
                          setState(() {});
                          filterProduct(setState);
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                        value: selectedCategory,
                        items: categories
                            .map(
                              (value) => DropdownMenuItem<Category>(
                            value: value,
                            child: Text(
                              "Niveau",
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    )),
                itemSpacer(width: 8.0),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 46,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: MDecoration.decoration1(),
                    child: Container()
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBox(setState) {
    return buildCommonTypeAheadDecoration(
      child: TextField(
        controller: _searchController,
        decoration: buildAddressInputDecoration(
          context,
          "Trouvez un produit",
        ),
        onEditingComplete: () async {
          filterProduct(setState);
          // await PosRepository().getPosProducts(keyword: _searchController.text);
        },
        onChanged: (text) {
          if (text != null && text.trim().isNotEmpty) {
            filterProduct(setState);
          }
        },
      ),
    );
  }

  buildOrderSummery() {
    //var cartData = posUserCartData?.cartData?.data;
    //_amountController.text = posUserCartData!.total!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // if not products in the list
          if (false)
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text(
                'No Product found!',
                style: TextStyle(
                  fontSize: 14,
                  color: MyTheme.font_grey,
                ),
              ),
            ),
          // if  products in the list

          if (true)
            SizedBox(
              height: 200,
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      itemSpacer(height: 2.0),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return MyWidget.customCardView(
                      backgroundColor: MyTheme.white,
                      height: 70,
                      borderColor: MyTheme.light_grey,
                      borderRadius: 6,
                      child: Row(
                        children: [
                          MyWidget.imageWithPlaceholder(
                            width: 84.0,
                            height: 70.0,
                            fit: BoxFit.cover,
                            url: "imageUrl",
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Produit test",
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.app_accent_color,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "10,000 FCFA",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: MyTheme.app_accent_color,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),

          itemSpacer(height: 10.0),
          SizedBox(
            width: double.infinity,
            height: 110.0,
            child: Column(
              children: [
                PosTextPrice(
                    title: "Sous total",
                    price: "0 FCFA"),
                itemSpacer(height: 5.0),
                PosTextPrice(
                    title: "Remise",
                    price: "0 FCFA"),
                itemSpacer(),
                itemDivider(),
                itemSpacer(height: 5.0),
                PosTextPrice(
                    title: "Total",
                    price: "0 FCFA"),
              ],
            ),
          ),
          itemSpacer(height: 5.0),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

                GestureDetector(
                  onTap: offlinePayment,
                  child: PosBtn(
                    text: "Paiement En ligne",
                    color: MyTheme.accent_color,
                    textColor: MyTheme.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              itemSpacer(height: 10.0),

              PosBtn(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop(); // ferme le dialog
                  Future.delayed(const Duration(milliseconds: 200), () {
                    MyTransaction(context: context).push(const ReceiptScreen());
                  });
                },
                text: "Paiement Cash",
                color: MyTheme.app_accent_color,
                textColor: MyTheme.white,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ],
      ),
    );
  }

  shipping() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return Container();
          /*PosShipDiscountDialog(
          controller: _shippingController,
          title: getLocal(context).shipping,
          callback: getCartData,*/

      },
    );
  }

  discount() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return remisePayment();
      },
    );
  }

  orderSummery() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10.0),
          contentPadding: const EdgeInsets.all(20.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Resume de la commande",
                style: const TextStyle(
                    fontSize: 16, color: MyTheme.app_accent_color),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  'assets/icon/cross.png',
                  width: 16,
                  height: 16,
                ),
              )
            ],
          ),
          content: SizedBox(
            width: DeviceInfo(context).getWidth(),
            child: buildOrderSummery(),
          ),
        );
      },
    );
  }


  offlinePayment() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Info sur le paiement",
                  style: const TextStyle(
                      fontSize: 16, color: MyTheme.app_accent_color),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    'assets/icon/cross.png',
                    width: 16,
                    height: 16,
                  ),
                )
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildCommonSingleField(
                        "Numero de telephone",
                        buildCommonTypeAheadDecoration(
                          child: TextField(
                            controller: _paymentMethodController,
                            decoration: buildAddressInputDecoration(
                                context, "Numero"),
                          ),
                        ),
                        isMandatory: false,
                      ),
                      itemSpacer(),
                      buildCommonSingleField(
                        "Montant de la commande",
                        buildCommonTypeAheadDecoration(
                          child: TextField(
                            readOnly: true,
                            controller: _amountController,
                            decoration: buildAddressInputDecoration(
                                context, "Montant"),
                          ),
                        ),
                        isMandatory: false,
                      ),
                      itemSpacer(),
                      buildCommonSingleField(
                        "Mode de paiement",
                        buildCommonTypeAheadDecoration(
                          child: TextField(
                            controller: _transactionController,
                            decoration: buildAddressInputDecoration(
                                context, "Mode de paiement"),
                          ),
                        ),
                        isMandatory: false,
                      ),
                      itemSpacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PosBtn(
                                text: "Fermer",
                                color: MyTheme.red,
                                textColor: MyTheme.white,
                                fontWeight: FontWeight.bold,
                                onTap: () => Navigator.pop(context),
                              ),
                              itemSpacer(width: 10.0),
                              PosBtn(
                                onTap: () {
                                  ///Offline Make
                                  /*if (paymentProof != null &&
                                        _paymentMethodController
                                            .text.isNotEmpty &&
                                        _amountController.text.isNotEmpty &&
                                        _transactionController
                                            .text.isNotEmpty) {
                                      onSubmitPOS("offline_payment");
                                    }*/
                                },
                                text: "Confirmer",
                                color: MyTheme.app_accent_color,
                                textColor: MyTheme.white,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  remisePayment() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remise sur le paiement",
                  style: const TextStyle(
                      fontSize: 16, color: MyTheme.app_accent_color),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    'assets/icon/cross.png',
                    width: 16,
                    height: 16,
                  ),
                )
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildCommonSingleField(
                        "Montant de la remise",
                        buildCommonTypeAheadDecoration(
                          child: TextField(
                            controller: _paymentMethodController,
                            decoration: buildAddressInputDecoration(
                                context, "Montant"),
                          ),
                        ),
                        isMandatory: false,
                      ),
                      itemSpacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PosBtn(
                                text: "Fermer",
                                color: MyTheme.red,
                                textColor: MyTheme.white,
                                fontWeight: FontWeight.bold,
                                onTap: () => Navigator.pop(context),
                              ),
                              itemSpacer(width: 10.0),
                              PosBtn(
                                onTap: () {
                                  ///Offline Make
                                  /*if (paymentProof != null &&
                                        _paymentMethodController
                                            .text.isNotEmpty &&
                                        _amountController.text.isNotEmpty &&
                                        _transactionController
                                            .text.isNotEmpty) {
                                      onSubmitPOS("offline_payment");
                                    }*/
                                },
                                text: "Confirmer",
                                color: MyTheme.app_accent_color,
                                textColor: MyTheme.white,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  setClient() {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ajouter un nouveau client",
                style: const TextStyle(
                    fontSize: 16, color: MyTheme.app_accent_color),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  'assets/icon/cross.png',
                  width: 16,
                  height: 16,
                ),
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildEditTextField(
                        "Nom et prenom du client",
                        "Nom et prenom du client",
                        _nameController,
                        isMandatory: false,
                      ),
                      itemSpacer(),
                      buildEditTextField(
                        "Numero de telephone",
                        "Numero de telephone",
                        _phoneController,
                        isMandatory: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Buttons(
                    color: MyTheme.app_accent_color,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    onPressed: () {
                      //submitClient("Valider", id);
                      //Navigator.pop(context);
                    },
                    child: Text(
                      "Enregistrer",
                      style: TextStyle(color: MyTheme.white, fontSize: 16,fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
        );
      },
    );
  }

  Widget buildEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false}) {
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
            controller: textEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: hint,
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
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
          height: 3,
        ),
        child,
      ],
    );
  }

  buildCommonTypeAheadDecoration({Widget? child}) {
    return Card(
      elevation: 5,
      child: Container(
        height: 36,
        width: DeviceInfo(context).getWidth(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: MyTheme.white,
              offset: const Offset(0, 6),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Text buildFieldTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }

  InputDecoration buildAddressInputDecoration(BuildContext context, hintText) {
    return InputDecoration(
        fillColor: MyTheme.white,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 12.0, color: MyTheme.grey_153),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.noColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: MyTheme.app_accent_color.withOpacity(0.5), width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 16.0));
  }

  Widget buildCheckContainer(bool check) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: check ? 1 : 0,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(Icons.check, color: Colors.white, size: 10),
        ),
      ),
    );
  }
}
