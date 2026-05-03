import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/controller/travel_advisor_controller.dart';
import 'package:covidapp/utils/travel_risk.dart';
import 'package:covidapp/view/widgets/country_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelAdvisorScreen extends StatelessWidget {
  const TravelAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TravelAdvisorController>();
    final svc = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Travel Advisor',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => ListView(
              children: [
                _label('From'),
                CountryDropdown(
                  countries: svc.countries.toList(),
                  value: c.origin.value,
                  hint: 'Origin country',
                  onChanged: c.setOrigin,
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.flight_rounded,
                        color: AppColors.primary, size: 32),
                  ),
                ),
                const SizedBox(height: 8),
                _label('To'),
                CountryDropdown(
                  countries: svc.countries.toList(),
                  value: c.destination.value,
                  hint: 'Destination country',
                  onChanged: c.setDestination,
                ),
                const SizedBox(height: 28),
                if (c.result.value != null) _buildVerdict(c.result.value!)
                else _placeholder(),
              ],
            )),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 13)),
      );

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.flight_takeoff_rounded,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text('Pick origin and destination to see verdict',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildVerdict(TravelRiskResult r) {
    final color = _color(r.verdict);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(_icon(r.verdict), size: 64, color: Colors.white),
          const SizedBox(height: 12),
          Text(TravelRisk.label(r.verdict),
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          Text(r.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Risk ratio: ${r.ratio.toStringAsFixed(2)}x',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Color _color(TravelVerdict v) {
    switch (v) {
      case TravelVerdict.safe:
        return AppColors.success;
      case TravelVerdict.caution:
        return AppColors.warning;
      case TravelVerdict.avoid:
        return AppColors.critical;
    }
  }

  IconData _icon(TravelVerdict v) {
    switch (v) {
      case TravelVerdict.safe:
        return Icons.check_circle_rounded;
      case TravelVerdict.caution:
        return Icons.warning_amber_rounded;
      case TravelVerdict.avoid:
        return Icons.dangerous_rounded;
    }
  }
}
