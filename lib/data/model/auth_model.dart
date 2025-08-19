import 'dart:convert';

class Magasin {
  final String id;
  final String code;
  final String nom;
  final String ville;
  final String adresse;
  final String contact;
  final String logoUrl;
  final String email;
  final List<String> userIds;
  final List<String> assortimentIds;

  Magasin({
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

  factory Magasin.fromJson(Map<String, dynamic> json) {
    return Magasin(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      nom: json['nom'] ?? '',
      ville: json['ville'] ?? '',
      adresse: json['adresse'] ?? '',
      contact: json['contact'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      email: json['email'] ?? '',
      userIds: List<String>.from(json['userIds'] ?? []),
      assortimentIds: List<String>.from(json['assortimentIds'] ?? []),
    );
  }
}


class UserModel {
  final String id;
  final String? nom;
  final String? prenom;
  final String telephone;
  final String login;
  final String? password;
  final String? otp;
  final bool phoneVerified;
  final int? otpAttempts;
  final int? otpGenerations;
  final int? lastOtpGenerationTime;
  final Magasin? defaultMagasin;
  final List<Magasin>? magasins;

  UserModel({
    required this.id,
    this.nom,
    this.prenom,
    required this.telephone,
    required this.login,
    this.password,
    this.otp,
    required this.phoneVerified,
    this.otpAttempts,
    this.otpGenerations,
    this.lastOtpGenerationTime,
    this.defaultMagasin,
    this.magasins,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'] ?? '',
      login: json['login'] ?? '',
      password: json['password'],
      otp: json['otp'],
      phoneVerified: json['phoneVerified'] ?? false,
      otpAttempts: json['otpAttempts'],
      otpGenerations: json['otpGenerations'],
      lastOtpGenerationTime: json['lastOtpGenerationTime'],
      defaultMagasin: json['defaultMagasin'] != null
          ? Magasin.fromJson(json['defaultMagasin'])
          : null,
      magasins: json['magasins'] != null
          ? List<Magasin>.from(
          (json['magasins'] as List).map((e) => Magasin.fromJson(e)))
          : null,
    );
  }
}


class LoginResponse {
  final String statusCode;
  final String codeText;
  final String message;
  final String token;
  //final UserModel corps;

  LoginResponse({
    required this.statusCode,
    required this.codeText,
    required this.message,
    required this.token,
    //required this.corps,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? '',
      codeText: json['codeText'] ?? '',
      message: json['message'] ?? '',
      token: json['corps'] ?? '',
      //corps: UserModel.fromJson(json['corps']),
    );
  }
}

class LogoutResponse {
  final String statusCode;
  final String codeText;
  final String? message;

  LogoutResponse({
    required this.statusCode,
    required this.codeText,
    this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      statusCode: json['statusCode'] ?? '',
      codeText: json['codeText'] ?? '',
      message: json['message'],
    );
  }
}
