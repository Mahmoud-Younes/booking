import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

/// NON-TERMINAL stream states — a Firestore stream never ends, so there is
/// no terminal success/error. `connecting` fires once per query change
/// (never per snapshot); `failure` keeps the last list visible with a retry.
@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.connecting() = Connecting;

  const factory SearchState.live(List<Room> rooms) = Live;

  const factory SearchState.empty() = EmptySearch;

  const factory SearchState.failure(List<Room> lastRooms, BookingFailure failure) =
      SearchFailed;
}
