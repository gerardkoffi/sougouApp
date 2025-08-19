import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sougou_app/ui/screens/home/dashboard.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../data/model/auth_model.dart';
import '../../custom/my_appbar.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? _phoneNumber;
  bool _isLoading = false;

  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phoneNumber');
    });
  }

  void _onLoginPressed() {
    String password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      context.read<AuthCubit>().login(password).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer votre mot de passe.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Connexion réussie !")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>Main(),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Mot de passe incorrect")),
          );
        } else if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/back.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.4)),
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
                                children: [
                                  const SizedBox(height: 30),
                                  Center(
                                    child: Image.asset(
                                      'assets/icons/logo1.png',
                                      width: 250,
                                    ),
                                  ),
                                  const Text(
                                    'Organisez mieux, vendez plus !',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Entrer votre mot de passe pour vous connecter.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Le mot de passe est requis';
                                            } else if (value.length < 6) {
                                              return 'Le mot de passe doit contenir au moins 6 caractères';
                                            } else if (!RegExp(r'(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                                              return 'Inclure au moins 1 majuscule et 1 chiffre';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Mot de passe',
                                            hintText: 'Votre mot de passe',
                                            labelStyle: const TextStyle(
                                                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _onLoginPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text(
                                        'SE CONNECTER',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
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
