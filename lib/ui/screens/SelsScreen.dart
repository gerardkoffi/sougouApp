import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../my_theme.dart';
import '../custom/app_style.dart';
import '../custom/devices_info.dart';
import '../custom/my_appbar.dart';
import '../custom/my_widget.dart';

class SalesScreen extends StatefulWidget {
  final bool fromBottomBar;

  const SalesScreen({Key? key, this.fromBottomBar = false}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late ScrollController _scrollController; // Déclaré comme late
  late ScrollController _xcrollController; // Déclaré comme late

  List<dynamic> _orderList = [];
  bool _isInitial = true;
  int _page = 1;
  int? _totalData = 0;
  bool _showLoadingContainer = false;
  String? selectedPaiementStatus;
  List<String> payment = ['Paye', 'Non Paye'];
  String? selectedFiltre;
  List<String> filtre = [
    "Aujourd'hui",
    'Hier',
    'Cette semaine',
    'Ce mois',
    'Mois passe',
    'Cette annee'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _xcrollController = ScrollController();

    fetchData();

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
          _showLoadingContainer = true;
          fetchData();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  reset() {
    _orderList.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
  }

  Future<void> _onRefresh() async {
    reset();
    setState(() {});
    await fetchData();
  }

  fetchData() async {
    // Simulation de données locales pour éviter les appels API
    await Future.delayed(const Duration(seconds: 1)); // Simulation de délai
    setState(() {
      _orderList.addAll([
        {
          'orderCode': 'ORD${_page}001',
          'orderDate': '2023-10-01',
          'paymentStatus': 'PAYE',
          'deliveryStatus': 'delivered',
          'total': '1,000,000 FCFA'
        },
        {
          'orderCode': 'ORD${_page}002',
          'orderDate': '2023-10-02',
          'paymentStatus': 'NON PAYE',
          'deliveryStatus': 'pending',
          'total': '150,000 FCFA'
        },
      ]);
      _isInitial = false;
      _totalData = _orderList.length;
      _showLoadingContainer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueContainer(),
            buildTopSection(context),
            buildOrderListList(),
          ],
        ),
      ),
    );
  }

  Column buildTopSection(BuildContext context) {
    return Column(
      children: [
        buildAppBar(context),
        buildFilterSection(context),
      ],
    );
  }

  Visibility buildAppBar(BuildContext context) {
    return Visibility(
      visible: !widget.fromBottomBar,
      child: SizedBox(
        height: AppBar().preferredSize.height + 20,
        child: MyAppBar(
          context: context,
          title: "Liste des Ventes",
        ).show(),
      ),
    );
  }

  Widget buildOrderListList() {
    return RefreshIndicator(
      color: MyTheme.app_accent_color,
      backgroundColor: Colors.white,
      displacement: 0,
      onRefresh: _onRefresh,
      child: _isInitial && _orderList.isEmpty
          ? buildOrderShimmer()
          : Container(
        height: DeviceInfo(context).getHeight() -
            ((widget.fromBottomBar ? 100 : 78) +
                AppBar().preferredSize.height),
        child: CustomScrollView(
          controller: _xcrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _orderList.isNotEmpty
                  ? ListView.separated(
                separatorBuilder: (context, index) =>
                const SizedBox(height: 20),
                padding: EdgeInsets.only(
                  top: 20,
                  left: AppStyles.layoutMargin,
                  right: AppStyles.layoutMargin,
                  bottom: widget.fromBottomBar ? 95 : 15,
                ),
                itemCount: _orderList.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigation commentée
                    },
                    child: buildOrderListItemCard(index),
                  );
                },
              )
                  : SizedBox(
                height: DeviceInfo(context).getHeight() -
                    (AppBar().preferredSize.height + 75),
                child: const Center(child: Text("Aucune donnees")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildOrderShimmer() {
    return Container(
      height: DeviceInfo(context).getHeight() -
          (AppBar().preferredSize.height + 90),
      child: SingleChildScrollView(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 10,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Shimmer.fromColors(
                baseColor: MyTheme.shimmer_base,
                highlightColor: MyTheme.shimmer_highlighted,
                child: Container(
                  height: 75,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget ValueContainer() {
    return Column(
      children: [
        SizedBox(
          height: AppStyles.listItemsMargin,
        ),
        MyWidget.customCardView(
            width: DeviceInfo(context).getWidth(),
            height: 128,
            borderRadius: 10,
            padding: EdgeInsets.symmetric(vertical: 25),
            margin: EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: MyTheme.white,
            elevation: 5,
            borderWidth: 2,
            borderColor: MyTheme.accent_color,
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  "1,150,000 FCFA",
                  style: TextStyle(
                    fontSize: 40,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),

              ],
            )),
      ],
    );
    //   : Container();
  }

  Widget buildOrderListItemCard(int index) {
    final order = _orderList[index];
    return MyWidget.customCardView(
      alignment: Alignment.center,
      backgroundColor: MyTheme.white,
      width: DeviceInfo(context).getWidth(),
      elevation: 3.0,
      borderRadius: 10,
      height: 120,
      borderColor: MyTheme.app_accent_color.withOpacity(0.3),
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    order['orderCode'] ?? 'N/A',
                    style: TextStyle(
                      color: MyTheme.app_accent_color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Text(
                        order['orderDate'] ?? 'N/A',
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.credit_card,
                          size: 16,
                          color: MyTheme.font_grey,
                        ),
                      ),
                      Text(
                        "Status - ",
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        capitalize(order['paymentStatus'] ?? 'unknown'),
                        style: TextStyle(
                          color: order['paymentStatus'] == "PAYE"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            Text(
              order['total'] ?? '0.00',
              style: TextStyle(
                color: MyTheme.app_accent_color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget buildFilterSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyWidget.customCardView(
              borderRadius: 6,
              elevation: 5,
              borderColor: MyTheme.app_accent_color,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 36,
              width: MediaQuery.of(context).size.width * .42,
              child: DropdownButton<String>(
                isExpanded: true,
                underline: Container(),
                value: selectedPaiementStatus ?? payment[0],
                onChanged: (String? value) {
                  setState(() {
                    selectedPaiementStatus = value;
                    _onRefresh(); // Rafraîchir les données après changement
                  });
                },
                items: payment.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            MyWidget.customCardView(
              borderRadius: 6,
              elevation: 5,
              borderColor: MyTheme.app_accent_color,
              backgroundColor: MyTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 36,
              width: MediaQuery.of(context).size.width * .42,
              child: DropdownButton<String>(
                isExpanded: true,
                underline: Container(),
                value: selectedFiltre ?? filtre[0],
                onChanged: (String? value) {
                  setState(() {
                    selectedFiltre = value;
                    _onRefresh(); // Rafraîchir les données après changement
                  });
                },
                items: filtre.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}