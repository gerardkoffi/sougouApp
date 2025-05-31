import 'dart:convert';

class Magasin {
  final String id;
  final String code;
  final String nom;
  final String adresse;
  final String contact;
  final String logoUrl;
  final String email;

  Magasin({
    required this.id,
    required this.code,
    required this.nom,
    required this.adresse,
    required this.contact,
    required this.logoUrl,
    required this.email,
  });

  factory Magasin.fromJson(Map<String, dynamic> json) {
    return Magasin(
      id: json['id'],
      code: json['code'],
      nom: json['nom'],
      adresse: json['adresse'],
      contact: json['contact'],
      logoUrl: json['logoUrl'],
      email: json['email'],
    );
  }
}

class UserModel {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String login;
  final bool phoneVerified;
  final Magasin defaultMagasin;
  final List<Magasin> magasins;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.login,
    required this.phoneVerified,
    required this.defaultMagasin,
    required this.magasins,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      login: json['login'],
      phoneVerified: json['phoneVerified'],
      defaultMagasin: Magasin.fromJson(json['defaultMagasin']),
      magasins: (json['magasins'] as List)
          .map((mag) => Magasin.fromJson(mag))
          .toList(),
    );
  }
}

class LoginResponse {
  final String statusCode;
  final String codeText;
  final String message;
  final String token;

  LoginResponse({
    required this.statusCode,
    required this.codeText,
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? '',
      codeText: json['codeText'] ?? '',
      message: json['message'] ?? '',
      token: json['corps'] ?? '',
    );
  }
}