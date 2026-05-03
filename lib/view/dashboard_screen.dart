import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:covidapp/view/widgets/app_drawer.dart';
import 'package:covidapp/view/widgets/daily_briefing_card.dart';
import 'package:covidapp/view/widgets/feature_tile.dart';
import 'package:covidapp/view/widgets/stat_hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Covid Tracker',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              c.fetchWorkStateRecords();
              c.fetchCountries(forceRefresh: true);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: 50,
                controller: c.controller,
              ),
            );
          }
          final data = c.casesModel.value;
          if (data == null) {
            return _buildErrorRetry(c);
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await c.fetchWorkStateRecords();
              await c.fetchCountries(forceRefresh: true);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                DailyBriefingCard(data: data),
                const SizedBox(height: 20),
                StatHeroCard(data: data),
                const SizedBox(height: 20),
                _buildSectionHeader('Explore features'),
                const SizedBox(height: 12),
                _buildFeatureGrid(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildErrorRetry(StateServicesController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded,
                  size: 48, color: AppColors.danger),
            ),
            const SizedBox(height: 20),
            const Text("Couldn't load global stats",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Check your connection and try again.',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: c.fetchWorkStateRecords,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final tiles = <_TileData>[
      _TileData(Icons.public_rounded, 'Countries', AppColors.info,
          Routes.contactList),
      _TileData(
          Icons.shield_rounded, 'Risk Score', AppColors.accent, Routes.riskScore),
      _TileData(Icons.show_chart_rounded, 'Predictor', const Color(0xFF8B5CF6),
          Routes.trendPredictor),
      _TileData(Icons.compare_arrows_rounded, 'What If', AppColors.warning,
          Routes.whatIf),
      _TileData(Icons.map_rounded, 'Heatmap', const Color(0xFFEC4899),
          Routes.heatmap),
      _TileData(Icons.article_rounded, 'News', AppColors.info, Routes.news),
      _TileData(Icons.emoji_events_rounded, 'Leaderboard',
          const Color(0xFFD97706), Routes.leaderboard),
      _TileData(Icons.health_and_safety_rounded, 'Symptoms', AppColors.success,
          Routes.symptomChecker),
      _TileData(Icons.flight_takeoff_rounded, 'Travel', const Color(0xFF06B6D4),
          Routes.travelAdvisor),
      _TileData(Icons.mic_rounded, 'Voice', const Color(0xFF7C3AED),
          Routes.voiceStats),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 72,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, i) {
        final t = tiles[i];
        return FeatureTile(
          icon: t.icon,
          label: t.label,
          color: t.color,
          onTap: () => Get.toNamed(t.route),
        );
      },
    );
  }
}

class _TileData {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _TileData(this.icon, this.label, this.color, this.route);
}
