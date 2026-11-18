import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/env/env.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/data/repos/search_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late SearchRepo repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = SearchRepo(db, const FirestorePaths(Env.prod));
  });

  Future<void> seedRoom({
    required String id,
    required String city,
    required num price,
    required int capacity,
  }) async {
    await db.collection('rooms').doc(id).set(<String, dynamic>{
      'city': city,
      'title': 'غرفة $id',
      'pricePerNight': price,
      'capacity': capacity,
      'imageUrl': 'https://picsum.photos/seed/$id/400/300',
      'schemaVersion': 1,
    });
  }

  SearchQuery query({
    String city = 'القاهرة',
    int guests = 2,
    num? maxPrice,
    bool sortDescending = false,
  }) =>
      SearchQuery(
        city: city,
        stayRange: StayDateRange(
          checkIn: StayDate.parse('2026-12-01'),
          checkOut: StayDate.parse('2026-12-03'),
        ),
        guests: guests,
        maxPrice: maxPrice,
        sortDescending: sortDescending,
      );

  test('watchRooms streams city matches ordered by price ascending',
      () async {
    await seedRoom(id: 'a', city: 'القاهرة', price: 500, capacity: 2);
    await seedRoom(id: 'b', city: 'القاهرة', price: 300, capacity: 2);
    await seedRoom(id: 'c', city: 'الإسكندرية', price: 100, capacity: 2);

    final List<List<dynamic>> emissions =
        await repo.watchRooms(query()).take(1).toList();

    expect(emissions, hasLength(1));
    final List<dynamic> rooms = emissions.first;
    expect(rooms.length, 2, reason: 'the Alexandria room must not leak in');
    expect((rooms[0] as dynamic).pricePerNight, 300,
        reason: 'ordered by price ascending');
    expect((rooms[1] as dynamic).pricePerNight, 500);
  });

  test('maxPrice range filters server-side alongside the city equality',
      () async {
    await seedRoom(id: 'a', city: 'القاهرة', price: 500, capacity: 2);
    await seedRoom(id: 'b', city: 'القاهرة', price: 300, capacity: 2);

    final List<List<dynamic>> emissions =
        await repo.watchRooms(query(maxPrice: 400)).take(1).toList();

    expect(emissions.first.length, 1);
    expect((emissions.first[0] as dynamic).pricePerNight, 300);
  });

  test('descending sort flips the order', () async {
    await seedRoom(id: 'a', city: 'القاهرة', price: 500, capacity: 2);
    await seedRoom(id: 'b', city: 'القاهرة', price: 300, capacity: 2);

    final List<List<dynamic>> emissions =
        await repo.watchRooms(query(sortDescending: true)).take(1).toList();

    expect((emissions.first[0] as dynamic).pricePerNight, 500);
  });

  test('getRoom loads by ID (load-from-ID path)', () async {
    await seedRoom(id: 'room_cairo_01', city: 'القاهرة', price: 850, capacity: 2);
    final dynamic room = await repo.getRoom('room_cairo_01');
    expect(room, isNotNull);
    expect((room as dynamic).id, 'room_cairo_01');
    expect(await repo.getRoom('missing'), isNull);
  });

  test('documents carry no id field (ID lives on the path)', () async {
    await seedRoom(id: 'a', city: 'القاهرة', price: 100, capacity: 1);
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection('rooms').doc('a').get();
    expect(doc.data()!.containsKey('id'), isFalse);
  });
}
