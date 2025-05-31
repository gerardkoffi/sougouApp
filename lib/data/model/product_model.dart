import 'dart:convert';

import 'package:sougou_app/data/model/sous_famille_model.dart';
import 'marques_model.dart';
import 'origine_model.dart';

// Fonction pour convertir une réponse JSON en objet `ProductsResponse`
ProductsResponse productsResponseFromJson(String str) =>
    ProductsResponse.fromJson(json.decode(str));

// Fonction pour convertir un objet `ProductsResponse` en JSON
String productsResponseToJson(ProductsResponse data) =>
    json.encode(data.toJson());

class ProductsResponse {
  ProductsResponse({
    this.statusCode,
    this.codeText,
    this.message,
    this.corps,
  });

  String? statusCode;
  String? codeText;
  String? message;
  CorpsProduits? corps;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
    statusCode: json["statusCode"]?.toString(),
    codeText: json["codeText"],
    message: json["message"],
    corps: json["corps"] != null ? CorpsProduits.fromJson(json["corps"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "codeText": codeText,
    "message": message,
    "corps": corps?.toJson(),
  };

  @override
  String toString() {
    return 'ProductsResponse(statusCode: $statusCode, codeText: $codeText, message: $message, corps: $corps)';
  }
}

class CorpsProduits {
  final List<Produit> produits;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  CorpsProduits({
    required this.produits,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  factory CorpsProduits.fromJson(Map<String, dynamic> json) => CorpsProduits(
    produits: List<Produit>.from(json["produits"].map((x) => Produit.fromJson(x))),
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "produits": produits.map((x) => x.toJson()).toList(),
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };

  @override
  String toString() {
    return 'CorpsProduits(produits: $produits, totalItems: $totalItems, totalPages: $totalPages, currentPage: $currentPage)';
  }
}


class Produit {
  final String id;
  final String code;
  final String nom;
  final String description;
  final bool statut;
  final int colisage;
  final int poids;
  final String? marqueId;
  final Marque? marque;
  final String? origineId;
  final Origine? origine;
  final String? secteurId;
  final Secteur? secteur;
  final String? rayonId;
  final Rayon? rayon;
  final String? familleId;
  final Famille? famille;
  final String? sousFamilleId;
  final SousFamille? sousFamille;
  final String libelleReduit;
  final String motDirecteur;
  final bool siModifie;
  final bool siNouveau;
  final bool siReactive;
  final String? photoUrl;

  Produit({
    required this.id,
    required this.code,
    required this.nom,
    required this.description,
    required this.statut,
    required this.colisage,
    required this.poids,
    this.marqueId,
    this.marque,
    this.origineId,
    this.origine,
    this.secteurId,
    this.secteur,
    this.rayonId,
    this.rayon,
    this.familleId,
    this.famille,
    this.sousFamilleId,
    this.sousFamille,
    required this.libelleReduit,
    required this.motDirecteur,
    required this.siModifie,
    required this.siNouveau,
    required this.siReactive,
    this.photoUrl,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'],
      code: json['code'],
      nom: json['nom'],
      description: json['description'],
      statut: json['statut'],
      colisage: json['colisage'],
      poids: json['poids'],
      marqueId: json['marqueId'],
      marque:
      json['marque'] != null ? Marque.fromJson(json['marque']) : null,
      origineId: json['origineId'],
      origine:
      json['origine'] != null ? Origine.fromJson(json['origine']) : null,
      secteurId: json['secteurId'],
      secteur:
      json['secteur'] != null ? Secteur.fromJson(json['secteur']) : null,
      rayonId: json['rayonId'],
      rayon: json['rayon'] != null ? Rayon.fromJson(json['rayon']) : null,
      familleId: json['familleId'],
      famille:
      json['famille'] != null ? Famille.fromJson(json['famille']) : null,
      sousFamilleId: json['sousFamilleId'],
      sousFamille: json['sousFamille'] != null
          ? SousFamille.fromJson(json['sousFamille'])
          : null,
      libelleReduit: json['libelleReduit'],
      motDirecteur: json['motDirecteur'],
      siModifie: json['siModifie'],
      siNouveau: json['siNouveau'],
      siReactive: json['siReactive'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'description': description,
      'statut': statut,
      'colisage': colisage,
      'poids': poids,
      'marqueId': marqueId,
      'marque': marque?.toJson(),
      'origineId': origineId,
      'origine': origine?.toJson(),
      'secteurId': secteurId,
      'secteur': secteur?.toJson(),
      'rayonId': rayonId,
      'rayon': rayon?.toJson(),
      'familleId': familleId,
      'famille': famille?.toJson(),
      'sousFamilleId': sousFamilleId,
      'sousFamille': sousFamille?.toJson(),
      'libelleReduit': libelleReduit,
      'motDirecteur': motDirecteur,
      'siModifie': siModifie,
      'siNouveau': siNouveau,
      'siReactive': siReactive,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'Produit(code: $code, nom: $nom)';
  }
}
