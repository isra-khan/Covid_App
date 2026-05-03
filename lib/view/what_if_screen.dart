import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/what_if_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WhatIfScreen extends StatelessWidget {
  const WhatIfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WhatIfController>();
    final tc = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('What If',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.compare_arrows_rounded,
                        color: Colors.white, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Enter a hypothetical case count and find the closest matching country.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                child: TextField(
                  controller: tc,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers_rounded,
                        color: AppColors.textSecondary),
                    hintText: 'Hypothetical cases',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (v) => c.setInput(int.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(height: 20),
              if (c.match.value == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.search_rounded,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      const Text('Type a number to find a match',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              else
                _buildMatchCard(c.match.value!),
              const SizedBox(height: 24),
            ],
          )),
    );
  }

  Widget _buildMatchCard(dynamic m) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (m.flag.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(m.flag,
                  width: 96, height: 64, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Text(m.country,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _kv('Cases', m.cases, AppColors.info),
          _kv('Deaths', m.deaths, AppColors.danger),
          _kv('Recovered', m.recovered, AppColors.success),
          _kv('Active', m.active, AppColors.warning),
          _kv('Population', m.population, AppColors.primary),
        ],
      ),
    );
  }

  Widget _kv(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: const TextStyle(color: AppColors.textSecondary))),
          Text(NumberFormatter.compact(value),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 15)),
        ],
      ),
    );
  }
}
