import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/constant/app_theme.dart';
import 'package:flutter/material.dart';

class CountryDropdown extends StatelessWidget {
  final List<CountryModel> countries;
  final CountryModel? value;
  final ValueChanged<CountryModel?> onChanged;
  final String hint;

  const CountryDropdown({
    super.key,
    required this.countries,
    required this.value,
    required this.onChanged,
    this.hint = 'Select country',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CountryModel>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          hint: Text(hint,
              style: const TextStyle(color: AppColors.textSecondary)),
          items: countries
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.country,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
