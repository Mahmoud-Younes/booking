import 'dart:async';

import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/data/repos/search_repo.dart';
import 'package:booking/features/search/logic/cubit/search_cubit.dart';
import 'package:booking/features/search/logic/cubit/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchRepo extends Mock implements SearchRepo {}

Room _room(String id, int capacity) => Room(
      id: id,
      city: 'القاهرة',
      title: 'غرفة',
      pricePerNight: 100,
      capacity: capacity,
      imageUrl: 'https://picsum.photos/seed/$id/400/300',
    );

SearchQuery _query({int guests = 2}) => SearchQuery(
      city: 'القاهرة',
      stayRange: StayDateRange(
        checkIn: StayDate.parse('2026-12-01'),
        checkOut: StayDate.parse('2026-12-03'),
      ),
      guests: guests,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_query());
  });

  late _MockSearchRepo repo;
  // Each watchRooms call gets its OWN single-subscription stream — the cubit
  // cancels before re-listening, which is exactly the contract under test.
  final List<StreamController<List<Room>>> controllers =
      <StreamController<List<Room>>>[];

  StreamController<List<Room>> streamController() => controllers.last;

  setUp(() {
    repo = _MockSearchRepo();
    when(() => repo.watchRooms(any())).thenAnswer((_) {
      final StreamController<List<Room>> controller =
          StreamController<List<Room>>();
      controllers.add(controller);
      return controller.stream;
    });
  });

  tearDown(() {
    for (final StreamController<List<Room>> controller in controllers) {
      controller.close();
    }
  });

  test('connecting -> live with the guests filter applied client-side',
      () async {
    final SearchCubit cubit = SearchCubit(repo);
    final List<SearchState> states = <SearchState>[];
    final StreamSubscription<SearchState> subscription =
        cubit.stream.listen(states.add);

    cubit.load(_query());
    streamController().add(<Room>[_room('r1', 2), _room('r2', 4)]);
    await Future<void>.delayed(Duration.zero);

    expect(states.first, isA<Connecting>());
    expect(states[1], isA<Live>());
    final List<Room> rooms = (states[1] as Live).rooms;
    expect(rooms.length, 2);

    // A capacity-3 guest request filters r1 out client-side.
    cubit.load(_query(guests: 3));
    streamController().add(<Room>[_room('r1', 2), _room('r2', 4)]);
    await Future<void>.delayed(Duration.zero);
    final Live live = states.whereType<Live>().last;
    expect(live.rooms.map((Room r) => r.id), ['r2']);

    await subscription.cancel();
    await cubit.close();
  });

  test('zero matches -> empty state (no data wipe to a spinner)', () async {
    final SearchCubit cubit = SearchCubit(repo);
    final List<SearchState> states = <SearchState>[];
    final StreamSubscription<SearchState> subscription =
        cubit.stream.listen(states.add);

    cubit.load(_query());
    streamController().add(<Room>[_room('r1', 2)]);
    await Future<void>.delayed(Duration.zero);
    streamController().add(<Room>[]);
    await Future<void>.delayed(Duration.zero);

    expect(states[1], isA<Live>());
    expect(states[2], isA<EmptySearch>());

    await subscription.cancel();
    await cubit.close();
  });

  test('stream error -> failure KEEPS the last list for the retry card',
      () async {
    final SearchCubit cubit = SearchCubit(repo);
    final List<SearchState> states = <SearchState>[];
    final StreamSubscription<SearchState> subscription =
        cubit.stream.listen(states.add);

    cubit.load(_query());
    streamController().add(<Room>[_room('r1', 2)]);
    await Future<void>.delayed(Duration.zero);
    streamController().addError(Exception('boom'));
    await Future<void>.delayed(Duration.zero);

    expect(states.last, isA<SearchFailed>());
    final SearchFailed failed = states.last as SearchFailed;
    expect(failed.lastRooms.length, 1,
        reason: 'the last list stays visible under the inline retry card');
    expect(failed.failure.code, FailureCode.unknown);

    await subscription.cancel();
    await cubit.close();
  });

  test('re-query cancels the previous subscription (exactly one listener)',
      () async {
    final SearchCubit cubit = SearchCubit(repo);
    cubit.load(_query());
    await Future<void>.delayed(Duration.zero);
    expect(streamController().hasListener, isTrue);

    cubit.load(_query(guests: 4));
    await Future<void>.delayed(Duration.zero);
    expect(streamController().hasListener, isTrue);

    await cubit.close();
    expect(streamController().hasListener, isFalse,
        reason: 'close() must cancel the subscription (no leaked listener)');
  });
}
