# Booking — حجوزات

A training (DEPI) hotel-booking project built as ONE Flutter codebase for Android + Web, whose core deliverable is a Booking.com-style search with a **server-enforced, race-tested, no-double-booking guarantee**.

- Design document: [docs/designs/booking_search_conflict_free_engine.md](docs/designs/booking_search_conflict_free_engine.md)
- Firebase project: `sahety-ba784` (new app registrations only: Android `com.example.booking`, Web)

## Core guarantee

Availability is one Firestore document per room per night (`rooms/{roomId}/nights/{epochDay}` with `{bookingId, epochDay}`). A booking is a single `runTransaction` that reads every requested night, aborts on any existing night (`conflictLost`), and creates the booking + night documents atomically. `firestore.rules` allows night creates only when the document does not exist and the caller owns the referenced booking — so exactly one of two concurrent bookings wins, even from a modified client.

> Implementation note: night document paths use the integer **epoch day** instead of the design draft's `yyyy-MM-dd` so the rules can verify path ↔ field agreement with `int()` and enforce the stay-range binding server-side (the string form is not parseable in rules).

## Run

```bash
flutter pub get

# Android (dev flavor: dev_-prefixed collections)
flutter run -t lib/main_development.dart

# Web (path-based URLs via the SPA rewrite in firebase.json)
flutter run -d chrome -t lib/main_development.dart
```

## Tests

```bash
flutter analyze
dart run build_runner build --delete-conflicting-outputs   # codegen freshness
flutter test                                               # unit + widget + fake-backed repo tests

# Rules suite (emulator; Java 11+ required)
cd tool/rules && npm install
firebase emulators:start --only firestore   # in another terminal
cd tool/rules && npm test

# Race test (the core-requirement gate; Android emulator + Firestore emulator)
firebase emulators:start --only firestore,auth
FIRESTORE_EMULATOR_HOST=localhost:8080 SEED_PREFIX=dev_ node tool/seed/seed.mjs
flutter test integration_test/booking_race_test.dart -d <android-emulator>
```

## Seeding

Rooms are client-read-only by the rules — the catalog is seeded through the Admin SDK (bypasses rules by design):

```bash
FIRESTORE_EMULATOR_HOST=localhost:8080 SEED_PREFIX=dev_ node tool/seed/seed.mjs   # dev
GOOGLE_APPLICATION_CREDENTIALS=<service-account.json> node tool/seed/seed.mjs     # prod
```

## Structure

```
lib/
├── core/          di, routing, theming, helpers (StayDate, FirestorePaths,
│                  Strings), error (Result/FailureCode/mapper), observability
└── features/
    ├── auth/          data/{models,repos} + logic/cubit + ui
    ├── search/        home + live results (stream cubit)
    ├── room_details/  one-shot load + night multi-get availability check
    └── booking/       transaction engine + confirm/conflict/my-bookings
```

Two cubit kinds, never mixed: stream cubits (`connecting/live/empty/failure` with immutable lists) for Firestore streams; terminal action cubits (`idle/submitting/.../failure`) for booking/auth/cancel. `offlinePending` is the honest connectivity outcome — no nights were taken, retry re-validates server-side.
