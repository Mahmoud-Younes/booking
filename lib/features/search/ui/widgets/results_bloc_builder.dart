import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/widgets/empty_state_view.dart';
import 'package:booking/core/widgets/failure_retry_card.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/logic/cubit/search_cubit.dart';
import 'package:booking/features/search/logic/cubit/search_state.dart';
import 'package:booking/features/search/ui/widgets/results_list.dart';
import 'package:booking/features/search/ui/widgets/results_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Every SearchState maps to a designed piece — nothing renders a bare
/// SizedBox on failure.
class ResultsBlocBuilder extends StatelessWidget {
  const ResultsBlocBuilder({super.key, required this.query});

  final SearchQuery query;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (SearchState previous, SearchState current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is Live && current is Live),
      builder: (BuildContext context, SearchState state) {
        return switch (state) {
          // First load for this query: shimmer skeleton.
          Connecting() => const ResultsShimmer(),
          // Zero matches: designed empty state with clear-filters action
          // (filters may have over-restricted the window).
          EmptySearch() => EmptyStateView(
              title: AppStrings.emptyResultsTitle,
              subtitle: AppStrings.emptyResultsSubtitle,
              actionLabel: AppStrings.clearFilters,
              onAction: () => Navigator.of(context).pop(),
            ),
          // Stream failure: keep the last list visible + inline retry card.
          SearchFailed() => Column(
              children: [
                FailureRetryCard(
                  message: FirebaseErrorMapper.message(state.failure),
                  onRetry: context.read<SearchCubit>().retry,
                ),
                Expanded(child: ResultsList(rooms: state.lastRooms, query: query)),
              ],
            ),
          // Live data (or the dimmed previous list while reconnecting).
          Live() => ResultsList(rooms: state.rooms, query: query),
        };
      },
    );
  }
}
