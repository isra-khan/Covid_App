import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/symptom_checker_controller.dart';
import 'package:covidapp/utils/symptom_scorer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SymptomCheckerController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Symptom Checker',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (c.result.value != null) return _buildResult(c, c.result.value!);
          return ListView(
            children: [
              _disclaimer(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text('Check the symptoms you have:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              _toggle('Fever', Icons.thermostat, c.fever),
              _toggle('Dry cough', Icons.coronavirus, c.dryCough),
              _toggle('Fatigue', Icons.bedtime, c.fatigue),
              _toggle('Loss of taste/smell', Icons.no_food,
                  c.lossOfTasteOrSmell),
              _toggle('Shortness of breath', Icons.air, c.shortnessOfBreath),
              _toggle('Sore throat', Icons.healing, c.soreThroat),
              _toggle('Headache', Icons.psychology, c.headache),
              _toggle('Body aches', Icons.accessibility, c.bodyAches),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: c.compute,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Check Symptoms',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.warning),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'For informational purposes only. Not a medical diagnosis. Consult a healthcare provider.',
              style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String label, IconData icon, RxBool value) {
    return Obx(() {
      final isOn = value.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => value.value = !isOn,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isOn
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isOn
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon,
                        color: isOn
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14))),
                  Checkbox(
                    value: isOn,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onChanged: (v) => value.value = v ?? false,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResult(SymptomCheckerController c, SymptomResult r) {
    final color = _verdictColor(r.verdict);
    return ListView(
      children: [
        _disclaimer(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(28),
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
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(_verdictIcon(r.verdict), size: 56, color: color),
              ),
              const SizedBox(height: 16),
              Text(_verdictTitle(r.verdict),
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 12),
              Text(r.advice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Symptom score: ${r.score}',
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: c.reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Check Again'),
          ),
        ),
      ],
    );
  }

  Color _verdictColor(SymptomVerdict v) {
    switch (v) {
      case SymptomVerdict.likelyNotCovid:
        return AppColors.success;
      case SymptomVerdict.monitorAtHome:
        return AppColors.warning;
      case SymptomVerdict.consultDoctor:
        return Colors.deepOrange;
      case SymptomVerdict.urgent:
        return AppColors.critical;
    }
  }

  IconData _verdictIcon(SymptomVerdict v) {
    switch (v) {
      case SymptomVerdict.likelyNotCovid:
        return Icons.check_circle_rounded;
      case SymptomVerdict.monitorAtHome:
        return Icons.home_rounded;
      case SymptomVerdict.consultDoctor:
        return Icons.medical_services_rounded;
      case SymptomVerdict.urgent:
        return Icons.local_hospital_rounded;
    }
  }

  String _verdictTitle(SymptomVerdict v) {
    switch (v) {
      case SymptomVerdict.likelyNotCovid:
        return 'Likely not COVID';
      case SymptomVerdict.monitorAtHome:
        return 'Monitor at home';
      case SymptomVerdict.consultDoctor:
        return 'Consult a doctor';
      case SymptomVerdict.urgent:
        return 'Urgent care needed';
    }
  }
}
