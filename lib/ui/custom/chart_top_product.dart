
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../my_theme.dart';

class TopsProduitChart extends StatefulWidget {
  const TopsProduitChart({super.key});

  @override
  State<TopsProduitChart> createState() => _TopsProduitChartState();
}

class _TopsProduitChartState extends State<TopsProduitChart> {
  // Données en dur pour mars 2025 (exemple avec plusieurs catégories)
  final List<ChartData> chartList = [
    ChartData(
      category: 'Iphone',
      total: 170,
    ),
    ChartData(
      category: 'Samsumg',
      total: 140,
    ),
    ChartData(
      category: 'Lenovo',
      total: 80,
    ),
  ];

  TooltipBehavior? _tooltipBehavior;

  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          orientation: LegendItemOrientation.horizontal, // Forcer l'affichage en ligne
          overflowMode: LegendItemOverflowMode.scroll, // Défilement si trop long
          itemPadding: 10.0, // Espacement entre les éléments
          textStyle: const TextStyle(fontSize: 12), // Taille du texte ajustable
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: chartList,
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.total,
            pointColorMapper: (ChartData data, _) => _getColor(data.category),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
            ),
            enableTooltip: true,
            explode: true,
            explodeAll: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }

  // Fonction pour attribuer des couleurs
  Color _getColor(String category) {
    if (category.contains('Iphone')) return MyTheme.app_accent_color;
    if (category.contains('Samsumg')) return MyTheme.accent_color;
    return MyTheme.green;
  }
}

class ChartData {
  final String category;
  final int total;

  ChartData({required this.category, required this.total});
}