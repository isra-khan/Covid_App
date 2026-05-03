import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  Color _bucket(num activePerMillion) {
    if (activePerMillion < 100) return AppColors.success;
    if (activePerMillion < 1000) return Colors.lightGreen;
    if (activePerMillion < 5000) return AppColors.warning;
    if (activePerMillion < 20000) return Colors.deepOrange;
    return AppColors.critical;
  }

  double _radius(num activePerMillion) {
    if (activePerMillion < 100) return 6;
    if (activePerMillion < 1000) return 9;
    if (activePerMillion < 5000) return 12;
    if (activePerMillion < 20000) return 16;
    return 20;
  }

  @override
  Widget build(BuildContext context) {
    final svc = Get.find<StateServicesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Active Cases Heatmap',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (svc.countries.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(20, 0),
                initialZoom: 2,
                minZoom: 1,
                maxZoom: 8,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'covidapp',
                ),
                MarkerLayer(
                  markers: svc.countries
                      .where((c) => c.lat != 0 || c.long != 0)
                      .map((c) => _marker(context, c))
                      .toList(),
                ),
              ],
            );
          }),
          Positioned(
            top: 12,
            right: 12,
            child: _legend(),
          ),
        ],
      ),
    );
  }

  Widget _legend() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Active per million',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _legendRow(AppColors.success, '< 100'),
          _legendRow(Colors.lightGreen, '< 1K'),
          _legendRow(AppColors.warning, '< 5K'),
          _legendRow(Colors.deepOrange, '< 20K'),
          _legendRow(AppColors.critical, '20K+'),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1)),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Marker _marker(BuildContext context, CountryModel c) {
    final color = _bucket(c.activePerOneMillion);
    final size = _radius(c.activePerOneMillion) * 2;
    return Marker(
      point: LatLng(c.lat, c.long),
      width: size,
      height: size,
      child: GestureDetector(
        onTap: () => _showSheet(context, c),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, CountryModel c) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (c.flag.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(c.flag,
                        width: 56, height: 36, fit: BoxFit.cover),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(c.country,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _row('Cases', c.cases, AppColors.info),
            _row('Active', c.active, AppColors.warning),
            _row('Deaths', c.deaths, AppColors.danger),
            _row('Recovered', c.recovered, AppColors.success),
            _row('Active / million',
                c.activePerOneMillion.toStringAsFixed(1), AppColors.primary),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, dynamic value, Color color) {
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
          Text(
              value is num
                  ? NumberFormatter.compact(value)
                  : value.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
