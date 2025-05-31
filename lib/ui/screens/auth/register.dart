
import 'package:flutter/material.dart';
import 'package:sougou_app/ui/screens/auth/pwdforget.dart';



class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key}) : super(key: key);

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image d'arrière-plan
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/back.jpeg'), // Remplacez par votre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Superposition pour le contenu
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Contenu principal
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Center(
                        child: Image.asset('assets/icons/logo1.png',
                          width: 170,
                          //height: 200,
                        ),
                      ),
                      //const SizedBox(height: 8),
                      Text(
                        'Organisez mieux, vendez plus !',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'Completez vos informations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Champ de texte pour le numéro de téléphone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Nom*', // Label ajouté ici
                          hintText: 'Exemple : Kouame',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // Réduit la hauteur du champ
                            horizontal: 12, // Marges latérales
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord actif
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey, width: 2), // Bord lors du focus
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Prenoms*', // Label ajouté ici
                          hintText: 'Exemple : Jean-Luc',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // Réduit la hauteur du champ
                            horizontal: 12, // Marges latérales
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord actif
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey, width: 2), // Bord lors du focus
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Adresse Email*', // Label ajouté ici
                          hintText: 'Exemple : jeanluc@gmail.com',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // Réduit la hauteur du champ
                            horizontal: 12, // Marges latérales
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord actif
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey, width: 2), // Bord lors du focus
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Nom de l'entreprise*", // Label ajouté ici
                          hintText: 'Exemple : SOUGOU',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // Réduit la hauteur du champ
                            horizontal: 12, // Marges latérales
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord actif
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey, width: 2), // Bord lors du focus
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Bouton "Continuer"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Action au clic
                            //String phoneNumber = _phoneController.text;
                            //print('Numéro saisi : $phoneNumber');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage3(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'CONFIRMER',
                            style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Retour a la connexion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Conditions d'utilisation
                      Text.rich(
                        TextSpan(
                          text: 'En créant un compte, vous acceptez nos ',
                          style: const TextStyle(color: Colors.white,fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'conditions d\'utilisation',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' et '),
                            TextSpan(
                              text: 'politiques de confidentialité.',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
