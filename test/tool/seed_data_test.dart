import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Validates the committed seed fixture: the shape the seed script writes
/// and the UI depends on. Run from the repo root (`flutter test`).
void main() {
  test('seed fixture: 10 rooms, unique fixed IDs, complete fields', () {
    final File file = File('tool/seed/seed_data.json');
    expect(file.existsSync(), isTrue,
        reason: 'seed_data.json must exist at tool/seed/');

    final Map<String, dynamic> data =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final List<dynamic> rooms = data['rooms'] as List<dynamic>;

    expect(rooms.length, 10, reason: 'the fixture ships 10 rooms');
    expect(data['schemaVersion'], 1);

    final List<String> ids = rooms.map((dynamic r) => r['id'] as String).toList();
    expect(ids.toSet().length, ids.length, reason: 'IDs must be unique');
    for (final String id in ids) {
      expect(id.startsWith('room_'), isTrue, reason: 'fixed IDs are room_*');
    }

    final Set<String> cities = <String>{};
    for (final dynamic room in rooms) {
      final Map<String, dynamic> r = room as Map<String, dynamic>;
      expect(r['city'], isNotEmpty);
      expect(r['title'], isNotEmpty);
      expect(r['imageUrl'], startsWith('https://images.unsplash.com/'),
          reason: 'rooms ship real photography, not random placeholders');
      expect((r['pricePerNight'] as num), greaterThan(0));
      expect((r['capacity'] as int), greaterThanOrEqualTo(1));
      cities.add(r['city'] as String);
    }
    expect(cities.length, 3, reason: 'rooms span 3 cities');
  });
}
