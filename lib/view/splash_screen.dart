import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/constant/assets.dart';
import 'package:covidapp/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final SplashController _controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildRotatingVirus(),
              const SizedBox(height: 40),
              const Text(
                'Covid-19',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tracker',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.85),
                  letterSpacing: 4,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading global data…',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRotatingVirus() {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: Image.asset(Assets().virus, color: Colors.white),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.controller.value * 2.0 * math.pi,
          child: child,
        );
      },
    );
  }
}
