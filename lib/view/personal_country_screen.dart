import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/personal_country_controller.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/view/widgets/country_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PersonalCountryScreen extends StatefulWidget {
  const PersonalCountryScreen({super.key});

  @override
  State<PersonalCountryScreen> createState() => _PersonalCountryScreenState();
}

class _PersonalCountryScreenState extends State<PersonalCountryScreen> {
  final TextEditingController _thresholdCtl = TextEditingController();
  CountryModel? _draftCountry;
  late int _draftThreshold;
  bool _draftNotify = true;

  @override
  void initState() {
    super.initState();
    final c = Get.find<PersonalCountryController>();
    _draftCountry = c.country.value;
    _draftThreshold = c.threshold.value;
    _draftNotify = c.notificationsEnabled.value;
    _thresholdCtl.text = _draftThreshold.toString();
  }

  @override
  void dispose() {
    _thresholdCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PersonalCountryController>();
    final svc = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('My Country',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _hero(),
              const SizedBox(height: 20),
              if (c.isConfigured.value && c.country.value != null)
                _predictionCard(c),
              if (c.isConfigured.value && c.country.value != null)
                const SizedBox(height: 20),
              _label('Country'),
              CountryDropdown(
                countries: svc.countries.toList(),
                value: _draftCountry,
                hint: 'Select your country',
                onChanged: (v) => setState(() => _draftCountry = v),
              ),
              const SizedBox(height: 16),
              _label('Alert threshold (predicted cases)'),
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
                  controller: _thresholdCtl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers_rounded,
                        color: AppColors.textSecondary),
                    hintText: 'e.g. 50000',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) _draftThreshold = n;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _notifyTile(),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _draftCountry == null ? null : () => _save(c),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              if (c.isConfigured.value) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _confirmClear(c),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Clear my country'),
                  ),
                ),
              ],
              if (kDebugMode && c.isConfigured.value) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () async {
                    await c.runWorkerNow();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Worker ran. Notification fires only if prediction > threshold.')),
                    );
                  },
                  icon: const Icon(Icons.bug_report_outlined, size: 18),
                  label: const Text('Run worker now (debug)'),
                ),
              ],
            ],
          )),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_rounded, color: Colors.white, size: 36),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Get a daily alert when predicted cases in your country cross your threshold.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _predictionCard(PersonalCountryController c) {
    final pred = c.tomorrowPrediction.value;
    final country = c.country.value!;
    final isOver = pred != null && pred > c.threshold.value;
    final color = isOver ? AppColors.danger : AppColors.success;
    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              if (country.flag.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(country.flag,
                      width: 44, height: 30, fit: BoxFit.cover),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(country.country,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: c.isLoading.value ? null : c.refreshPrediction,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (c.isLoading.value)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else if (pred == null)
            const Text('Prediction unavailable',
                style: TextStyle(color: AppColors.textSecondary))
          else
            Column(
              children: [
                const Text('Predicted cases tomorrow',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  NumberFormatter.compact(pred),
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          isOver
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_rounded,
                          size: 16,
                          color: color),
                      const SizedBox(width: 6),
                      Text(
                        isOver
                            ? 'Above threshold (${NumberFormatter.compact(c.threshold.value)})'
                            : 'Below threshold (${NumberFormatter.compact(c.threshold.value)})',
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
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

  Widget _notifyTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        thumbColor: WidgetStateProperty.all(AppColors.primary),
        activeTrackColor: AppColors.primary.withOpacity(0.4),
        inactiveTrackColor: AppColors.primary.withOpacity(0.15),
        title: const Text('Daily background notifications',
            style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text(
            'Send a notification each morning if prediction crosses threshold.',
            style: TextStyle(fontSize: 12)),
        value: _draftNotify,
        onChanged: (v) => setState(() => _draftNotify = v),
      ),
    );
  }

  Future<void> _save(PersonalCountryController c) async {
    if (_draftCountry == null) return;
    final ok = await c.setup(
      newCountry: _draftCountry!,
      newThreshold: _draftThreshold,
      notify: _draftNotify,
    );
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Notification permission denied. Saved without notifications.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved.')),
      );
    }
  }

  Future<void> _confirmClear(PersonalCountryController c) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear my country?'),
        content: const Text(
            'Your country, threshold, and notifications will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (yes == true) {
      await c.clear();
      if (!mounted) return;
      setState(() {
        _draftCountry = null;
        _thresholdCtl.text = '50000';
        _draftThreshold = 50000;
        _draftNotify = true;
      });
    }
  }
}
