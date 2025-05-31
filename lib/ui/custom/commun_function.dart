import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'buttoms.dart';

class CommonFunctions {
  BuildContext context;

  CommonFunctions(this.context);

  appExitDialog() {
    showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            content: Text("Voulez vous fermer l'app?"),
            actions: [
              Buttons(
                  onPressed: () {
                    Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                  },
                  child: Text("Oui")),
              Buttons(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Non")),
            ],
          ),
        ));
  }
}
