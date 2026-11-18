import 'dart:async';

import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/data/repos/search_repo.dart';
import 'package:booking/features/search/logic/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stream cubit — the single owner of its subscription.
///
/// Contract: exactly ONE listener at any time (cancelled before every
/// re-query and in close()); guests filtering is client-side inside the
/// fetched window; every snapshot maps to live/empty — the UI never sees a
/// spinner again after the first data (no flicker, no data wipe).
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchRepo) : super(const SearchState.connecting());

  final SearchRepo _searchRepo;

  StreamSubscription<List<Room>>? _subscription;
  SearchQuery? _lastQuery;
  List<Room> _lastRooms = const <Room>[];

  void load(SearchQuery query) {
    _lastQuery = query;
    _subscription?.cancel();
    _subscription = null;
    emit(const SearchState.connecting());
    _subscription = _searchRepo.watchRooms(query).listen(
          (List<Room> rooms) => _onRooms(rooms, query),
          onError: (Object error) => emit(
            SearchState.failure(
              _lastRooms,
              BookingFailure(
                code: FirebaseErrorMapper.map(error),
              ),
            ),
          ),
        );
  }

  void _onRooms(List<Room> rooms, SearchQuery query) {
    // Guests filter applied client-side inside the fetched window (the
    // Firestore query keeps price/ordering server-side).
    final List<Room> matching = rooms
        .where((Room room) => room.capacity >= query.guests)
        .toList(growable: false);
    _lastRooms = matching;
    if (matching.isEmpty) {
      emit(const SearchState.empty());
    } else {
      emit(SearchState.live(matching));
    }
  }

  /// Re-runs the last query (inline retry card).
  void retry() {
    final SearchQuery? query = _lastQuery;
    if (query != null) {
      load(query);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
