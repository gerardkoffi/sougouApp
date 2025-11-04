import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sougou_app/my_theme.dart';

import '../../../utils/pos_btn.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final String receiptNumber = "REC-2025-001";
  final String date = "08/08/2025";
  final String paymentMethod = "Cash";

  List<Map<String, dynamic>> items = [
    {"name": "Produit A", "qty": 2, "price": 1500},
    {"name": "Produit B", "qty": 1, "price": 2500},
    {"name": "Produit C", "qty": 3, "price": 1000},
    {"name": "Produit D", "qty": 1, "price": 3000},
    {"name": "Produit E", "qty": 2, "price": 2000},
    {"name": "Produit F", "qty": 1, "price": 1500},
    {"name": "Produit G", "qty": 3, "price": 2500},
    {"name": "Produit H", "qty": 2, "price": 1000},
    {"name": "Produit I", "qty": 1, "price": 3000},
  ];

  /// Calcule le sous-total
  int get subTotal => items.fold<int>(
    0,
        (sum, item) => sum + (item["qty"] as int) * (item["price"] as int),
  );

  /// Remise fixe (10%)
  double get discount => subTotal * 0.1;

  /// Total final = sous-total - remise
  double get total => subTotal - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reçu d'achat")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Ligne QR Code + Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo (remplace l'AssetImage par ton logo)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/icons/logo1.png',
                      height: 120,
                      width:100,
                      //color: MyTheme.dark_grey,
                    )
                  ],
                ),
                QrImageView(
                  data: "Reçu: $receiptNumber - Total: $total FCFA",
                  version: QrVersions.auto,
                  size: 100.0,
                ),
              ],
            ),
            const SizedBox(height: 15),

            // En-tête
            Text("REÇU D'ACHAT",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Numéro: $receiptNumber",
                    style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text("Date: $date",
                    style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            const Divider(thickness: 2),

            // Liste des articles
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: Text(item["name"],
                            style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                        Text("${item["qty"]} X ${item["price"]} FCFA",
                            style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 2),

            // Sous-total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sous-total:",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text("$subTotal FCFA"),
              ],
            ),

            // Remise
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Remise (10%):",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text("-${discount.toStringAsFixed(0)} FCFA"),
              ],
            ),

            // Mode de paiement
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mode de paiement:",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text(paymentMethod),
              ],
            ),

            const Divider(thickness: 2),

            // Total final
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("${total.toStringAsFixed(0)} FCFA",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Bouton imprimer
            SizedBox(
              width: double.infinity,
              child: PosBtn(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Impression en cours...")),
                  );
                },
                icon: Icons.print,
                iconColor: MyTheme.white,
                text: "IMPRIMER",
                color: MyTheme.accent_color,
                textColor: MyTheme.white,
                fontWeight: FontWeight.bold,
              )
            )
          ],
        ),
      ),
    );
  }
}
