import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(icon, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
