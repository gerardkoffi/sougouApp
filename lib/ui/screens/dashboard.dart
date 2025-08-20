import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:sougou_app/ui/screens/SelsScreen.dart';
import 'package:sougou_app/ui/screens/accountScreen.dart';
import 'package:sougou_app/ui/screens/productsScreen.dart';
import '../../my_theme.dart';
import '../custom/commun_function.dart';
import '../custom/commun_style.dart';
import '../custom/customerDateTimes.dart';
import '../custom/route_transaction.dart';
import 'home_screen.dart';
import 'pos_screen.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  String title = "";
  var _children = [
    Home(
      fromBottombar: true,
    ),
    Products(
      fromBottomBar: true,
    ),
    SalesScreen(fromBottomBar: true),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void onTapped(int i) {
    if (i == 3) {
      // setState(() {
      //   _scaffoldKey.currentState.openEndDrawer();
      // });
      //
      slideRightWidget(newPage: Account(), context: context, opaque: false);
    } else {
      setState(() {
        _currentIndex = i;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    //ShopInfoHelper().setShopInfo();
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  onPop(value) {}

  _onBackPressed() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      CommonFunctions(context).appExitDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),
        extendBody: true,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(), // Ajoute une encoche pour le FAB
          notchMargin: 1.0, // Espace entre le bouton et la barre
          child: Container(
            height: 60, // Hauteur ajustée
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem("assets/icon/dashboard.png", "Dashboard", 0),
                _buildNavItem("assets/icon/products.png", "Produits", 1),
                SizedBox(width: 30), // Espace pour le FAB
                _buildNavItem("assets/icon/orders.png", "Ventes", 2),
                _buildNavItem("assets/icon/account.png", "Compte", 3),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: 65, // Taille plus grande
          height: 65,
          child: FloatingActionButton(
            backgroundColor: MyTheme.app_accent_color,
            elevation: 4.0,
            shape: const CircleBorder(),
            onPressed: () => MyTransaction(context: context).push(const PosManager()),
            child: Icon(
              Icons.add_shopping_cart_outlined,
              size: 35, // Taille ajustée
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Positionne le bouton au centre
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => onTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isSelected ? 28 : 24, // Effet d'agrandissement
            height: isSelected ? 28 : 24,
            child: Image.asset(
              iconPath,
              color: isSelected ? MyTheme.accent_color : Color.fromRGBO(153, 153, 153, 1),
            ),
          ),
          SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? MyTheme.accent_color : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leadingWidth: 0.0,
      backgroundColor: Colors.white,
      elevation: 5,
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _currentIndex == 0
              ? Image.asset(
            'assets/icons/logo1.png',
            height: 40,
            width: 30,
            //color: MyTheme.dark_grey,
          )
              : Container(
            width: 24,
            height: 24,
            child: IconButton(
              splashRadius: 15,
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              icon: Image.asset(
                'assets/icon/back_arrow.png',
                height: 20,
                width: 20,
                color: MyTheme.app_accent_color,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            getTitle(),
            style: MyTextStyle()
                .appbarText()
                .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: _currentIndex == 0,
          child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${CustomDateTime.getDayName}',
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${CustomDateTime.getDate}',
                    style: TextStyle(
                        color: MyTheme.app_accent_color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  String getTitle() {
    switch (_currentIndex) {
      case 0:
        title ="Dashboard";
        break;
      case 1:
        title = "Produits";
        break;
      case 2:
        title = "Ventes";
        break;
      case 3:
        title = "Compte";
        break;
    }
    return title;
  }
}
