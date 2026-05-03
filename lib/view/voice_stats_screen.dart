import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/voice_stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceStatsScreen extends StatelessWidget {
  const VoiceStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VoiceStatsController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Voice Stats',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tips_and_updates_rounded,
                          color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap the mic and ask: "Show me cases in Pakistan".',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(child: _micButton(c)),
                const SizedBox(height: 24),
                if (c.transcript.value.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
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
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote_rounded,
                            color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(c.transcript.value,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                if (c.error.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(c.error.value!,
                        style: const TextStyle(color: AppColors.danger),
                        textAlign: TextAlign.center),
                  ),
                const SizedBox(height: 20),
                if (c.matched.value != null) _resultCard(c),
              ],
            )),
      ),
    );
  }

  Widget _micButton(VoiceStatsController c) {
    final listening = c.isListening.value;
    return GestureDetector(
      onTap: () {
        if (listening) {
          c.stopListening();
        } else {
          c.startListening();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: listening
                ? [AppColors.danger, Colors.redAccent]
                : [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (listening ? AppColors.danger : const Color(0xFF7C3AED))
                  .withOpacity(0.4),
              blurRadius: 24,
              spreadRadius: listening ? 8 : 2,
            ),
          ],
        ),
        child: Icon(
          listening ? Icons.stop_rounded : Icons.mic_rounded,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _resultCard(VoiceStatsController c) {
    final m = c.matched.value!;
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
        children: [
          if (m.flag.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(m.flag,
                  width: 80, height: 56, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Text(m.country,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _row('Cases', m.cases, AppColors.info),
          _row('Deaths', m.deaths, AppColors.danger),
          _row('Recovered', m.recovered, AppColors.success),
        ],
      ),
    );
  }

  Widget _row(String label, int value, Color color) {
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
          Expanded(child: Text(label)),
          Text(NumberFormatter.compact(value),
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
