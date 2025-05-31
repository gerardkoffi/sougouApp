import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../my_theme.dart';

class MChart extends StatefulWidget {
  const MChart({super.key});

  @override
  State<MChart> createState() => _MChartState();
}

class _MChartState extends State<MChart> {
  // Données en dur pour 5 jours de mars 2025
  final List<ChartData> chartList = [
    ChartData(date: '2 Avril', total: 905000),
    ChartData(date: '3 Avril', total: 580000),
    ChartData(date: '4 Avril', total: 800000),
    ChartData(date: '5 Avril', total: 1000000),
    ChartData(date: '6 Avril', total: 460000),
  ];

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  List<CartesianSeries<OrdinalSales, String>> _createSampleData() {
    final data = chartList.map((chart) => OrdinalSales(
      chart.date,
      chart.total.round(),
    )).toList();

    return [
      StackedColumnSeries<OrdinalSales, String>(
        dataSource: data,
        xValueMapper: (OrdinalSales sales, _) => sales.year ?? 'N/A',
        yValueMapper: (OrdinalSales sales, _) => sales.sales,
        color: MyTheme.accent_color,
        enableTooltip: true,
        animationDuration: 1000,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: 0, // Plus besoin de rotation avec moins de données
          majorGridLines: const MajorGridLines(width: 0),
          // interval supprimé car on veut tous les labels
        ),
        primaryYAxis: NumericAxis(
          isVisible: false, // Suppression de l'axe des ordonnées
        ),
        legend: const Legend(
          isVisible: false,
          position: LegendPosition.bottom,
        ),
        tooltipBehavior: _tooltipBehavior,
        series: _createSampleData(),
      ),
    );
  }
}

class OrdinalSales {
  final String? year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class ChartData {
  final String date;
  final int total;

  ChartData({required this.date, required this.total});
}