import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/ui/screens/auth/otp.dart';
import 'package:sougou_app/ui/screens/auth/password.dart';
import '../../../cubit/get_otpgenerate_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber(); // Charger le numéro enregistré s'il existe
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneController.text = prefs.getString('phoneNumber') ?? '';
    });
  }

  Future<void> _savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listener: (context, state) async {
        if (state is OTPGenerateSuccess) {
          String phoneNumber = _phoneController.text.trim();
          await _savePhoneNumber(phoneNumber); // Enregistrer le numéro
          // Lorsque OTP est généré avec succès
          if (state.otpResponse.codeText == "OTP_SENT") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordPage(),
              ),
            );
          }
        } else if (state is OTPStateError) {
          // Afficher une erreur si l'OTP échoue
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Nombre maximum de génération de OTP atteint. Veuillez réessayer plus tard")),
          );
        } else if (state is OTPStateInProgress) {
          // Si l'OTP est en cours de génération
          setState(() {
            _isLoading = true;
          });
        } else if (state is OTPStateInit) {
          // État initial où aucune action n'a encore été effectuée
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Image d'arrière-plan
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/back.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Superposition pour le contenu
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Container(
                      color: Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            // Logo
                            Center(
                              child: Image.asset(
                                'assets/icons/logo1.png',
                                width: 250,
                              ),
                            ),
                            Text(
                              'Organisez mieux, vendez plus !',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Entrer votre numero de telephone pour vous connecter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Champ de texte pour le numéro de téléphone
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Numéro de téléphone',
                                hintText: 'Exemple : +2250700000000',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey, width: 2),
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
                                onPressed: _isLoading
                                    ? null
                                    : () {

                                  String phoneNumber = _phoneController.text.trim();
                                  if (phoneNumber.isNotEmpty) {
                                    // Envoi de la demande OTP
                                    String code = "+225";
                                    context.read<OTPCubit>().generateOtp(code+phoneNumber);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Entrez un numéro valide")),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  'CONTINUER',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Conditions d'utilisation
                            Text.rich(
                              TextSpan(
                                text: 'En créant un compte, vous acceptez nos ',
                                style: const TextStyle(color: Colors.black38, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: 'conditions d\'utilisation',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: ' et '),
                                  TextSpan(
                                    text: 'politiques de confidentialité.',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            )
          ),
          ],
        ),
      ),
    );
  }
}
