
import 'package:flutter/material.dart';
import 'package:sougou_app/ui/screens/auth/otp.dart';
import 'package:sougou_app/ui/screens/auth/register.dart';



class MyHomePage4 extends StatefulWidget {
  const MyHomePage4({Key? key}) : super(key: key);

  @override
  State<MyHomePage4> createState() => _MyHomePage4State();
}

class _MyHomePage4State extends State<MyHomePage4> {
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
              padding: const EdgeInsets.symmetric(vertical: 135),
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
                          width: 200,
                          //height: 200,
                        ),
                      ),
                      //const SizedBox(height: 8),
                      Text(
                        'Organisez mieux, vendez plus !',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'Reinitialisez voutre mot de passe',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Champ de texte pour le numéro de téléphone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe*', // Label ajouté ici
                          hintText: 'Exemple : sougou@gmail.com',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
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
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe*', // Label ajouté ici
                          hintText: 'Exemple : sougou@gmail.com',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),
                          hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey), // Bord par défaut
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'REINITIALISER',
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
