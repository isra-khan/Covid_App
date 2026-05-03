import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/utils/auth_prefs.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:covidapp/view/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctl = PageController();
  int _index = 0;

  static const _pages = [
    _PageData(
      icon: Icons.public_rounded,
      title: 'Track in real time',
      description:
          'Live COVID-19 stats from 200+ countries, refreshed throughout the day.',
    ),
    _PageData(
      icon: Icons.show_chart_rounded,
      title: 'Predict trends',
      description:
          'AI-powered forecasts show where cases are headed in your country.',
    ),
    _PageData(
      icon: Icons.notifications_active_rounded,
      title: 'Stay alert',
      description:
          'Get a daily notification when predicted cases cross your threshold.',
    ),
  ];

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AuthPrefs.setOnboardingCompleted(true);
    Get.offAllNamed(Routes.signIn);
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _ctl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _ctl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => OnboardingPage(
                    icon: _pages[i].icon,
                    title: _pages[i].title,
                    description: _pages[i].description,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(active ? 1 : 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _next,
                    child: Text(
                      isLast ? 'Get started' : 'Next',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final String title;
  final String description;
  const _PageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
