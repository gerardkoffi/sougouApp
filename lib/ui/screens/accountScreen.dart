
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/ui/screens/auth/login.dart';
import 'package:toast/toast.dart';

import '../../data/model/auth_model.dart';
import '../../data/repositories/auth_repositories.dart';
import '../../helpers/shared_values.dart';
import '../../my_theme.dart';
import '../custom/buttoms.dart';
import '../custom/devices_info.dart';
import '../custom/my_widget.dart';
import '../custom/toast_component.dart';
import 'dashboard.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  late AnimationController controller;
  Animation? animation;

  bool? _verify = false;
  bool _faceData = false;
  bool _auctionExpand = false;
  bool _posExpand = false;
  String nom = '';
  String prenom = '';
  String telephone = '';
  bool isVerified = false;
  String magasinNom = '';
  String magasinVille = '';

  final ExpansionTileController expansionTileController =
  ExpansionTileController();
  logoutReq() async {
    try {
      var response = await AuthRepository().getLogoutResponse();

      if (response.codeText == "LOGOUT") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.setBool('is_logged_in', false);
        clearUserInfo();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Déconnexion réussie !")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
              (route) => false,
        );
      } else {
        ToastComponent.showDialog(
          response.message ?? "Une erreur est survenue.",
          gravity: Toast.center,
          duration: 3,
          textStyle: TextStyle(color: MyTheme.black),
        );
      }
    } catch (e) {
      print(e);
      ToastComponent.showDialog(
        "Erreur de déconnexion : $e",
        gravity: Toast.center,
        duration: 3,
        textStyle: TextStyle(color: MyTheme.black),
      );
    }
  }

  Future<void> _loadUserInfos() async {
    final prefs = await SharedPreferences.getInstance();
    final magasinJson = prefs.getString('user_default_magasin');
    setState(() {
      nom = prefs.getString('user_nom') ?? '';
      prenom = prefs.getString('user_prenom') ?? '';
      telephone = prefs.getString('user_telephone') ?? '';
      isVerified = prefs.getBool('user_phone_verified') ?? false;
      if (magasinJson != null) {
        final magasin = jsonDecode(magasinJson);
        magasinNom = magasin['nom'] ?? '';
        magasinVille = magasin['ville'] ?? '';
      }
    });
  }


  Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_nom');
    await prefs.remove('user_prenom');
    await prefs.remove('user_telephone');
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.5, end: 1.0).animate(controller);
    super.initState();
    _loadUserInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.app_accent_color,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This is the back button
              buildBackButtonContainer(context),
              Container(
                color: MyTheme.app_accent_color_extra_light,
                height: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15), // Ajout de const pour optimisation
                child: Row(
                  children: [
                    MyWidget.roundImageWithPlaceholder(
                      width: 48.0,
                      height: 48.0,
                      borderRadius: 24.0,
                      url: '', // Gestion de null avec une valeur par défaut
                      backgroundColor: MyTheme.noColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$prenom $nom',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: MyTheme.white,
                              decoration: TextDecoration.none, // Supprime tout soulignement
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            telephone, // Gestion de null
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: MyTheme.app_accent_border.withOpacity(0.8),
                              //decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              if (isVerified) ...[
                                Image.asset(
                                  'assets/icon/verify.png',
                                  width: 16,
                                  height: 15,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Vérifié',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MyTheme.app_accent_border,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ] else ...[
                                Image.asset(
                                  'assets/icon/unverify.png', // Remplace par ton icône d’utilisateur non vérifié
                                  width: 16,
                                  height: 15,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Non vérifié',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.redAccent, // ou MyTheme.errorColor
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                               Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      'assets/icon/account.png',
                                      width: 16,
                                      height: 13,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$magasinNom', // Gestion de null
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: MyTheme.app_accent_border,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                color: MyTheme.app_accent_color_extra_light,
                height: 1,
              ),
              // SizedBox(height: 20,),
              Container(
                color: MyTheme.app_accent_color,
                height: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              buildItemFeature(context),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: MyTheme.app_accent_color_extra_light,
                height: 1,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 80,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 40,
                  child: Buttons(
                    onPressed: () {
                      logoutReq();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icon/logout.png',
                              width: 16,
                              height: 16,
                              color: MyTheme.app_accent_border,
                            ),
                            const SizedBox(
                              width: 26,
                            ),
                            Text(
                              "Deconnexion",
                              style:
                              TextStyle(fontSize: 14, color: MyTheme.white),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.navigate_next_rounded,
                          size: 20,
                          color: MyTheme.app_accent_border,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: MyTheme.app_accent_color_extra_light,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildBackButtonContainer(BuildContext context) {
    return Container(
      height: 47,
      alignment: Alignment.topRight,
      child: SizedBox(
        width: 47,
        child: Buttons(
          padding: EdgeInsets.zero,
          onPressed: () {
            pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 24,
            color: MyTheme.app_accent_border,
          ),
        ),
      ),
    );
  }

  Widget buildItemFeature(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const ProfileEdit());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/profile.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Profil",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(ChangeLanguage());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/account.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Magasins",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            child: Buttons(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Main(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      }),
                      (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/dashboard.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Tableau de bord",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const Orders());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/orders.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text("Ventes",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const Orders());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/profile.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text("Clients",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const Products());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icon/products.png',
                          width: 16,
                          height: 16,
                          color: MyTheme.app_accent_border),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Produits",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const DigitalProducts());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/orders.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Bilan",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          if (pos_manager_activation.$) buildPosSystem(),
          if (wholesale_addon_installed.$)
            // optionModel(
            //   LangText(context: context).getLocal()!.wholesale_products_ucf,
            //   'assets/icon/wholesale.png',
            //   const WholeSaleProducts(),
            // ),
          if (auction_addon_installed.$)
            Container(
              height: _auctionExpand ? 100 : 44,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 10.0),
              child: InkWell(
                onTap: () {
                  _auctionExpand = !_auctionExpand;
                  setState(() {});
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/icon/auction.png',
                                width: 16,
                                height: 16,
                                color: MyTheme.app_accent_border),
                            //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                            const SizedBox(
                              width: 26,
                            ),
                            Text(
                              "Credits",
                              style: TextStyle(
                                fontSize: 14,
                                color: MyTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          _auctionExpand
                              ? Icons.keyboard_arrow_down
                              : Icons.navigate_next_rounded,
                          size: 20,
                          color: MyTheme.app_accent_border,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: _auctionExpand,
                      child: Container(
                        padding: const EdgeInsets.only(left: 40),
                        width: DeviceInfo(context).getWidth(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () =>{},
                                //   OneContext().push(
                                // MaterialPageRoute(
                                //   builder: (_) => const AuctionProduct(),
                                // ),
                              //),
                              child: Row(
                                children: [
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      color: MyTheme.white,
                                    ),
                                  ),
                                  Text(
                                    '  Credits',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: MyTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () => {},
                              //     OneContext().push(
                              //   MaterialPageRoute(
                              //     builder: (_) => const AuctionOrder(),
                              //   ),
                              // ),
                              child: Row(
                                children: [
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      color: MyTheme.white,
                                    ),
                                  ),
                                  Text(
                                    '  Credits',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: MyTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icon/commission_history.png',
                          width: 16,
                          height: 16,
                          color: MyTheme.app_accent_border),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Transferts de stock",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Buttons(
              onPressed: () {
                //MyTransaction(context: context).push(const UploadFile());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.settings,
                        size: 16,
                        color: MyTheme.app_accent_border,
                      ),
                      //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                      const SizedBox(
                        width: 26,
                      ),
                      Text(
                        "Parametres",
                        style: TextStyle(fontSize: 14, color: MyTheme.white),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 20,
                    color: MyTheme.app_accent_border,
                  )
                ],
              ),
            ),
          ),
          if (product_query_activation.$)
            SizedBox(
              height: 40,
              child: Buttons(
                onPressed: () {
                  //MyTransaction(context: context).push(const ProductQueries());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.question_mark_rounded,
                          size: 16,
                          color: MyTheme.app_accent_border,
                        ),
                        //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                        const SizedBox(
                          width: 26,
                        ),
                        Text(
                          "Produits demandes",
                          style: TextStyle(fontSize: 14, color: MyTheme.white),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.navigate_next_rounded,
                      size: 20,
                      color: MyTheme.app_accent_border,
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  SizedBox optionModel(String title, String logo, Widget route) {
    return SizedBox(
      height: 40,
      child: Buttons(
        onPressed: () {
         // MyTransaction(context: context).push(route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(logo,
                    width: 16, height: 16, color: MyTheme.app_accent_border),
                const SizedBox(
                  width: 26,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: MyTheme.white),
                ),
              ],
            ),
            const Icon(
              Icons.navigate_next_rounded,
              size: 20,
              color: MyTheme.app_accent_border,
            )
          ],
        ),
      ),
    );
  }

  buildPosSystem() {
    return Container(
      height: _posExpand ? 100 : 44,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          _posExpand = !_posExpand;
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icon/pos_system.png',
                        width: 16,
                        height: 16,
                        color: MyTheme.app_accent_border),
                    //Image.asset('assets/icon/commission_history.png',width: 16,height: 16,color: MyTheme.app_accent_border),
                    const SizedBox(
                      width: 26,
                    ),
                    Text(
                      "POS System",
                      style: TextStyle(
                        fontSize: 14,
                        color: MyTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _posExpand
                      ? Icons.keyboard_arrow_down
                      : Icons.navigate_next_rounded,
                  size: 20,
                  color: MyTheme.app_accent_border,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _posExpand,
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                width: DeviceInfo(context).getWidth(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      //onTap: () => MyTransaction(context: context).push(const PosManager()),
                      child: Row(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              color: MyTheme.white,
                            ),
                          ),
                          Text(
                            '  Pos Manager',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      //onTap: () => MyTransaction(context: context).push(const PosConfig()),
                      child: Row(
                        children: [
                          Text(
                            '-',
                            style: TextStyle(
                              color: MyTheme.white,
                            ),
                          ),
                          Text(
                            '  Pos Configuration',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
