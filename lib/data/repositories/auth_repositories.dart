import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/utils/api.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final Dio _dio = Dio();

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
          "login": code+phoneNumber,
          "password": password,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // 🔥 Sauvegarder le token dans SharedPreferences
        await _saveToken(loginResponse.token);

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


  Future<LoginResponse> getLogoutResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token'); // Récupération du token
    if (accessToken == null) {
      throw Exception("Token introuvable. Veuillez vous reconnecter.");
    }

    final String url = ApiSougou.getLogout;
    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken", // Mettre ici au lieu du body
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception("Erreur ${response.statusCode} lors de la déconnexion.");
      }
    } catch (e) {
      throw Exception("Erreur lors de la requête de déconnexion: $e");
    }
  }

}
