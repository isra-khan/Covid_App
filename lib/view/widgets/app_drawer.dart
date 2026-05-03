import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/auth_controller.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _DrawerEntry {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  const _DrawerEntry(this.icon, this.label, this.route, this.color);
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _entries = [
    _DrawerEntry(Icons.dashboard_rounded, 'Dashboard', Routes.dashboard,
        AppColors.primary),
    _DrawerEntry(Icons.public_rounded, 'Countries', Routes.contactList,
        AppColors.info),
    _DrawerEntry(
        Icons.shield_rounded, 'Risk Score', Routes.riskScore, AppColors.accent),
    _DrawerEntry(Icons.show_chart_rounded, 'Trend Predictor',
        Routes.trendPredictor, Color(0xFF8B5CF6)),
    _DrawerEntry(Icons.compare_arrows_rounded, 'What If', Routes.whatIf,
        AppColors.warning),
    _DrawerEntry(Icons.map_rounded, 'Heatmap', Routes.heatmap,
        Color(0xFFEC4899)),
    _DrawerEntry(Icons.article_rounded, 'News', Routes.news, AppColors.info),
    _DrawerEntry(Icons.emoji_events_rounded, 'Leaderboard', Routes.leaderboard,
        Color(0xFFD97706)),
    _DrawerEntry(Icons.health_and_safety_rounded, 'Symptom Checker',
        Routes.symptomChecker, AppColors.success),
    _DrawerEntry(Icons.flight_takeoff_rounded, 'Travel Advisor',
        Routes.travelAdvisor, Color(0xFF06B6D4)),
    _DrawerEntry(
        Icons.mic_rounded, 'Voice Stats', Routes.voiceStats, Color(0xFF7C3AED)),
    _DrawerEntry(Icons.location_on_rounded, 'My Country',
        Routes.personalCountry, AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.coronavirus,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 12),
                  const Text('CoronaPulse',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text('Stay informed, stay safe',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _entries.length,
                itemBuilder: (context, i) {
                  final e = _entries[i];
                  final isCurrent = Get.currentRoute == e.route;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 2),
                    child: Material(
                      color: isCurrent
                          ? e.color.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (!isCurrent) Get.toNamed(e.route);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: e.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    Icon(e.icon, color: e.color, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  e.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isCurrent
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isCurrent
                                        ? e.color
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Material(
                color: AppColors.danger.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (Get.isRegistered<AuthController>()) {
                      await Get.find<AuthController>().signOut();
                    }
                    Get.offAllNamed(Routes.signIn);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.danger.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: AppColors.danger, size: 20),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text('Sign out',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.danger)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
