import 'dart:async';

import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Max-price + sort filter bar — debounced: a filter change waits before
/// re-querying (quota guardrail); the previous list stays visible dimmed
/// until the new stream connects (CUJ 4).
class FiltersBar extends StatefulWidget {
  const FiltersBar({
    super.key,
    required this.query,
    required this.onQueryChanged,
  });

  final SearchQuery query;
  final ValueChanged<SearchQuery> onQueryChanged;

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  late final TextEditingController _maxPriceController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final num? maxPrice = widget.query.maxPrice;
    _maxPriceController =
        TextEditingController(text: maxPrice == null ? '' : maxPrice.toString());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _emitMaxPrice(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final num? parsed = num.tryParse(value);
      widget.onQueryChanged(SearchQuery(
        city: widget.query.city,
        stayRange: widget.query.stayRange,
        guests: widget.query.guests,
        maxPrice: parsed,
        sortDescending: widget.query.sortDescending,
      ));
    });
  }

  void _toggleSort() {
    widget.onQueryChanged(SearchQuery(
      city: widget.query.city,
      stayRange: widget.query.stayRange,
      guests: widget.query.guests,
      maxPrice: widget.query.maxPrice,
      sortDescending: !widget.query.sortDescending,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _maxPriceController,
              keyboardType: TextInputType.number,
              onChanged: _emitMaxPrice,
              decoration: InputDecoration(
                hintText: AppStrings.maxPriceLabel,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          IconButton(
            onPressed: _toggleSort,
            tooltip: widget.query.sortDescending
                ? AppStrings.sortDescending
                : AppStrings.sortAscending,
            icon: Icon(
              widget.query.sortDescending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: ColorsManager.mainBlue,
            ),
          ),
        ],
      ),
    );
  }
}
