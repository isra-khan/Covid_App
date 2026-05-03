import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/personal_country_controller.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCountryCard extends StatelessWidget {
  const MyCountryCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PersonalCountryController>()) {
      Get.put(PersonalCountryController());
    }
    final c = Get.find<PersonalCountryController>();
    return Obx(() {
      if (!c.isConfigured.value) return _setupCta(context);
      return _summaryCard(context, c);
    });
  }

  Widget _setupCta(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.toNamed(Routes.personalCountry),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_rounded,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set up My Country',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    SizedBox(height: 2),
                    Text(
                        'Get personal alerts when predictions cross a threshold.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context, PersonalCountryController c) {
    final country = c.country.value;
    final pred = c.tomorrowPrediction.value;
    final isOver = pred != null && pred > c.threshold.value;
    final accent = isOver ? AppColors.danger : AppColors.success;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.toNamed(Routes.personalCountry),
        child: Container(
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
          child: Row(
            children: [
              if (country?.flag.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(country!.flag,
                      width: 56, height: 38, fit: BoxFit.cover),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My country: ${country?.country ?? ''}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (c.isLoading.value)
                          const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                        else
                          Text(
                            pred == null
                                ? '—'
                                : NumberFormatter.compact(pred),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: accent,
                                letterSpacing: -0.5),
                          ),
                        const SizedBox(width: 6),
                        const Text('predicted tomorrow',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              if (pred != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                      isOver
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_rounded,
                      color: accent,
                      size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
