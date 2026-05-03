import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/utils/risk_calculator.dart';
import 'package:flutter/material.dart';

class RiskMeter extends StatelessWidget {
  final RiskResult result;
  const RiskMeter({super.key, required this.result});

  Color _color(RiskLevel l) {
    switch (l) {
      case RiskLevel.low:
        return AppColors.success;
      case RiskLevel.moderate:
        return AppColors.warning;
      case RiskLevel.high:
        return Colors.deepOrange;
      case RiskLevel.critical:
        return AppColors.critical;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(result.level);
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: result.score / 100,
                strokeWidth: 14,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(result.score.toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: -1)),
                Text(RiskCalculator.label(result.level),
                    style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${RiskCalculator.label(result.level)} Risk',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
