import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/logic/cubit/search_cubit.dart';
import 'package:booking/features/search/ui/widgets/filters_bar.dart';
import 'package:booking/features/search/ui/widgets/results_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Live results screen — owns TWO cubits' worth of separation: the results
/// LIST lives on the stream cubit (BlocBuilder), and booking actions live on
/// BookingCubit elsewhere (BlocListener over BlocBuilder).
class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.query});

  final SearchQuery query;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late SearchQuery _query;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (BuildContext context) {
        final SearchCubit cubit = getIt<SearchCubit>();
        cubit.load(_query);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.resultsTitle)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                '${_query.city} · ${_query.guests} ${AppStrings.guestsLabel}',
                style: TextStyles.font14GrayRegular,
              ),
            ),
            FiltersBar(
              query: _query,
              onQueryChanged: (SearchQuery updated) {
                setState(() => _query = updated);
                context.read<SearchCubit>().load(updated);
              },
            ),
            Expanded(child: ResultsBlocBuilder(query: _query)),
          ],
        ),
      ),
    );
  }
}
