import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/controller/trend_predictor_controller.dart';
import 'package:covidapp/view/widgets/country_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendPredictorScreen extends StatelessWidget {
  const TrendPredictorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TrendPredictorController>();
    final svc = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Trend Predictor',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CountryDropdown(
                  countries: svc.countries.toList(),
                  value: c.selectedCountry.value,
                  onChanged: (v) {
                    if (v != null) c.load(v);
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 16, color: AppColors.warning),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Statistical extrapolation, not epidemiological forecasting.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _content(c)),
              ],
            )),
      ),
    );
  }

  Widget _content(TrendPredictorController c) {
    if (c.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (c.error.value != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(c.error.value!,
                style: const TextStyle(color: AppColors.danger)),
          ],
        ),
      );
    }
    if (c.historical.value == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart_rounded,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            const Text('Pick a country to see the trend',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return _buildChart(c);
  }

  Widget _buildChart(TrendPredictorController c) {
    final hist = c.historical.value!;
    final actual = hist.cases.map((e) => e.toDouble()).toList();
    final pred = c.predicted.toList();
    final spotsActual = [
      for (var i = 0; i < actual.length; i++) FlSpot(i.toDouble(), actual[i])
    ];
    final spotsPred = [
      for (var i = 0; i < pred.length; i++)
        FlSpot((actual.length + i).toDouble(), pred[i])
    ];
    final all = [...actual, ...pred];
    final minY = all.reduce((a, b) => a < b ? a : b);
    final maxY = all.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(LineChartData(
              minY: minY,
              maxY: maxY,
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spotsActual,
                  isCurved: true,
                  color: AppColors.info,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.info.withOpacity(0.1),
                  ),
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: spotsPred,
                  isCurved: true,
                  color: AppColors.warning,
                  barWidth: 3,
                  dashArray: [6, 4],
                  dotData: const FlDotData(show: false),
                ),
              ],
            )),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legend(AppColors.info, 'Actual (30d)'),
              const SizedBox(width: 20),
              _legend(AppColors.warning, 'Predicted (7d)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
