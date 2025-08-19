
import 'package:flutter/material.dart';
import 'package:sougou_app/ui/custom/chart_credit.dart';
import 'package:sougou_app/ui/custom/chart_top_product.dart';
import 'package:sougou_app/ui/screens/settings_screen/parameter_screen.dart';
import 'package:sougou_app/ui/screens/settings_screen/payment_setting.dart';

import '../../../helpers/shimmerHelpers.dart';
import '../../../my_theme.dart';
import '../../custom/app_style.dart';
import '../../custom/buttoms.dart';
import '../../custom/charts2.dart';
import '../../custom/customerDateTimes.dart';
import '../../custom/devices_info.dart';
import '../../custom/my_widget.dart';
import '../../custom/route_transaction.dart';
import '../settings_screen/forfait_screen.dart';

class Home extends StatefulWidget {
  final bool fromBottombar;

  const Home({Key? key, this.fromBottombar = false}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //String variables
  // String homePageTitle = "Dashboard";
  int _selectedTabIndex = 0;
  //bool type
  bool _faceTopProducts = false;
  bool _faceCategoryWiseProducts = false;

  // double variables
  double mHeight = 0.0, mWidht = 0.0;

  //List
  List<ChartData> chartValues = [];
  List product = [];
  //List<ProductOfTop> product = [];
  List<String> logoSliders = [];
  List categoryWiseProducts = [];
  //List<CategoryWiseProductResponse> categoryWiseProducts = [];

  String? _productsCount = '...',
      _rattingCount = "...",
      _totalOrdersCount = "...",
      _totalSalesCount = '...',
      _soldOutProducts = "...",
      _lowStockProducts = "...",
      _currentPackageName = "GOLD",
      _currentMagasinName = "Riviera 2",
      _prodcutUploadLimit = " 100000",
      _pacakgeExpDate = " 20-06-2030";

  // Future<bool> _getTop12Product() async {
  //   var response = await ShopRepository().getTop12ProductRequest();
  //   product.addAll(response.data!);
  //   _faceTopProducts = true;
  //   setState(() {});

  //   return true;
  // }
/*  Future<bool> _getTop12Product() async {
    try {
      var response = await ShopRepository().getTop12ProductRequest();

      if (response.data != null) {
        product.addAll(response.data!);
        _faceTopProducts = true;
        setState(() {});
        return true;
      } else {
        // Handle case when response.data is null
        debugPrint('No data found in response.');
        return false;
      }
    } catch (e) {
      // Handle other exceptions (like network errors)
      debugPrint('Error fetching top products: $e');
      return false;
    }
  }

  Future<bool> _getCategoryWiseProduct() async {
    var response = await ShopRepository().getCategoryWiseProductRequest();
    categoryWiseProducts.addAll(response);
    _faceCategoryWiseProducts = true;
    setState(() {});
    return true;
  }

  Future<bool> _getShopInfo() async {
    var response = await ShopRepository().getShopInfo();

    _productsCount = response.shopInfo!.products.toString();
    _rattingCount = response.shopInfo!.rating.toString();
    _totalOrdersCount = response.shopInfo!.orders.toString();
    _totalSalesCount = response.shopInfo!.sales.toString();
    _pacakgeExpDate = response.shopInfo!.packageInvalidAt;
    _currentPackageName = response.shopInfo!.sellerPackage;
    _prodcutUploadLimit = response.shopInfo!.productUploadLimit.toString();
    logoSliders.addAll(response.shopInfo!.sliders!);

    ShopInfoHelper().setShopInfo();
    setState(() {});
    return true;
  }*/

  cleanAll() {
    _productsCount = '...';
    _rattingCount = "...";
    _totalOrdersCount = "...";
    _totalSalesCount = '...';
    _soldOutProducts = "...";
    _lowStockProducts = "...";
    _currentPackageName = "...";
    _prodcutUploadLimit = "...";
    _pacakgeExpDate = "...";
    _currentMagasinName="...";
    chartValues = [];
    //product = [];
    //categoryWiseProducts = [];
    _faceTopProducts = false;
    _faceCategoryWiseProducts = false;
    setState(() {});
  }

  Future<void> reFresh() {
  //  cleanAll();
  //  facingAll();
    return Future.delayed(Duration(seconds: 1));
  }

 /* facingAll() async {
    _getTop12Product();
    _getCategoryWiseProduct();
    _getShopInfo();
  }*/

  @override
  void initState() {
    // TODO: implement initState
  //  facingAll();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    print(AppBar().preferredSize.height);
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: buildAppBar(context) as PreferredSizeWidget?,
      body: RefreshIndicator(
        onRefresh: reFresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(child: buildBodyContainer()),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildBodyContainer() {
    return changeMainContent(_selectedTabIndex);
  }

  changeMainContent(int index) {
    switch (index) {
      case 0:
        return dashboard();
        break;
      case 1:
        return dashboard1();
        break;
      case 2:
        return dashboard2();
        break;
      default:
        return Container();
    }
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 0.0,
      centerTitle: false,
      elevation: 0.0,
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size(mWidht,0),
        child: buildTapBar(),
      ),
    );
  }

  Widget buildTapBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildTopTapBarItem(
              "GENERAL", 0),
          tabBarDivider(),
          buildTopTapBarItem(
              "CREDIT", 1),
          tabBarDivider(),
          buildTopTapBarItem(
              "CHIFFRE D'AFFAIRE", 2),
        ],
      ),
    );
  }

  Container buildTopTapBarItem(String text, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: 45,
        width: screenWidth/3,
        color: _selectedTabIndex == index
            ? MyTheme.accent_color.withOpacity(0.9)
            : MyTheme.app_accent_border.withOpacity(0.5),
        child: Buttons(
            onPressed: () {
              _selectedTabIndex = index;
              setState(() {});
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MyTheme.app_accent_color),
            )));
  }

  Widget tabBarDivider() {
    return const SizedBox(
      width: 1,
      height: 50,
    );
  }

  Widget dashboard() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
            ),
            top4Boxes(),
            //buildPackageUpgradeContainer(context),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
            settingContainer(),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
            //packageContainer(),

            //topProductsContainer(),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
          ],
        ));
  }
  Widget dashboard1() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
            ),
            top4Credit(),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
          /*  buildPackageUpgradeContainer(context),
            Container(
              height: AppStyles.listItemsMargin,
            )*/
            //chartTopProductContainer(),
            packageContainer(),
            Container(
              height: AppStyles.spaceItem,
            ),
          ],
        ));
  }
  Widget dashboard2() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
            ),
            topCA(),
            //buildPackageUpgradeContainer(context),
            Container(
              height: AppStyles.listItemsMargin,
            ),
            chartTopProductContainer(),
            packageContainer(),
            Container(
              height: AppStyles.spaceItem,
            ),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
          ],
        ));
  }
  Widget dashboard3() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top4Boxes(),
            //buildPackageUpgradeContainer(context),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
            //featureContainer(),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
            /* if (!verify_form_submitted.$ && !shop_verify.$)
              Column(
                children: [
                  verifyContainer(),
                  SizedBox(
                    height: AppStyles.listItemsMargin,
                  ),
                ],
              ),*/
            settingContainer(),
            //SizedBox(
            //  height: AppStyles.listItemsMargin,
            // ),
            //chartCreditContainer(),
            //SizedBox(
            //  height: AppStyles.listItemsMargin,
            // ),
            //categoryWiseProduct(),
            Container(
              height: AppStyles.listItemsMargin,
            ),
            chartTopProductContainer(),
            packageContainer(),
            Container(
              height: AppStyles.spaceItem,
            ),
            //topProductsContainer(),
            SizedBox(
              height: AppStyles.listItemsMargin,
            ),
          ],
        ));
  }

  Widget buildTopProductsShimmer() {
    return Container(
      height: DeviceInfo(context).getHeight(),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  //bottom: 15, top: index == product.length - 1 ? 15 : 0),
                  bottom: 15, top: 15),
              child: MyWidget.customCardView(
                elevation: 5,
                height: 112,
                width: DeviceInfo(context).getWidth(),
                borderRadius: 10.0,
                borderColor: MyTheme.light_grey,
                child: ShimmerHelper().buildBasicShimmer(
                    height: 112.0, width: DeviceInfo(context).getWidth()),
              ),
            );
          }),
    );
  }

  Container topProductsContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Title
          Container(
            height: 17,
            child: Text("Tops Produits",
              style: TextStyle(
                fontSize: 14,
                color: MyTheme.app_accent_color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppStyles.itemMargin),
          // Main content
          _faceTopProducts
              ? product.isEmpty
              ? Container(
            alignment: Alignment.center,
            height: 205,
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "Donnees non disponible",
              style: TextStyle(
                fontSize: 14,
                color: MyTheme.app_accent_color,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: product.length,
            itemBuilder: (context, index) {
              return buildTopProductItem(index);
            },
          )
              : buildTopProductsShimmer(),
        ],
      ),
    );
  }

  Widget buildTopProductItem(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: MyWidget.customCardView(
        backgroundColor: MyTheme.white,
        elevation: 5,
        height: 112,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10.0,
        borderColor: MyTheme.light_grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget.imageWithPlaceholder(
              url: product[index].thumbnailImg,
              width: 112.0,
              height: 112.0,
              radius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    product[index].name!,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12, color: MyTheme.font_grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    product[index].category!,
                    style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.grey_153,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    product[index].price!,
                    style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.app_accent_color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesShimmer() {
    return Container(
      height: 112,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ShimmerHelper()
                .buildBasicShimmer(height: 112.0, width: 89.0);
          }),
    );
  }

  Widget categoryWiseProductShimmer() {
    return Column(
      children: [
        ShimmerHelper().buildBasicShimmer(height: 20),
        SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
        SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
        SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
      ],
    );
  }

  Container categoryWiseProduct() {
    return MyWidget.customContainer(
        alignment: Alignment.topLeft,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 17,
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Vos categories" +
                    " (${categoryWiseProducts.length})",
                style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            _faceCategoryWiseProducts
                ? product.length == 0
                ? Container(
              alignment: Alignment.center,
              height: 112,
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Donnees non disponible",
                style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            )
                : Container(
              height: 112,
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.itemMargin),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: AppStyles.itemMargin,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryWiseProducts.length,
                  itemBuilder: (context, index) {
                    return buildCategoryItem(index);
                  }),
            )
                : buildCategoriesShimmer(),
          ],
        ));
  }

  Widget buildCategoryItem(int index) {
    return MyWidget.customCardView(
        backgroundColor: MyTheme.noColor,
        elevation: 5,
        blurSize: 20,
        height: 112,
        width: 89,
        // borderRadius: 12.0,
        shadowColor: MyTheme.app_accent_shado,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: MyWidget.imageWithPlaceholder(
                  url: categoryWiseProducts[index].banner,
                  width: 89.0,
                  height: 112.0,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(12),
                ),
              ),
              Container(
                height: 112,
                width: 89,
                decoration: BoxDecoration(
                    color: MyTheme.app_accent_tranparent,
                    borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        categoryWiseProducts[index].name!,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 10,
                            color: MyTheme.white,
                            fontWeight: FontWeight.normal),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Text(
                      "(" +
                          categoryWiseProducts[index].cntProduct.toString() +
                          ")",
                      style: TextStyle(
                          fontSize: 10,
                          color: MyTheme.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget chartShimmer() {
    return Container(
      height: 130,
      width: DeviceInfo(context).getWidth() / 1.5,
      child:
      ShimmerHelper().buildListShimmer(item_height: 20.0, item_count: 10),
    );
  }

  Widget chartContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: MyWidget.customCardView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        height: 190,
        shadowColor: MyTheme.app_accent_color_extra_light,
        backgroundColor: MyTheme.white,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10,
        child: Stack(
          children: [
            // Positioned(
            //   right: 5,
            //   child: Text(
            //     "20-26 Feb, 2022",
            //     style: TextStyle(
            //         fontSize: 10, color: MyTheme.app_accent_color),
            //   ),
            // ),
            Positioned(
              left: 0,
              child: Text(
                "Ventes mois de " + CustomDateTime.getMonth,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  height: 180,
                  width: DeviceInfo(context).getWidth(),
                  //child:  Container()),
                  child: const MChart()),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartCreditContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: MyWidget.customCardView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        height: 190,
        shadowColor: MyTheme.app_accent_color_extra_light,
        backgroundColor: MyTheme.white,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10,
        child: Stack(
          children: [
            // Positioned(
            //   right: 5,
            //   child: Text(
            //     "20-26 Feb, 2022",
            //     style: TextStyle(
            //         fontSize: 10, color: MyTheme.app_accent_color),
            //   ),
            // ),
            Positioned(
              left: 0,
              child: Text(
                "Credit mois de " + CustomDateTime.getMonth,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                  height: 180,
                  width: DeviceInfo(context).getWidth(),
                  //child:  Container()),
                  child: const CreditChart()),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartTopProductContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: MyWidget.customCardView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        height: 250,
        shadowColor: MyTheme.app_accent_color_extra_light,
        backgroundColor: MyTheme.white,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Text(
                "Tops Produits de " + CustomDateTime.getMonth,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                  height: 300,
                  width: DeviceInfo(context).getWidth(),
                  //child:  Container()),
                  child: const TopsProduitChart()),
            ),
          ],
        ),
      ),
    );
  }

  Widget packageContainer() {
    //return seller_package_addon.$
     //   ?
    return Column(
      children: [
        SizedBox(
          height: AppStyles.listItemsMargin,
        ),
        MyWidget.customCardView(
            width: DeviceInfo(context).getWidth(),
            height: 128,
            borderRadius: 10,
            margin: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: MyTheme.white,
            elevation: 5,
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Image.asset(
                  'assets/icon/package.png',
                  width: 64,
                  height: 64,
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Package actuel",
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _currentPackageName!,
                          style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "Limite de produit",
                          style: TextStyle(
                              fontSize: 10,
                              color: MyTheme.grey_153,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          " "+_prodcutUploadLimit! +
                              " " +
                              "Produits",
                          style: TextStyle(
                              fontSize: 10,
                              color: MyTheme.grey_153,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Date d'expiration",
                          style: TextStyle(
                              fontSize: 10,
                              color: MyTheme.grey_153,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          " "+_pacakgeExpDate!,
                          style: TextStyle(
                              fontSize: 10,
                              color: MyTheme.grey_153,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        MyTransaction(context: context).push(Packages());
                      },
                      child: MyWidget().myContainer(
                          bgColor: MyTheme.app_accent_color,
                          borderRadius: 6,
                          height: 36,
                          width: DeviceInfo(context).getWidth() / 2.2,
                          child: Text("Packages",
                            style: TextStyle(
                                fontSize: 12,
                                color: MyTheme.white,
                                fontWeight: FontWeight.w400),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                Spacer(),
              ],
            )),
      ],
    );
     //   : Container();
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
                //MyTransaction(context: context).push(Packages());
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

  Widget settingContainer() {
    return Container(
      width: DeviceInfo(context).getWidth(),
      padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyWidget.customCardView(
              borderWidth: 1,
              elevation: 5,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(vertical: 5),
              width: DeviceInfo(context).getWidth() / 2 - 23,
              height: DeviceInfo(context).getWidth() / 2 - 20,
              borderColor: MyTheme.app_accent_border,
              backgroundColor: MyTheme.app_accent_color_extra_light,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Parametres",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.app_accent_color),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Configuration et reglage de l'application",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: MyTheme.app_accent_color),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/icon/shop_setting.png",
                    color: MyTheme.app_accent_color,
                    height: 32,
                    width: 32,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      MyTransaction(context: context).push(ShopSettings());
                    },
                    child: MyWidget().myContainer(
                      bgColor: MyTheme.accent_color,
                      child: Text(
                        "Allez au parametre",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      width: DeviceInfo(context).getWidth() / 3,
                      height: 30,
                      borderRadius: 6,
                    ),
                  )
                ],
              )),
          SizedBox(
            width: 14,
          ),
          MyWidget.customCardView(
              elevation: 5,
              borderRadius: 10,
              borderWidth: 1,
              padding: EdgeInsets.symmetric(vertical: 5),
              width: DeviceInfo(context).getWidth() / 2 - 23,
              height: DeviceInfo(context).getWidth() / 2 - 20,
              borderColor: MyTheme.app_accent_border,
              backgroundColor: MyTheme.app_accent_color_extra_light,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Parametre paiement",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.app_accent_color),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Configurer votre methode de paiement",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: MyTheme.app_accent_color),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/icon/payment_setting.png",
                    color: MyTheme.app_accent_color,
                    height: 32,
                    width: 32,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      MyTransaction(context: context).push(PaymentSetting());
                    },
                    child: MyWidget().myContainer(
                      bgColor: MyTheme.accent_color,
                      child: Text(
                        "Configurez maintenant",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      width: DeviceInfo(context).getWidth() / 3,
                      height: 30,
                      borderRadius: 6,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget verifyContainer() {
    return Container(
      width: DeviceInfo(context).getWidth(),
      padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
      child: MyWidget.customCardView(
        elevation: 5,
        borderRadius: 10,
        borderWidth: 1,
        //padding:EdgeInsets.symmetric(vertical: 5),
        width: DeviceInfo(context).getWidth(),
        height: DeviceInfo(context).getWidth() / 2 - 20,
        borderColor: MyTheme.app_accent_border,
        backgroundColor: MyTheme.app_accent_color_extra_light,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Non verifie",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Verifie ton compte",
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: MyTheme.app_accent_color),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Image.asset(
              "assets/icon/unverify.png",
              height: 32,
              width: 32,
            ),
            InkWell(
              onTap: () {
              //  MyTransaction(context: context)
              //      .push(const VerifyPage())
              //      .then((value) {
              //    if (!verify_form_submitted.$!) {
              //      setState(() {});
              //    }
              //  });
              },
              child: MyWidget().myContainer(
                bgColor: MyTheme.app_accent_color,
                child: Text(
                  "Verifier!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                width: DeviceInfo(context).getWidth() / 3,
                height: 30,
                borderRadius: 6,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget featureContainer() {
    return Container(
        width: DeviceInfo(context).getWidth(),
        alignment: Alignment.center,
        color: MyTheme.app_accent_color,
        //padding: EdgeInsets.symmetric(horizontal: 15.0,),
        height: 90,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                FeaturesList(context).getFeatureList().length, (index) {
              return Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 22.0,
                        left: index == 0 &&
                            FeaturesList(context).getFeatureList().length > 3
                            ? 22
                            : 0),
                    child: FeaturesList(context).getFeatureList()[index],
                  ));
            }),
          ),*/
        ));
  }

  Widget top4Boxes() {
    return Stack(
      children: [
        Positioned(
          top: 15,
          right: 1,
          left: 1,
          child:chartContainer()
        ),

        // this container only for transparent color
        Container(
          height: 445,
          decoration: const BoxDecoration(
          ),
        ),

        Positioned(
          bottom: 0,
          child: Container(
              color: Colors.transparent,
              // margin: EdgeInsets.only(top: 60),
              //color: MyTheme.red,
              //height: 190,
              width: DeviceInfo(context).getWidth(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: "Produits",
                          counter: _productsCount,
                          iconUrl: 'assets/icon/products.png'),
                      MyWidget.homePageTopBox(context,
                          title:
                          "Benefice",
                          counter: _rattingCount,
                          iconUrl: 'assets/icon/rating.png'),
                    ],
                  ),
                  Row(
                    children: [
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: "Depenses",
                          counter: _totalOrdersCount,
                          iconUrl: 'assets/icon/orders.png'),
                      MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: "Ventes",
                          counter: _totalSalesCount,
                          iconUrl: 'assets/icon/sales.png'),
                    ],
                  )
                ],
              )
          ),
        ),
      ],
    );
  }
  Widget top4Credit() {
    return Stack(
      children: [
        Positioned(
            top: 15,
            right: 1,
            left: 1,
            child:chartCreditContainer(),
        ),

        // this container only for transparent color
        Container(
          height: 355,
          decoration: const BoxDecoration(),
        ),

        Positioned(
          bottom: 0,
          child: Container(
              color: Colors.transparent,
              // margin: EdgeInsets.only(top: 60),
              //color: MyTheme.red,
              //height: 190,
              width: DeviceInfo(context).getWidth(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyWidget.homePageTopBox1(context,
                      elevation: 5,
                      title: "Credits",
                      counter: _totalOrdersCount,
                      iconUrl: 'assets/icon/orders.png')
                ],
              )
          ),
        ),
      ],
    );
  }
  Widget topCA() {
    return Stack(
      children: [
        Container(
            color: Colors.transparent,
            // margin: EdgeInsets.only(top: 60),
            //color: MyTheme.red,
            //height: 190,
            width: DeviceInfo(context).getWidth(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyWidget.homePageTopBox1(context,
                    elevation: 5,
                    title: "Chiffre d'Affaire",
                    counter: _totalOrdersCount,
                    iconUrl: 'assets/icon/orders.png')
              ],
            )
        ),
      ],
    );
  }
}

class ChartData {
  int salesValue;
  String date;

  ChartData(this.date, this.salesValue);
}
