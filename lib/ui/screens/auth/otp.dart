import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/ui/screens/auth/register.dart';
import '../../../cubit/get_otpgenerate_cubit.dart';
import '../../custom/my_appbar.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneController.text = prefs.getString('phoneNumber') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listener: (context, state) async {
        if (state is OTPVerifySuccess) {
          if (state.otpResponse.codeText == "VALID_OTP") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage2(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Code OTP incorrect. Veuillez réessayer.")),
            );
          }
        } else if (state is OTPStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Code OTP incorrect")),
          );
        } else if (state is OTPStateInProgress) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is OTPStateInit) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
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
                          child: Image.asset(
                            'assets/icons/logo1.png',
                            width: 200,
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
                          'Entrer le code OTP.',
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
                          controller: _otpController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Code OTP',
                            hintText: 'Exemple : 123456',
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
                              String otpCode = _otpController.text.trim();
                              if (phoneNumber.isNotEmpty && otpCode.isNotEmpty) {
                                // Envoi de la demande OTP
                                context.read<OTPCubit>().verifyOtp(phoneNumber, otpCode);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Entrez un code valide")),
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
                              'VERIFIER',
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
                            style: const TextStyle(color: Colors.white, fontSize: 12),
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
      ),
    );
  }
}
