import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/risk_score_controller.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/view/widgets/country_dropdown.dart';
import 'package:covidapp/view/widgets/risk_meter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiskScoreScreen extends StatelessWidget {
  const RiskScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RiskScoreController>();
    final svc = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Risk Score',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => ListView(
              children: [
                _hero(),
                const SizedBox(height: 20),
                _label('Country'),
                CountryDropdown(
                  countries: svc.countries.toList(),
                  value: c.selectedCountry.value,
                  onChanged: c.setCountry,
                ),
                const SizedBox(height: 20),
                _label('Age: ${c.age.value}'),
                _card(child: Slider(
                  value: c.age.value.toDouble(),
                  min: 1,
                  max: 100,
                  divisions: 99,
                  activeColor: AppColors.primary,
                  label: c.age.value.toString(),
                  onChanged: (v) => c.setAge(v.round()),
                )),
                const SizedBox(height: 16),
                _card(
                  child: SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Has comorbidities',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Diabetes, heart disease, asthma, immunocompromised',
                        style: TextStyle(fontSize: 12)),
                    value: c.hasComorbidities.value,
                    onChanged: c.setComorbidities,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed:
                        c.selectedCountry.value == null ? null : c.compute,
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('Calculate Risk',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 24),
                if (c.result.value != null)
                  _card(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: RiskMeter(result: c.result.value!),
                  ),
              ],
            )),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_rounded, color: Colors.white, size: 36),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Estimate your personal COVID risk based on country stats and health profile.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      );

  Widget _card({required Widget child, EdgeInsets? padding}) => Container(
        padding: padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
}
