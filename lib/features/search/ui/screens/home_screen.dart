import 'package:booking/core/helpers/extensions.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/core/widgets/app_text_form_field.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/ui/widgets/date_range_fields.dart';
import 'package:booking/features/search/ui/widgets/guests_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Search form (home) — plain StatefulWidget state, NO cubit: form
/// selection (destination, dates, guests) is not async data.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkIn ?? today.add(const Duration(days: 1)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: AppStrings.checkInLabel,
    );
    if (picked == null || !mounted) {
      return;
    }
    final DateTime? checkOut = await showDatePicker(
      context: context,
      initialDate: picked.add(const Duration(days: 1)),
      firstDate: picked.add(const Duration(days: 1)),
      lastDate: today.add(const Duration(days: 366)),
      helpText: AppStrings.checkOutLabel,
    );
    if (checkOut == null || !mounted) {
      return;
    }
    setState(() {
      _checkIn = picked;
      _checkOut = checkOut;
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر تاريخي الوصول والمغادرة')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.resultsScreen,
      arguments: SearchQuery(
        city: _destinationController.text.trim(),
        stayRange: StayRangeArgs(
          checkIn: _checkIn!,
          checkOut: _checkOut!,
        ).toStayDateRange(),
        guests: _guests,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.searchTitle),
        actions: [
          // In-app project identity — one tap tells any reviewer what this
          // app is, what it does, and the guarantee behind it.
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: AppStrings.aboutTitle,
            onPressed: () => context.pushNamed(Routes.aboutScreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextFormField(
                  controller: _destinationController,
                  hintText: AppStrings.destinationHint,
                  validator: (String? value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'أدخل المدينة'
                          : null,
                ),
                SizedBox(height: 16.h),
                DateRangeFields(
                  checkIn: _checkIn,
                  checkOut: _checkOut,
                  onTap: _pickDates,
                ),
                SizedBox(height: 16.h),
                GuestsStepper(
                  guests: _guests,
                  onChanged: (int guests) => setState(() => _guests = guests),
                ),
                SizedBox(height: 24.h),
                AppTextButton(
                  buttonText: AppStrings.searchButton,
                  backgroundColor: ColorsManager.mainBlue,
                  textStyle: TextStyles.font16WhiteSemiBold,
                  width: double.infinity,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Typed argument carrier between the form and the results route — the
/// StayDateRange conversion stays out of navigation.
class StayRangeArgs {
  const StayRangeArgs({required this.checkIn, required this.checkOut});

  final DateTime checkIn;
  final DateTime checkOut;

  /// Converts to the pure stay contract (UTC normalization happens here).
  StayDateRange toStayDateRange() => StayDateRange(
        checkIn: StayDate.fromDateTime(checkIn),
        checkOut: StayDate.fromDateTime(checkOut),
      );
}
