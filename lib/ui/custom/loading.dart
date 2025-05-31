import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class Loading {
  static BuildContext? _dialogContext;

  static Future<void> show(BuildContext context, {Duration timeout = const Duration(seconds: 30)}) async {
    print("📍 Loading show");

    // Timer pour auto-fermer après `timeout`
    Future.delayed(timeout, () {
      if (_dialogContext != null) {
        print("⏳ Fermeture automatique du chargement après timeout");
        hide();
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false, // empêche la fermeture manuelle
      builder: (BuildContext context) {
        _dialogContext = context;
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Veuillez patienter..."),
            ],
          ),
        );
      },
    );
  }

  static void hide() {
    try {
      if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }
    } catch (e) {
      print("❌ Erreur lors du hide(): $e");
    }
  }
}

class OneContextLoading {
  static BuildContext? _dialogContext;

  static Future<void> show({Duration timeout = const Duration(seconds: 30)}) async {
    if (!OneContext.hasContext) return;

    Future.delayed(timeout, () {
      if (_dialogContext != null) {
        print("⏳ Fermeture automatique du chargement (OneContext)");
        hide();
      }
    });

    await OneContext().showDialog(
      builder: (BuildContext context) {
        _dialogContext = context;
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("Veuillez patienter..."),
            ],
          ),
        );
      },
    );
  }

  static void hide() {
    try {
      if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }
    } catch (e) {
      print("❌ Erreur lors du OneContextLoading.hide(): $e");
    }
  }
}
