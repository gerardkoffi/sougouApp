import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one_context/one_context.dart';
import 'package:sougou_app/data/model/marques_model.dart';
import 'package:sougou_app/data/model/product_model.dart';
import 'package:sougou_app/ui/screens/productsScreen.dart';
import 'package:toast/toast.dart';

import '../../data/model/common_radio_model.dart';
import '../../data/model/file_model.dart';
import '../../data/repositories/product_repositories.dart';
import '../../helpers/shared_values.dart';
import '../../my_theme.dart';
import '../../utils/decoration.dart';
import '../custom/app_style.dart';
import '../custom/buttoms.dart';
import '../custom/commun_style.dart';
import '../custom/devices_info.dart';
import '../custom/dropdown_model.dart';
import '../custom/input_decoration.dart';
import '../custom/loading.dart';
import '../custom/my_widget.dart';
import '../custom/route_transaction.dart';
import '../custom/summer_note.dart';
import '../custom/toast_component.dart';


class UpdateProduct extends StatefulWidget {
  final bool siModifie;
  final bool siNouveau;
  final productId;

  const UpdateProduct({Key? key, this.siModifie = false, this.siNouveau = false, this.productId}) : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // double variables

  String _statAndEndTime = "Select Date";

  double mHeight = 0.0, mWidht = 0.0;
  int _selectedTabIndex = 0;
  bool isColorActive = false;
  bool isRefundable = false;
  bool isCashOnDelivery = false;
  bool isProductQuantityMultiply = false;

  // bool isFeatured = false;
  bool isTodaysDeal = false;


  List<CommonDropDownItem> marques = [];
  List<CommonDropDownItem> rayons = [];
  List<CommonDropDownItem> secteurs = [];
  List<CommonDropDownItem> origines = [];
  List<CommonDropDownItem> familles = [];
  List<CommonDropDownItem> sous_familles = [];

  List<CommonDropDownItem> videoType = [];
  List<CommonDropDownItem> addToFlashType = [];
  List<CommonDropDownItem> discountTypeList = [];
  List<CommonDropDownItem> colorList = [];
  List<CommonDropDownItem> selectedColors = [];


  List<CustomRadioModel> shippingConfigurationList = [];
  List<CustomRadioModel> stockVisibilityStateList = [];
  late CustomRadioModel selectedShippingConfiguration;
  late CustomRadioModel selectedstockVisibilityState;

  CommonDropDownItem? selectedMarque;
  CommonDropDownItem? selectedSecteur;
  CommonDropDownItem? selectedRayon;
  CommonDropDownItem? selectedOrigine;
  CommonDropDownItem? selectedSousFamille;
  CommonDropDownItem? selectedFamille;

  CommonDropDownItem? selectedVideoType;
  CommonDropDownItem? selectedAddToFlashType;
  CommonDropDownItem? selectedFlashDiscountType;
  CommonDropDownItem? selectedProductDiscountType;
  CommonDropDownItem? selectedColor;

  //Product value
  var mainCategoryId;
  List categoryIds = [];
  String?
  id,
      code,
      nom,
      photoUrl,
      description,
      libelleReduit,
      motDirecteur,
      marqueId,
      origineId,
      secteurId,
      rayonId,
      familleId,
      sousFamilleId,
      tmpMarque,
      tmpRayon,
      tmpOrigine,
      tmpFamille,
      tmpSousFamille,
      tmpSecteur,
      tmpImage;

