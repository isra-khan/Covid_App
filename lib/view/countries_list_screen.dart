import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/view/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  final TextEditingController _controller = TextEditingController();
  final StateServicesController _servicesController =
      Get.find<StateServicesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Countries',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildCountryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _controller,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by name or ISO code',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textSecondary),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    return Expanded(
      child: FutureBuilder<List<CountryModel>>(
        future: _servicesController.fetchCountries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _buildShimmer();
          final all = snapshot.data!;
          final query = _controller.text.toLowerCase();
          final filtered = query.isEmpty
              ? all
              : all
                  .where((c) =>
                      c.country.toLowerCase().contains(query) ||
                      c.iso2.toLowerCase().contains(query) ||
                      c.iso3.toLowerCase().contains(query))
                  .toList();
          if (filtered.isEmpty) {
            return const Center(
              child: Text('No countries match your search.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _buildCountryTile(filtered[index]),
          );
        },
      ),
    );
  }

  Widget _buildCountryTile(CountryModel country) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => DetailScreen(
                image: country.flag,
                name: country.country,
                totalCases: country.cases,
                totalRecovered: country.recovered,
                totalDeaths: country.deaths,
                active: country.active,
                test: country.tests,
                todayRecovered: country.todayRecovered,
                critical: country.critical,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: country.flag.isNotEmpty
                    ? Image.network(country.flag,
                        height: 40,
                        width: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _flagPlaceholder())
                    : _flagPlaceholder(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(country.country,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('${NumberFormatter.compact(country.cases)} cases',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagPlaceholder() => Container(
        height: 40,
        width: 56,
        color: Colors.grey.shade200,
        child: const Icon(Icons.flag_outlined,
            color: AppColors.textSecondary, size: 18),
      );

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
