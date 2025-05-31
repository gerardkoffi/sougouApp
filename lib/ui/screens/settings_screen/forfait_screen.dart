import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../../helpers/shimmerHelpers.dart';
import '../../../my_theme.dart';
import '../../custom/app_style.dart';
import '../../custom/devices_info.dart';
import '../../custom/my_appbar.dart';


class Packages extends StatefulWidget {
  const Packages({Key? key}) : super(key: key);

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  List<Package> _packages = [
    Package(
        id: 1,
        name: "BASIC",
        amount: "15 000 FCFA",
        duration: 30,
        productUploadLimit: 1000,
        user: "1 utilisateur (Administrateur Unique)",
        support: "✅Support et assistance",
        materiel: "❌Tablette & Imprimante",
        ecommerce: "❌Integration Ecommerce",
        exportation: "❌Exportation de donnees EXCEL,CSV,PDF",
        facture: "❌Gestion de facturation",
        logo: "assets/icon/package.png"),
    Package(
        id: 2,
        name: "PREMIUM",
        amount: "50 000 FCFA",
        duration: 90,
        productUploadLimit: 50000,
        user: "3 utilisateur (Administrateur et 2 utilisateurs)",
        support: "✅Support et assistance",
        materiel: "❌Tablette & Imprimante",
        ecommerce: "❌Integration Ecommerce",
        exportation: "✅Exportation de donnees EXCEL,CSV,PDF",
        facture: "✅Gestion de facturation",
        logo: "assets/icon/package.png"),
    Package(
        id: 3,
        name: "GOLD",
        amount: "150 000 FCFA",
        duration: 180,
        productUploadLimit: 100000,
        user: "6 utilisateur (2 Administrateurs et 4 utilisateurs )",
        support: "✅Support et assistance",
        materiel: "✅Tablette & Imprimante",
        ecommerce: "✅Integration Ecommerce",
        exportation: "✅Exportation de donnees EXCEL,CSV,PDF",
        facture: "✅Gestion de facturation",
        logo: "assets/icon/package.png"),
  ];
  bool _isFetchAllData = false;

  List<PaymentTypeResponse> _onlinePaymentList = [
    PaymentTypeResponse(payment_type_key: "stripe", name: "Stripe"),
    PaymentTypeResponse(payment_type_key: "paypal", name: "PayPal"),
  ];

  List<PaymentTypeResponse> _offlinePaymentList = [
    PaymentTypeResponse(payment_type_key: "bank_transfer", name: "Bank Transfer"),
  ];

  final List<PaymentType> _paymentOptions = [
    PaymentType(key: "online", value: "Online Payment"),
    PaymentType(key: "offline", value: "Offline Payment"),
  ];

  PaymentTypeResponse? _selectedOnlinePaymentTypeValue;
  PaymentTypeResponse? _selectedOfflinePaymentTypeValue;
  PaymentType? _selectedPaymentOption;

  Future<bool> fetchData() async {
    _selectedOnlinePaymentTypeValue = _onlinePaymentList.first;
    _selectedOfflinePaymentTypeValue = _offlinePaymentList.first;
    _isFetchAllData = true;
    setState(() {});
    return true;
  }

  @override
  void initState() {
    _selectedPaymentOption = _paymentOptions.first;
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          context: context,
          title: "Packages")
          .show(),
      body: _isFetchAllData ? buildList() : loadingShimmer(),
    );
  }

  ListView buildList() {
    return ListView.builder(
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        return packageItem(
          _packages[index],
        );
      },
    );
  }

  Widget loadingShimmer() {
    return ShimmerHelper().buildListShimmer(item_count: 10, item_height: 170.0);
  }

  Widget packageItem(Package package) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(package.logo,),
        title: Text(package.name!,
            style: TextStyle(
                color: MyTheme.accent_color,
                fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔹${package.amount} / ${package.duration} Jours",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("🔹Limite de produits: ${package.productUploadLimit}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("🔹${package.user}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("${package.facture}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("${package.exportation}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("${package.ecommerce}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("${package.materiel}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
            Text("${package.support}",
                style: TextStyle(color: MyTheme.app_accent_color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
                )),
          ],
        ),
        trailing: ElevatedButton(
          style: ButtonStyle(
             backgroundColor: WidgetStatePropertyAll(MyTheme.accent_color)
          ),
          onPressed: () {},
          child: Text("Choisir", style: TextStyle(color: MyTheme.white),),
        ),
      ),
    );
  }
}

class Package {
  int id;
  String name;
  String amount;
  int duration;
  int productUploadLimit;
  String user;
  String facture;
  String ecommerce;
  String exportation;
  String support;
  String materiel;
  String logo;

  Package({
    required this.id,
    required this.name,
    required this.amount,
    required this.duration,
    required this.productUploadLimit,
    required this.user,
    required this.facture,
    required this.ecommerce,
    required this.exportation,
    required this.support,
    required this.materiel,
    required this.logo,
  });
}

class PaymentTypeResponse {
  String payment_type_key;
  String name;

  PaymentTypeResponse({
    required this.payment_type_key,
    required this.name,
  });
}

class PaymentType {
  String key;
  String value;

  PaymentType({
    required this.key,
    required this.value,
  });
}
