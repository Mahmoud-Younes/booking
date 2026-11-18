import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

/// Read-only check-in/check-out fields opening the framework date pickers.
/// Check-out minimum is check-in plus one day (enforced by the picker in
/// the home screen); past dates are unselectable there too.
class DateRangeFields extends StatelessWidget {
  const DateRangeFields({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onTap,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String checkInText =
        checkIn == null ? '' : StayDate.fromDateTime(checkIn!).display;
    final String checkOutText =
        checkOut == null ? '' : StayDate.fromDateTime(checkOut!).display;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: AppTextFormField(
                hintText: AppStrings.checkInLabel,
                controller: TextEditingController(text: checkInText),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: AppTextFormField(
                hintText: AppStrings.checkOutLabel,
                controller: TextEditingController(text: checkOutText),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
