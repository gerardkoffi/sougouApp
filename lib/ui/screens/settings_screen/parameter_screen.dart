import 'package:flutter/material.dart';
import '../../../my_theme.dart';
import '../../custom/buttoms.dart';
import '../../custom/devices_info.dart';
import '../../custom/my_appbar.dart';
import '../../custom/route_transaction.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({Key? key}) : super(key: key);

  @override
  _ShopSettingsState createState() => _ShopSettingsState();
}

class _ShopSettingsState extends State<ShopSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Parametre", context: context)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Buttons(
                color: MyTheme.app_accent_color,
                width: DeviceInfo(context).getWidth(),
                height: 65,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  //MyTransaction(context: context).push(ShopGeneralSetting());
                },
                child: Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0,left: 10),
                        child: Image.asset("assets/icon/general_setting.png",height: 25,width: 25,),
                      ),

                      Text("Paramètres généraux",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 25,
                        color: MyTheme.white,
                      )
                    ],
                  ),
                ),
              ),


              Visibility(
                visible: true,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Buttons(
                      color: MyTheme.app_accent_color,
                      width: DeviceInfo(context).getWidth(),
                      height: 65,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        //MyTransaction(context: context).push(ShopDeliveryBoyPickupPoint());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0,left: 10),
                            child: Image.asset("assets/icon/orders.png",height: 25,width: 25,color: MyTheme.white),
                          ),
                          Text("Stock et Gestion de produits",
                            style: TextStyle(
                                fontSize: 14,
                                color: MyTheme.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next_rounded,
                            size: 25,
                            color: MyTheme.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Buttons(
                  color: MyTheme.app_accent_color,
                  width: DeviceInfo(context).getWidth(),
                  height: 65,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    //MyTransaction(context: context).push(ShopBannerSettings());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0,left: 10),
                        child: Image.asset("assets/icon/products.png",height: 25,width: 25,color: MyTheme.white),
                      ),

                      Text("Ventes et Facturation",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 25,
                        color: MyTheme.white,
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Buttons(
                  color: MyTheme.app_accent_color,
                  width: DeviceInfo(context).getWidth(),
                  height: 65,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    //MyTransaction(context: context).push(ShopSocialMedialSetting());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0,left: 10),
                        child: Image.asset("assets/icon/banner_setting.png",height: 25,width: 25,),
                      ),

                      Text("Sauvegarde et Securite",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 25,
                        color: MyTheme.white,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
