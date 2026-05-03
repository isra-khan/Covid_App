import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/auth_controller.dart';
import 'package:covidapp/utils/auth_prefs.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final onboarded = await AuthPrefs.isOnboardingCompleted();
    if (!mounted) return;
    if (!onboarded) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }
    final auth = Get.find<AuthController>();
    if (auth.user.value == null) {
      Get.offAllNamed(Routes.signIn);
    } else {
      Get.offAllNamed(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
