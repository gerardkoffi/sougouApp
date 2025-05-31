import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';
import '../../../my_theme.dart';
import '../../custom/devices_info.dart';
import '../../custom/input_decoration.dart';
import '../../custom/my_appbar.dart';
import '../../custom/my_widget.dart';
import '../../custom/submit_buttom.dart';
import '../../custom/toast_component.dart';

class PaymentSetting extends StatefulWidget {
  const PaymentSetting({Key? key}) : super(key: key);

  @override
  State<PaymentSetting> createState() => _PaymentSettingState();
}

class _PaymentSettingState extends State<PaymentSetting> {
  TextEditingController bankNameEditingController =
  TextEditingController(text: "");
  TextEditingController accountNameEditingController =
  TextEditingController(text: "");
  TextEditingController accountNumberEditingController =
  TextEditingController(text: "");
  TextEditingController bankRoutingNumberEditingController =
  TextEditingController(text: "");

  late BuildContext loadingContext;

  String? bankName,
      accountName,
      accountNumber,
      bankRoutingNumber,
      bankPayment,
      cinetpay,
      cashPayment;

  setDataInEditController() {
    bankNameEditingController.text = bankName!;
    accountNameEditingController.text = accountName!;
    accountNumberEditingController.text = accountNumber!;
    bankRoutingNumberEditingController.text = bankRoutingNumber!;
  }

  bool _faceData = false;

  String error = "Provide Number";

  setDataInVariable() {
    bankName = bankNameEditingController.text;
    accountName = accountNameEditingController.text;
    accountNumber = accountNumberEditingController.text;
    bankRoutingNumber = bankRoutingNumberEditingController.text;
  }

  Future<bool> _getAccountInfo() async {
    //var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);
    //bankName = response.shopInfo!.bankName;
    //accountName = response.shopInfo!.bankAccName;
    //accountNumber = response.shopInfo!.bankAccNo;
    //bankRoutingNumber = response.shopInfo!.bankRoutingNo.toString();
    //bankPayment = response.shopInfo!.bank_payment_status.toString();
    //cashPayment = response.shopInfo!.cashOnDeliveryStatus.toString();

    print(bankPayment);

    setDataInEditController();

    _faceData = true;
    setState(() {});
    return true;
  }

  faceData() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadingShow(context));
    _getAccountInfo();
  }

  updateInfo() async {
    setDataInVariable();

    var postBody = jsonEncode({
      "cash_on_delivery_status": cashPayment,
      "bank_payment_status": bankPayment,
      "bank_name": bankName,
      "bank_acc_name": accountName,
      "bank_acc_no": accountNumber,
      "bank_routing_no": bankRoutingNumber,
    });
    loadingShow(context);
    //var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);

    // if (response.result!) {
    //   ToastComponent.showDialog(
    //     response.message,
    //     gravity: Toast.center,
    //     duration: 3,
    //     textStyle: TextStyle(color: MyTheme.black),
    //   );
    // } else {
    //   ToastComponent.showDialog(
    //     response.message,
    //     gravity: Toast.center,
    //     duration: 3,
    //     textStyle: TextStyle(color: MyTheme.black),
    //   );
    // }
  }

  @override
  void initState() {
    //faceData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          context: context,
          title: "Parametre de paiment").show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Par Carte Bancaire",
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: MyTheme.green,
                      inactiveThumbColor: Colors.grey,
                      value: bankPayment == "1",
                      onChanged: (value) {
                        if (value) {
                          bankPayment = "1";
                        } else {
                          bankPayment = "0";
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Paiement Cash",
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: MyTheme.green,
                      inactiveThumbColor: Colors.grey,
                      value: cashPayment == "1",
                      onChanged: (value) {
                        if (value) {
                          cashPayment = "1";
                        } else {
                          cashPayment = "0";
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("CinetPay",
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.green,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: MyTheme.green,
                      inactiveThumbColor: Colors.grey,
                      value: cinetpay == "1",
                      onChanged: (value) {
                        if (value) {
                          cinetpay = "1";
                        } else {
                          cinetpay = "0";
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 14,
              // ),
              // buildBankName(context),
              // SizedBox(
              //   height: 14,
              // ),
              // buildBankAccountName(context),
              // SizedBox(
              //   height: 14,
              // ),
              // buildBankAccountNumber(context),
              // SizedBox(
              //   height: 14,
              // ),
              // buildBankRoutingNumber(context),
              SizedBox(
                height: 30,
              ),
              SubmitBtn.show(
                  elevation: 5,
                  onTap: () {
                    updateInfo();
                  },
                  alignment: Alignment.center,
                  height: 48,
                  backgroundColor: MyTheme.app_accent_color,
                  radius: 6.0,
                  width: DeviceInfo(context).getWidth(),
                  child: Text("Sauvegarder",
                    style: TextStyle(fontSize: 17, color: MyTheme.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Column buildBankRoutingNumber(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IBAN",
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          backgroundColor: MyTheme.white,
          child: TextField(
            onChanged: (data) {
              if (!isNumeric(data)) {
                bankRoutingNumberEditingController.text = "";
              }
              print(data);
            },
            keyboardType: TextInputType.number,
            controller: bankRoutingNumberEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "91400554",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankAccountNumber(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Numero de compte",
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          child: TextField(
            controller: accountNumberEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "7131259163",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankAccountName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nom du compte",
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          child: TextField(
            controller: accountNameEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: "Premium",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  Column buildBankName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nom de la banque",
          style: TextStyle(
              fontSize: 12,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          width: DeviceInfo(context).getWidth(),
          height: 45,
          borderRadius: 10,
          elevation: 5,
          child: TextField(
            controller: bankNameEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text:"SGCI",
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
          ),
        ),
      ],
    );
  }

  loadingShow(BuildContext myContext) {
    return showDialog(
      //barrierDismissible: false,
        context: myContext,
        builder: (BuildContext context) {
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
}
