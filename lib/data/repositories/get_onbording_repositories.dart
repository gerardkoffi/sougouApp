import 'package:sougou_app/data/model/get_onbording_model.dart';

class GetOnbording {
  static Future<List<GetOnboardingList>> GetOnbordingrepo() async {
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulation d'un délai réseau

      // Données en dur simulant la réponse d'une API
      List<Map<String, dynamic>> mockData = [
        {
          "id": 1,
          "title": "SOUGOU PDV APP",
          "image": "assets/icons/logo1.png",
          "description": "Vous avez une quincaillerie, boutique, superette, maquis, bar, restaurant...",
          "status": 1,
          "created_at": "2025-03-20T10:00:00Z",
          "updated_at": "2025-03-20T10:00:00Z"
        },
        {
          "id": 2,
          "title": "CONÇU POUR VOUS",
          "image": "assets/icons/logo1.png",
          "description": "Une interface fluide et intuitive pour vous simplifier la vie.",
          "status": 1,
          "created_at": "2025-03-20T10:05:00Z",
          "updated_at": "2025-03-20T10:05:00Z"
        },
        {
          "id": 3,
          "title": "GESTION FACILE",
          "image": "assets/icons/logo1.png",
          "description": "Gérez votre entreprise à distance et sur site de manière optimale et professionnelle.",
          "status": 1,
          "created_at": "2025-03-20T10:10:00Z",
          "updated_at": "2025-03-20T10:10:00Z"
        },
      ];

      // Convertir les données mockées en liste d'objets GetOnboardingList
      return mockData.map((e) => GetOnboardingList.fromJson(e)).toList();
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
      throw 'Erreur lors du chargement des données';
    }
  }
}
