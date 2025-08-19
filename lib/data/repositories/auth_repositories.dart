import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/utils/api.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<UserModel> decodeUserFromToken(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Mappe manuellement le UserModel
    return UserModel(
      id: decodedToken['userId'],
      nom: decodedToken['nom'],
      prenom: decodedToken['prenom'], // Pas disponible ici
      telephone: decodedToken['telephone'], // Pas dans le token
      login: decodedToken['sub'], // ou autre champ
      phoneVerified: true, // à ajuster selon ton besoin
      defaultMagasin: Magasin(
        id: decodedToken['defaultMagasin']['id'].toString(),
        code: decodedToken['defaultMagasin']['code'],
        nom: decodedToken['defaultMagasin']['nom'],
        adresse: decodedToken['defaultMagasin']['adresse'],
        contact: "", // Pas dispo dans le token
        logoUrl: "", // idem
        email: decodedToken['defaultMagasin']['email'],
        ville: '',
        assortimentIds: [],
        userIds: [],   // idem
      ),
      magasins: [], // pas inclus dans ce token
    );
  }

  void inspectToken(String token) {
    Map<String, dynamic> decoded = JwtDecoder.decode(token);

    print("Contenu du token JWT :");
    decoded.forEach((key, value) {
      print("$key : $value");
    });
  }


 /* Future<LoginResponse> login(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');
    final code = "+225";

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("Numéro de téléphone introuvable !");
    }

    try {
      final response = await _dio.post(
        ApiSougou.getLogin,
        data: {
          "login": code+phoneNumber,
          "password": password,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        print("Mon Token::::::::::::::::::::::::"+loginResponse.token);
        // 🔥 Sauvegarder le token dans SharedPreferences
        await _saveToken(loginResponse.token);

        inspectToken(loginResponse.token);


        return loginResponse;
      } else {
        throw Exception("Erreur ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la connexion: $e");
    }
  }*/

  Future<LoginResponse> login(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');
    final code = "+225";

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("Numéro de téléphone introuvable !");
    }

    try {
      final response = await _dio.post(
        ApiSougou.getLogin,
        data: {
          "login": code + phoneNumber,
          "password": password,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        final token = loginResponse.token;

        print("Mon Token::::::::::::::::::::::::$token");

        // 🔥 Sauvegarde du token
        await _saveToken(token);

        // 🔍 Décodage du token et sauvegarde des données utilisateur
        final decoded = JwtDecoder.decode(token);

        // Sauvegarde des infos utilisateur
        await prefs.setString('user_nom', decoded['nom'] ?? '');
        await prefs.setString('user_prenom', decoded['prenom'] ?? '');
        await prefs.setString('user_telephone', decoded['telephone'] ?? '');
        await prefs.setBool('user_phone_verified', decoded['phoneVerified'] ?? false);

        if (decoded.containsKey('defaultMagasin')) {
          await prefs.setString('user_default_magasin', jsonEncode(decoded['defaultMagasin']));
        }

        return loginResponse;
      } else {
        throw Exception("Erreur ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la connexion: $e");
    }
  }


  // 🔹 Fonction pour sauvegarder le token dans SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // 🔹 Fonction pour récupérer le token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }


  Future<LogoutResponse> getLogoutResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');
    if (accessToken == null) {
      throw Exception("Token introuvable. Veuillez vous reconnecter.");
    }

    final String url = ApiSougou.getLogout;
    print("Mon token:::::::"+accessToken);
    try {
      final response = await _dio.post(
        url,
        data: {}, // body vide JSON
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "*/*",
          },
          validateStatus: (status) => true, // pour capturer le body même en 500
        ),
      );
      print("Code réponse : ${response.statusCode}");
      print("Données reçues : ${response.data}");


      if (response.statusCode == 200) {
        return LogoutResponse.fromJson(response.data);
      } else {
        throw Exception("Erreur ${response.statusCode} lors de la déconnexion.");
      }
    } catch (e) {
      throw Exception("Erreur lors de la requête de déconnexion: $e");
    }
  }

}
