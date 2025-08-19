
import 'dart:convert';

List<MagasinModel> magasinListFromJson(String str) {
  final data = jsonDecode(str);
  final List list = data['corps'];
  return list.map((e) => MagasinModel.fromJson(e)).toList();
}

class MagasinsResponse {
  String? statusCode;
  String? codeText;
  String? message;
  List<MagasinModel>? corps;

  MagasinsResponse({
    this.statusCode,
    this.codeText,
    this.message,
    this.corps,
  });

  factory MagasinsResponse.fromJson(Map<String, dynamic> json) {
    return MagasinsResponse(
      statusCode: json["statusCode"],
      codeText: json["codeText"],
      message: json["message"],
      corps: (json["corps"] as List)
          .map((e) => MagasinModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "codeText": codeText,
    "message": message,
    "corps": corps?.map((e) => e.toJson()).toList(),
  };
}


class MagasinModel {
  final String id;
  final String code;
  final String nom;
  final String ville;
  final String adresse;
  final String contact;
  final String logoUrl;
  final String email;
  final List<dynamic> userIds;
  final List<dynamic> assortimentIds;

  MagasinModel({
    required this.id,
    required this.code,
    required this.nom,
    required this.ville,
    required this.adresse,
    required this.contact,
    required this.logoUrl,
    required this.email,
    required this.userIds,
    required this.assortimentIds,
  });

  factory MagasinModel.fromJson(Map<String, dynamic> json) {
    return MagasinModel(
      id: json['id'].toString(),
      code: json['code'] ?? '',
      nom: json['nom'] ?? '',
      ville: json['ville'] ?? '',
      adresse: json['adresse'] ?? '',
      contact: json['contact'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      email: json['email'] ?? '',
      userIds: json['userIds'] ?? [],
      assortimentIds: json['assortimentIds'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'ville': ville,
      'adresse': adresse,
      'contact': contact,
      'logoUrl': logoUrl,
      'email': email,
      'userIds': userIds,
      'assortimentIds': assortimentIds,
    };
  }
}