  bool? statut,siReactive;
  bool isStatut = false;
  bool isReative = false;
  int colisage = 0;
  int poids = 0;
  bool isProductDetailsInit = false;
  Map choice_options = Map();
  FileInfo? thumbnailImage;
  ImagePicker pickImage = ImagePicker();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadImage(String productId) async {
    if (_selectedImage == null) return;

    try {
      print("📤 Upload de l'image...");

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_selectedImage!.path),
      });

      final response = await Dio().post(
        'http://207.180.210.22:9000/api/v1/produits/$productId/photo',
        data: formData,
        options: Options(
          headers: {
            "accept": "*/*",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print("✅ Image uploadée: ${response.statusCode}");
    } catch (e, s) {
      print("❌ Erreur d'upload : $e");
      print("📍 Stack: $s");
    }
  }



  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }


  DateTimeRange? dateTimeRange =
  DateTimeRange(start: DateTime.now(), end: DateTime.now());

  //Edit text controller
  TextEditingController  codeEditTextController = TextEditingController();
  TextEditingController  nomEditTextController = TextEditingController();
  TextEditingController  libelleReduitEditTextController = TextEditingController();
  TextEditingController  motDirecteurEditTextController = TextEditingController();
  TextEditingController  colisageEditTextController = TextEditingController();
  TextEditingController  poidsEditTextController = TextEditingController();
  TextEditingController  descriptionEditTextController = TextEditingController();
  GlobalKey<FlutterSummernoteState> productDescriptionKey = GlobalKey();

  getMarque() async {
    var marqueList = await ProductRepository().getMarque();

    // Nettoyer l'ancienne liste
    marques.clear();

    // Ajouter les marques récupérées à la liste
    marques.addAll(
      marqueList.map((element) =>
          CommonDropDownItem("${element.id}", element.nom)),
    );

    // Si une marque temporaire est définie, la restaurer dans selectedMarque
    if (tmpMarque != null && tmpMarque!.isNotEmpty && marques.isNotEmpty) {
      for (var element in marques) {
        if (element.key == tmpMarque) {
          selectedMarque = element;
          break;
        }
      }
    }

    setState(() {});
  }

  getRayon() async {
    var rayonsList = await ProductRepository().getRayon();

    rayons.clear();

    rayons.addAll(
      rayonsList.map((element) =>
          CommonDropDownItem("${element.id}", element.libelle)),
    );

    if (tmpRayon != null && tmpRayon!.isNotEmpty && rayons.isNotEmpty) {
      for (var element in rayons) {
        if (element.key == tmpRayon) {
          selectedRayon = element;
          break;
        }
      }
    }

    setState(() {});
  }

  getSecteur() async {
    var secteurList = await ProductRepository().getSecteur();

    secteurs.clear();

    secteurs.addAll(
      secteurList.map((element) =>
          CommonDropDownItem("${element.id}", element.libelle)),
    );

    if (tmpSecteur != null && tmpSecteur!.isNotEmpty && secteurs.isNotEmpty) {
      for (var element in secteurs) {
        if (element.key == tmpSecteur) {
          selectedSecteur = element;
          break;
        }
      }
    }

    setState(() {});
  }

  getOrigine() async {
    var origineList = await ProductRepository().getOrigine();

    origines.clear();

    origines.addAll(
      origineList.map((element) =>
          CommonDropDownItem("${element.id}", element.nom)),
    );

    if (tmpOrigine != null && tmpOrigine!.isNotEmpty && origines.isNotEmpty) {
      for (var element in origines) {
        if (element.key == tmpOrigine) {
          selectedOrigine = element;
          break;
        }
      }
    }

    setState(() {});
  }

  getFamille() async {
    var familleList = await ProductRepository().getFamille();

    familles.clear();

    familles.addAll(
      familleList.map((element) =>
          CommonDropDownItem("${element.id}", element.libelle)),
    );

    if (tmpFamille != null && tmpFamille!.isNotEmpty && familles.isNotEmpty) {
      for (var element in familles) {
        if (element.key == tmpFamille) {
          selectedFamille = element;
          break;
        }
      }
    }

    setState(() {});
  }


  getSousFamille() async {
    var sousFamilleList = await ProductRepository().getSousFamilles();

    sous_familles.clear();

    sous_familles.addAll(
      sousFamilleList.map((element) =>
          CommonDropDownItem("${element.id}", element.libelle)),
    );

    if (tmpSousFamille != null &&
        tmpSousFamille!.isNotEmpty &&
        sous_familles.isNotEmpty) {
      for (var element in sous_familles) {
        if (element.key == tmpSousFamille) {
          selectedSousFamille = element;
          break;
        }
      }
    }

    setState(() {});
  }


  fetchAll() {
    getFamille();
    getSecteur();
    getSousFamille();
    getOrigine();
    getRayon();
    getMarque();
  }


  setProductValues() async {

    nom = nomEditTextController.text.trim();
    description = descriptionEditTextController.text.trim();
    if (selectedMarque != null) marqueId = selectedMarque?.key;
    if (selectedOrigine != null) origineId = selectedOrigine?.key;
    if (selectedFamille != null) familleId = selectedFamille?.key;
    if (selectedSecteur != null) secteurId = selectedSecteur?.key;
    if (selectedSousFamille != null) sousFamilleId = selectedSousFamille?.key;
    if (selectedRayon != null) rayonId = selectedRayon?.key;
    code = codeEditTextController.text.trim();
    libelleReduit = libelleReduitEditTextController.text.trim();
    motDirecteur = motDirecteurEditTextController.text.trim();
    colisage = int.tryParse(colisageEditTextController.text.trim()) ?? 0;
    poids = int.tryParse(poidsEditTextController.text.trim()) ?? 0;
    statut = true;
    siReactive = isReative ? true : false;
    //setTaxes();
  }

  bool requiredFieldVerification() {
    if (nomEditTextController.text.trim().isEmpty) {
      _showToast("Nom du produit est requis");
      return false;
    } else if (selectedSecteur == null) {
      _showToast("Le secteur est requis");
      return false;
    } else if (codeEditTextController.text.trim().isEmpty) {
      _showToast("Code requis");
      return false;
    } else if (colisage < 0) {
      _showToast("Colisage doit etre different de 0");
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


  Future<void> submitProduct(String button) async {
    if (!requiredFieldVerification()) return;

    print("📍 setProductValues");
    await setProductValues();

    print("📍 Validation des champs obligatoires");
    if (code == null || nom == null || colisage == null || secteurId == null) {
      Loading.hide();
      ToastComponent.showDialog(
        "Certains champs obligatoires sont manquants",
        gravity: Toast.center,
      );
      return;
    }

    final postValue = {
      'code': code ?? '',
      'nom': nom ?? '',
      'description': description ?? '',
      'colisage': colisage ?? '',
      'poids': poids ?? '',
      'marqueId': marqueId,
      'origineId': origineId,
      'secteurId': secteurId,
      'rayonId': rayonId,
      'familleId': familleId,
      'sousFamilleId': sousFamilleId,
      'libelleReduit': libelleReduit ?? '',
      'motDirecteur': motDirecteur ?? '',
      'siModifie': widget.siModifie,
      'siNouveau': widget.siNouveau,
      'siReactive': siReactive ?? false,
      'photoUrl': _selectedImage?.path ?? '',
    };

    try {
      await Loading.show(context, timeout: Duration(seconds: 3));
      final postBody = jsonEncode(postValue);
      print("📤 Envoi postBody: $postBody");

      final response = await ProductRepository().updateProducts(postBody, widget.productId);

      print("✅ Réponse reçue: ${response.toString()}");
      Loading.hide();

      if (response.statusCode == '200' && response.corps != null) {
        ToastComponent.showDialog("Le produit enregistre", gravity: Toast.center);

        final productId = response.corps["id"]; // <- Assure-toi que ton backend retourne bien l'id
        if (productId != null) {
          print("🧪 corps: ${response.corps} (${response.corps.runtimeType})");
          await uploadImage(productId);
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

  setInitialValue(Produit produitInfo) {
    nomEditTextController.text = produitInfo.nom;
    descriptionEditTextController.text = produitInfo.description;
    tmpMarque = produitInfo.marqueId?.toString();
    getMarque();
    tmpFamille = produitInfo.familleId?.toString();
    getFamille();
    tmpOrigine = produitInfo.origineId?.toString();
    getOrigine();
    tmpRayon = produitInfo.rayonId?.toString();
    getRayon();
    tmpSecteur = produitInfo.secteurId?.toString();
    getSecteur();
    tmpSousFamille = produitInfo.sousFamilleId?.toString();
    getSousFamille();
    codeEditTextController.text = produitInfo.code;
    libelleReduitEditTextController.text = produitInfo.libelleReduit;
    motDirecteurEditTextController.text = produitInfo.motDirecteur;
    colisageEditTextController.text = produitInfo.colisage.toString();
    poidsEditTextController.text = produitInfo.poids.toString();
    siReactive = isReative ? true : false;
    tmpImage = produitInfo.photoUrl;
    // if (produitInfo.photoUrl!.isNotEmpty) {
    //   thumbnailImage = produitInfo.photoUrl != null ? FileInfo(file: produitInfo.photoUrl!) : null;
    // }
    setChange();
  }

  getProductCurrentValues() async {
    await Future.delayed(Duration.zero);

    await Loading.show(context);

    var productResponse = await ProductRepository().productEdit(id: widget.productId);

    Loading.hide();

    if (productResponse.statusCode == "200" && productResponse.corps != null) {
      isProductDetailsInit = true;
      setInitialValue(productResponse.corps!.produits[0]);// adapte ici suivant ta classe CorpsProduits
    } else {
      print("Erreur lors de la récupération du produit : ${productResponse.message}");
    }
  }




  @override
  void initState() {
    fetchAll();
    getProductCurrentValues();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    //Loading.setInstance(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: buildAppBar(context) as PreferredSizeWidget?,
        body: SingleChildScrollView(child:buildGeneral()),
        bottomNavigationBar: buildBottomAppBar(context),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyTheme.app_accent_color,
          ),
          width: mWidht / 3,
          child: Buttons(
            onPressed: () async {
              submitProduct("publish");
            },
            child: Text(
              "SAUVEGARDER",
              style: TextStyle(color: MyTheme.white,fontSize: 15,),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
      ),
    );
  }

  Widget buildGeneral() {
    return buildTabViewItem(
      "Informations du produit",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEditTextField(
            "Code du produit",
            "Code du produit",
            codeEditTextController,
            isMandatory: true,
          ),
          itemSpacer(),
          buildEditTextField(
            "Nom du produit",
            "Nom du produit",
            nomEditTextController,
            isMandatory: true,
          ),
          itemSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildDropDownField(
                    "Secteur",
                        (value) {
                      selectedSecteur = value;
                      setChange();
                    }, selectedSecteur, secteurs,isMandatory: true),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: _buildDropDownField(
                    "Famille",
                        (value) {
                      selectedFamille = value;
                      setChange();
                    }, selectedFamille, familles),
              ),
            ],
          ),
          itemSpacer(),
          Row(
            children: [
              Expanded(child: _buildDropDownField(
                  "Sous-Famille",
                      (value) {
                    selectedSousFamille = value;
                    setChange();
                  }, selectedSousFamille, sous_familles),),
              SizedBox(width: 10,),
              Expanded(child: _buildDropDownField(
                  "Rayon",
                      (value) {
                    selectedRayon = value;
                    setChange();
                  }, selectedRayon, rayons),),
            ],
          ),
          itemSpacer(),
          Row(
            children: [
              Expanded(child: _buildDropDownField(
                  "Marque",
                      (value) {
                    selectedMarque = value;
                    setChange();
                  }, selectedMarque, marques),),
              SizedBox(width: 10,),
              Expanded(child: _buildDropDownField(
                  "Origine",
                      (value) {
                    selectedOrigine = value;
                    setChange();
                  }, selectedOrigine, origines),),
            ],
          ),
          itemSpacer(),
          Row(
            children: [
              Expanded(child:  buildIntTextField(
                "Colisage",
                "Colisage",
                colisageEditTextController,
                isMandatory: true,
              ),),
              SizedBox(width: 10,),
              Expanded(child: buildIntTextField(
                  "Poids du produit (Kg)",
                  "Poids (Kg)",
                  poidsEditTextController),),
            ],
          ),
          itemSpacer(),
          buildEditTextField(
            "Description du produit",
            "Description du produit",
            descriptionEditTextController,
            isMandatory: false,
          ),
          itemSpacer(),
          buildEditTextField(
            "Libelle de reduction",
            "Libelle de reduction",
            libelleReduitEditTextController,
            isMandatory: true,
          ),
          itemSpacer(),
          buildEditTextField(
            "Mot directeur",
            "Libelle de reduction",
            motDirecteurEditTextController,
            isMandatory: true,
          ),
          itemSpacer(),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 180,
              //margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey),
                image: _selectedImage != null
                    ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _selectedImage == null
                  ? Center(
                  child: Image.asset("assets/icon/picture.png")
              )
                  : null,
            ),
          ),
          itemSpacer(),
        ],
      ),
    );
  }

  Widget buildVatTax(title, TextEditingController controller, onChangeDropDown,
      CommonDropDownItem? selectedDropdown, List<CommonDropDownItem> iteams) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          SizedBox(
            width: (mWidht / 2) - 25,
            child: buildEditTextField(title, "0", controller),
          ),
          Spacer(),
          _buildDropDownField("", (newValue) {
            onChangeDropDown(newValue);
            setChange();
          }, selectedDropdown, iteams, width: (mWidht / 2) - 25),
        ],
      ),
    );
  }



  Widget buildTabViewItem(String title, Widget children) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppStyles.itemMargin,
        right: AppStyles.itemMargin,
        top: AppStyles.itemMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.font_grey),
            ),
          const SizedBox(
            height: 16,
          ),
          children,
        ],
      ),
    );
  }


  Widget buildGroupItems(groupTitle, Widget children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildGroupTitle(groupTitle),
        itemSpacer(height: 14.0),
        children,
      ],
    );
  }

  Text buildGroupTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }


  Widget buildShowSelectedOptions(
      List<CommonDropDownItem> options, dynamic remove) {
    return SizedBox(
      width: DeviceInfo(context).getWidth() - 34,
      child: Wrap(
        children: List.generate(
            options.length,
                (index) => Container(
                decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: MyTheme.grey_153)),
                constraints: BoxConstraints(
                    maxWidth: (DeviceInfo(context).getWidth() - 50) / 4),
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                child: Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 20, top: 5, bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth:
                            (DeviceInfo(context).getWidth() - 50) / 4),
                        child: Text(
                          options[index].value.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        )),
                    Positioned(
                      right: 2,
                      child: InkWell(
                        onTap: () {
                          remove(index);
                        },
                        child: Icon(Icons.highlight_remove,
                            size: 15, color: MyTheme.red),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  Widget smallTextForMessage(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
    );
  }

  setChange() {
    setState(() {});
  }

  Widget itemSpacer({double height = 24}) {
    return SizedBox(
      height: height,
    );
  }

  Widget _buildDropDownField(String title, dynamic onchange,
      CommonDropDownItem? selectedValue, List<CommonDropDownItem> itemList,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title, _buildDropDown(onchange, selectedValue, itemList, width: width),
        isMandatory: isMandatory);
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

  Widget _buildColorDropDown(dynamic onchange,
      CommonDropDownItem? selectedValue, List<CommonDropDownItem> itemList,
      {double? width}) {
    return Container(
      height: 46,
      width: width ?? mWidht,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: MDecoration.decoration1(),
      child: DropdownButton<CommonDropDownItem>(
        menuMaxHeight: 300,
        isDense: true,
        underline: Container(),
        isExpanded: true,
        onChanged: (CommonDropDownItem? value) {
          onchange(value);
        },
        icon: const Icon(Icons.arrow_drop_down),
        value: selectedValue,
        items: itemList
            .map(
              (value) => DropdownMenuItem<CommonDropDownItem>(
            value: value,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Color(
                          int.parse(value.key!.replaceAll("#", "0xFF"))),
                      borderRadius: BorderRadius.circular(4)),
                ),
                Text(
                  value.value!,
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildFlatDropDown(String title, dynamic onchange,
      CommonDropDownItem selectedValue, List<CommonDropDownItem> itemList,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title,
        Container(
          height: 46,
          width: width ?? mWidht,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyTheme.app_accent_color_extra_light),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: DropdownButton<CommonDropDownItem>(
            isDense: true,
            underline: Container(),
            isExpanded: true,
            onChanged: (value) {
              onchange(value);
            },
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedValue,
            items: itemList
                .map(
                  (value) => DropdownMenuItem<CommonDropDownItem>(
                value: value,
                child: Text(
                  value.value!,
                ),
              ),
            )
                .toList(),
          ),
        ),
        isMandatory: isMandatory);
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


  Widget buildFlatEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false}) {
    return Container(
      child: buildCommonSingleField(
        title,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyTheme.app_accent_color_extra_light),
          width: DeviceInfo(context).getWidth(),
          height: 45,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecorations.buildInputDecoration_1(
                hint_text: hint,
                borderColor: MyTheme.noColor,
                hintTextColor: MyTheme.grey_153),
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
          height: 10,
        ),
        child,
      ],
    );
  }

  Text buildFieldTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }



  buildSwitchField(String title, value, onChanged, {isMandatory = false}) {
    return Row(
      children: [
        if (title.isNotEmpty) buildFieldTitle(title),
        if (isMandatory)
          Text(
            " *",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: MyTheme.red),
          ),
        const Spacer(),
        Container(
          height: 30,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MyTheme.green,
          ),
        ),
      ],
    );
  }

  Future<DateTimeRange?> _buildPickDate() async {
    DateTimeRange? p;
    p = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2050),
        builder: (context, child) {
          return Container(
            width: 500,
            height: 500,
            child: DateRangePickerDialog(
              initialDateRange:
              DateTimeRange(start: DateTime.now(), end: DateTime.now()),
              saveText: "Selectionnez",
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(2050),
            ),
          );
        });

    return p;
  }

  Widget tabBarDivider() {
    return const SizedBox(
      width: 1,
      height: 50,
    );
  }

  Container buildTopTapBarItem(String text, int index) {
    return Container(
        height: 50,
        width: 100,
        color: _selectedTabIndex == index
            ? MyTheme.app_accent_color
            : MyTheme.app_accent_color.withOpacity(0.5),
        child: Buttons(
            onPressed: () {
              _selectedTabIndex = index;
              setState(() {});
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white),
            )));
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
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
                Navigator.pop(context);
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
            "Modifier un produit",
            style: MyTextStyle().appbarText(),
          ),
        ],
      ),
    );
  }
}


class MHeight {
  double? _height;

  double? get height => _height;

  set height(double? value) {
    _height = value;
  }
}
