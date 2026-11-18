# Booking App — Search & Conflict-Free Booking Engine

*   **Author:** Mahmoud-Younes
*   **Status:** Proposed
*   **Date:** 2026-11-17

--------------------------------------------------------------------------------

## Overview

A training project for the DEPI program: one Flutter codebase running on Android and Web that implements the core of a hotel-booking product. The screen that matters is a Booking.com-style search: the user picks a destination city, check-in and check-out dates, and a guest count, applies a small filter set, and sees a live list of rooms with prices streamed from Firestore. The defining requirement of the project is that booking conflicts never happen: when several users try to book the same room for overlapping dates at the same moment, exactly one booking succeeds, and every connected user sees availability converge to the truth within one snapshot.

The code structure is feature-first and layered (`features/<name>/{data,logic,ui}`, Cubit + freezed states, get_it, named routes), with repositories as the only Firestore I/O boundary. Stream-backed screens use a stream-state contract (connecting / live / empty / failure) while user actions use terminal states (idle / submitting / success / failure) — the two cubit kinds are never mixed. Conflict prevention is server-enforced with per-night availability documents (`rooms/{roomId}/nights/{yyyy-MM-dd}`), a Firestore transaction per booking, and `firestore.rules` as the second defense line.

## The Problem

Two users booking the same room for overlapping dates is the failure this project exists to prevent, and the obvious implementations all fail silently under concurrency:

*   A plain read-then-write (`get()` then `set()`) lets two simultaneous clients both read "free" and both write "booked" — a double booking with no error raised.
*   Firestore security rules cannot run queries, so a flat `bookings` collection cannot be protected by rules: rules cannot ask "does any existing booking overlap these dates?".
*   Dates stored as strings or local-clock values (e.g. persisting `DateTime.now().toString()`) break the overlap comparison itself: two devices can derive different meanings for the same night, and the system can conclude two bookings do not overlap when they do.

The proposed solution removes client honesty from the equation. Availability is stored as one document per room per night. A booking is a single Firestore transaction that creates exactly the night documents for the requested range plus one human-readable booking document. Rules only allow creating a night document that does not exist yet, so two concurrent bookings collide on the same document ID and the transaction engine picks exactly one winner — even if a client is modified or malicious, because rules run for transactions too. The search screen streams query-scoped snapshots so availability updates live for everyone, and every failed attempt is recorded to an audit collection so the guarantee is provable after the fact.

## Goals

*   **G1 — Conflict-free booking, proven.** Two concurrent bookings for the same room with overlapping dates produce exactly one success and one typed rejection, demonstrated by an integration test against the Firestore emulator before any booking UI is built.
*   **G2 — Live search results.** The results screen streams rooms matching destination city, date window, guest count, and filters (capacity, max price, sort) from Firestore; a booking made by any user updates every connected user's list within one snapshot.
*   **G3 — Layered, feature-first structure.** Code layout, naming, DI, routing, and theming stay consistent under one convention: features own `data`/`logic`/`ui`, repositories are the only I/O boundary, and the two-cubit contract is kept (stream states for streams, terminal states for actions).
*   **G4 — Provable audit trail.** Every booking carries `userId`, `roomId`, `checkIn`, `checkOut`, `createdAt`, `status`, `policyVersion`; every failed attempt writes a best-effort record to `booking_failures` with a typed failure code, so any race is reconstructible from the console.
*   **G5 — Arabic-first UX without raw errors.** Arabic-only RTL interface with all strings in one file; every Firebase error code is mapped to an Arabic message at the repo/cubit boundary; the conflict moment gets a designed full-screen notice with recovery actions, never a bare dialog.
*   **G6 — Web is a real target.** The same codebase reaches the home screen on Chrome before features are built; search parameters live in the URL so refresh and shared links reproduce results; a breakpoint shell keeps web from rendering as a magnified phone.
*   **G7 — Reproducible environments.** Dev and prod Firebase configurations actually differ; a committed idempotent seed script writes hotels/rooms with fixed hand-authored IDs so re-seeding never orphans bookings.

## Non-Goals

*   Real payment processing — a confirmed booking is a Firestore write, nothing more.
*   An admin panel — hotels/rooms come from the seed script only.
*   Reviews, ratings, chat, or notifications (including FCM integration).
*   Multi-language infrastructure — Arabic-only RTL is a constraint, not a foundation for l10n.
*   Search-as-you-type, fuzzy search, or any client-side search service — the "search engine" is one Firestore compound query.
*   Pagination beyond a `limit()` on the results query.
*   Client-side caching layers beyond Firestore's built-in offline persistence.
*   Abstract repository interfaces or a use-case/domain layer — concrete repos with constructor injection are the minimal test seam; the pure overlap function carries the logic.
*   A hand-built calendar widget — framework `showDatePicker` calls only.
*   An adults/children/rooms triple selector — one guests stepper.
*   Analytics, dashboards, alerting, or Cloud Functions.
*   Crash reporting beyond the written decision recorded under Resolved Environment Decisions.

## Open Questions

None remain. OQ1 (crash reporting) and OQ2 (dev/prod isolation) were resolved by the author during drafting (2026-11-17); both decisions are recorded under **Resolved Environment Decisions** in the Technical Plan below.

## Critical User Journeys (CUJs)

### CUJ 1: Search with live results

*   **Given**: The seed script has run; rooms exist in Firestore with city, price, capacity, and image fields; the user is on the results screen.
*   **When**: The user enters "Cairo", a valid date range (check-out at least check-in plus one day, past dates unselectable), and a guest count, then submits.
*   **Then**: The screen streams matching rooms inside a query-scoped, `limit()`-ed snapshot; loading shows a shimmer skeleton; zero matches shows a designed empty state (with "clear filters" when filters are active); a stream failure keeps the last list visible with an inline retry card. Availability stays live: a room booked elsewhere is marked unavailable in place without rows jumping.

### CUJ 2: Successful booking

*   **Given**: The user (signed in) is viewing a result with free nights for the chosen range.
*   **When**: The user taps confirm.
*   **Then**: The button enters a distinct `submitting` state (disabled — double-tap cannot race itself); one transaction creates the night documents and the booking document, or nothing is written; the user sees an Arabic confirmation; the room's denormalized availability flag flips inside the same transaction; every connected user's list updates within one snapshot. If the transaction fails with a connectivity code, the screen enters `offlinePending` stating that no nights were taken, with a retry that re-validates server-side.

### CUJ 3: Conflict loss

*   **Given**: Another user's booking for overlapping nights commits first (or in the same instant).
*   **When**: Our user taps confirm.
*   **Then**: Exactly one of the two transactions commits; the loser's transaction surfaces `conflictLost`; the user gets a full-screen Arabic notice naming the exact dates plus recovery actions (change dates via the picker, see similar rooms, return to results); a best-effort `booking_failures` record is written with the typed code, raw Firebase code, and transaction attempt count.

### CUJ 4: Filter change without churn

*   **Given**: A results list is open and streaming.
*   **When**: The user changes a filter, dates, or guest count.
*   **Then**: The previous list stays visible dimmed while the new query loads; the old subscription is cancelled before the new one attaches (exactly one listener at any time); scroll position is preserved; no data ever wipes to a spinner.

### CUJ 5: Sign in to book, cancel to free nights

*   **Given**: A guest without a session taps confirm on a bookable room.
*   **When**: The user signs in with email/password (or registers; the profile document is written on registration).
*   **Then**: The booking flow resumes and the user can complete CUJ 2. For a booking the user owns, cancellation runs in a transaction that frees the night documents and marks the booking cancelled — never a bare document delete; cancelled bookings are excluded from overlap checks.

### CUJ 6: Web refresh and shared links

*   **Given**: A user is on the results screen in a desktop browser.
*   **When**: The user refreshes, presses browser back, or opens a shared URL such as `/results?city=cairo&in=2026-12-01&out=2026-12-05&guests=2`.
*   **Then**: The router parses search parameters from the route string; every URL-reachable screen survives null typed arguments by loading from IDs; back returns to the search with values restored instead of leaving the site.

--------------------------------------------------------------------------------

## Technical Plan (Architecture)

### Resolved Environment Decisions

*   **Dev/prod isolation — OQ2 resolved by author:** one Firebase project with a collection prefix. The prefix is never assembled per call: a single `FirestorePaths` class owns every collection path and reads the environment constant once, so a missed prefix is structurally impossible. `main_development.dart` selects `dev_`-prefixed paths and dev logging; `main_production.dart` selects unprefixed paths. `firestore.rules` is prefix-aware through the same constant.
*   **Crash reporting — OQ1 resolved by author:** `firebase_crashlytics` wired for Android only, with the Flutter Web gap accepted in writing here: web gets structured logging via `PlatformDispatcher.onError`, never Crashlytics.
*   **Firebase project identity — corrected by author (2026-11-18):** the single Firebase project is `sahety-ba784` (console project name: "firebase", project number 737811383840). A **new** Android app is registered in it for this booking project with package `com.example.booking` — the Flutter project's default `applicationId`, so `android/app/build.gradle` needs no change — plus a **new** Web app for the web target. Pre-existing app registrations in the shared Firebase project are not touched by this design.

### Layered Architecture

```text
┌──────────────────────────────────────────────────────────────────┐
│ ui/            screens + small widgets per feature               │
│                BlocBuilder (streams) / BlocListener (actions)    │
├──────────────────────────────────────────────────────────────────┤
│ logic/         TWO cubit kinds, never mixed:                     │
│                1. Stream cubits  — connecting/live/empty/failure │
│                2. Action cubits  — idle/submitting/…/failure     │
├──────────────────────────────────────────────────────────────────┤
│ data/          repos = only I/O boundary (try/catch + mapping)   │
│                models: freezed + json_serializable               │
│                read/written through .withConverter               │
├──────────────────────────────────────────────────────────────────┤
│ core/          di (get_it), routing (named routes + typed args), │
│                theming (ColorsManager/TextStyles), helpers       │
│                (StayDate, Strings, FirestorePaths, Env),         │
│                shared widgets, error mapping, logging            │
└──────────────────────────────────────────────────────────────────┘
        data/ talks to Firestore via constructor-injected
        FirebaseFirestore (never FirebaseFirestore.instance
        inside features) so tests can point at the emulator.
```

### Component Map

| Component | Kind | Contract |
| --- | --- | --- |
| `SearchCubit` | stream cubit | one `StreamSubscription`, cancelled before every re-query and in `close()`; emits `connecting` once per query change, then `live(immutable list)` / `empty` / `failure(lastList, code)` |
| `SearchRepo` | repository | exposes a cold `Stream<List<Room>>` getter `watchRooms(SearchQuery)` built from a compound Firestore query + `.snapshots()`; never calls `.listen` |
| `BookingCubit` | action cubit | terminal shape: `idle / submitting / offlinePending / bookingSuccess / bookingConflict / bookingFailure(code)`; `offlinePending` fires when the transaction fails with a connectivity code — the UI states plainly that no nights were taken and offers retry; retry re-runs the transaction, which re-validates server-side (offline-pending contract from the concepts brief); owns no stream |
| `BookingRepo` | repository | `attemptBooking(...)` runs the transaction and returns a typed outcome (`success`, `conflictLost`, `ruleDenied`, ...); `cancelBooking(...)` frees nights transactionally; writes best-effort `booking_failures` records outside the transaction |
| `AuthCubit` | action cubit | login/register/logout with terminal states; session source of truth is FirebaseAuth's own persistence via `authStateChanges` (no manual `uId` copies in SharedPreferences — copied session state drifts from reality) |
| `AuthRepo` | repository | email/password flows; writes the user profile document on registration |
| `MyBookingsCubit` | stream cubit | live list of the signed-in user's bookings, same stream-cubit contract |
| `StayDate` (core) | pure utility | UTC `yyyy-MM-dd` value + `nightsBetween` + the half-open overlap predicate; zero Flutter/Firebase imports; all persistence and comparisons go through it |
| `FirestorePaths` (core) | pure utility | every collection/document path in one class; applies the dev prefix from `Env` |
| `FirebaseErrorMapper` (core) | mapper | `FirebaseException` code → typed enum (`authRequired`, `networkUnavailable`, `ruleDenied`, `conflictLost`, `transactionRetryExhausted`, `unknown`) → one Arabic string from the strings file |
| Router (core) | named-route generator | named routes; each route has one typed argument class cast once; results route parses URL query parameters; unknown/null args → load-from-ID path |

### Firestore Data Model

```text
{prefix}rooms/{roomId}
    city, title, pricePerNight, capacity, imageUrl,
    isAvailable (denormalized flag, written inside the booking
                 transaction — allowed to drift only if the
                 transaction is the writer), schemaVersion

{prefix}rooms/{roomId}/nights/{yyyy-MM-dd}     ← existence = booked
    bookingId

{prefix}bookings/{bookingId}
    userId, roomId, checkIn (Timestamp UTC midnight),
    checkOut (Timestamp), createdAt (serverTimestamp),
    status (active | cancelled), policyVersion, schemaVersion

{prefix}booking_failures/{failureId}           ← best-effort audit
    userId?, roomId, checkIn, checkOut, code (typed),
    rawCode (Firebase string), attempts, createdAt

{prefix}users/{uid}
    name, email, avatarUrl?, schemaVersion
```

The night-document ID is the whole guarantee: two concurrent bookings for the same night target the same deterministic path, the transaction engine serializes them, and `firestore.rules` allows `create` only when the document does not exist — the second writer is rejected server-side even from a modified client. Cancelled bookings are excluded from overlap checks because cancellation deletes night documents transactionally rather than flipping a flag.

### Booking Flow (the transaction)

```text
tap confirm (booking action cubit → submitting, button disabled)
   │
BookingRepo.attemptBooking(roomId, StayDateRange, userId)
   │
   ▼
runTransaction ──────────────────────────────────────────────
   1. read rooms/{roomId}/nights/{d} for every d in [in, out)
   2. any night exists            → abort → conflictLost
   3. create the N night docs     { bookingId }
   4. create the bookings doc     { status: active, policyVersion }
   5. update rooms/{roomId}.isAvailable if the range covers "today"
─────────────────────────────────────────────────────────────
   │ success                          │ typed failure
   ▼                                  ▼
BookingCubit.bookingSuccess      map code → Arabic string
confirm screen                   BookingCubit.bookingConflict / bookingFailure
                                 + best-effort booking_failures write
                                  (outside the transaction, errors ignored)
```

The search screen is a separate stream cubit — it needs no code to converge: the transaction's writes push a snapshot to every active listener, and rows update in place keyed by room ID.

### Search Flow

```text
StatefulWidget (dates, guests, filters) — plain setState, no cubit
   │ submit
   ▼
SearchQuery(city, StayDateRange, guests, maxPrice?, sort?)
   │
SearchRepo.watchRooms(query)
   rooms.where('city', isEqualTo: city)
        .where('capacity', isGreaterThanOrEqualTo: guests)
        .where('pricePerNight', isLessThanOrEqualTo: maxPrice?)
        .orderBy('pricePerNight', descending: sortDesc)
        .limit(50)
   │ .snapshots()
   ▼
SearchCubit ── cancel previous subscription, attach new one
   ├─ connecting (before first snapshot)
   ├─ live(List<Room>)      immutable, keyed updates in UI
   ├─ empty                 designed empty state
   └─ failure(code, lastList)  inline retry card, list stays visible
```

While a new query loads, the UI keeps the previous list visible dimmed (CUJ 4). Composite indexes required by this query ship in `firestore.indexes.json` from day one.

### Platform Notes

*   **RTL/Arabic:** app wrapped in RTL `Directionality`; all strings in one constants file; the date picker and conflict notice render under the same directionality with one display format (`d/M/yyyy`).
*   **Web shell:** ScreenUtil stays for mobile; a breakpoint shell (centered max-width container) makes browser layouts read as a page. Web URL strategy: path-based URLs with an SPA rewrite in `firebase.json` (hosting config ships anyway for rules/indexes deployment). `flutter run -d chrome` smoke test is a Stage-1 gate.
*   **Observability wiring:** `Bloc.observer`, `FlutterError.onError`, `PlatformDispatcher.onError`; Crashlytics on Android only; the failure taxonomy is part of the booking contract, not polish.
*   **Stream discipline:** the UI never uses `StreamBuilder` for feature data — `BlocBuilder`/`BlocListener` over cubit states only; every stream subscription carries an `onError` handler that emits the failure state with a typed code.
*   **Quota guardrails:** every listener query-scoped with `limit(50)`; detail screens use one-shot `get()`; filters debounce before re-querying.

## Alternatives Considered

### Alternative A: Flat bookings collection + transaction-only guard

*   **Pros**: Simplest data model; one write per booking; no multi-document transaction for the happy path; smaller rules file.
*   **Cons**: `firestore.rules` cannot run queries, so rules cannot check date overlap; anything bypassing the app (modified client, console write) can double-book; the transaction's read set grows with the room's booking history.
*   **Reason for Rejection**: Rejected by author: the stated guarantee is "no double booking, server-enforced", and only per-night documents make rules a real second defense line.

### Alternative B: Cloud Function callable as the sole booking writer

*   **Pros**: Strongest possible guarantee against misbehaving clients; validation logic lives server-side; no trust placed in any client.
*   **Cons**: Adds a backend runtime, deployment step, and latency; an operational single point of failure; sits outside the Flutter/Firestore learning goals of a training project.
*   **Reason for Rejection**: Rejected during brainstorm: rules plus per-night documents reach the same guarantee inside the platform already in use, with no backend to operate.

### Alternative C: Firestore calls directly inside Cubits

*   **Pros**: Fastest to write; no repo layer to maintain; the fewest moving parts.
*   **Cons**: Contradicts the layered structure (repositories as the only I/O boundary); untestable without a live database; UI-bound cubits tend to leak stream subscriptions and stack listeners across screens; raw Firebase strings reach the UI.
*   **Reason for Rejection**: Rejected by author: repositories stay the only I/O boundary; the leaked-listener mechanics would duplicate live lists and crash closed cubits here.

### Alternative D: Uniform Loading/WithData/NoData/Failure states on every Cubit

*   **Pros**: One mental model for all states; a single uniform shape to memorize.
*   **Cons**: Forces dead states (a booking action cubit can never produce NoData); terminal shapes wipe live data on stream screens; teaches the wrong convention.
*   **Reason for Rejection**: Rejected during brainstorm: "a Cubit's state set is exactly what its data source can produce" — two cubit kinds instead.

### Alternative E: Hand-written `fromJson`/`toMap` models

*   **Pros**: Zero build_runner runs; no generated files to commit; models stay small.
*   **Cons**: Hand-written maps tend toward silent-null bugs (every field nullable, no defaults, asymmetric `fromJson`/`toMap`); map shape duplicated wherever a query is built; no compile-time safety on renames.
*   **Reason for Rejection**: Rejected by author: codegen (freezed + json_serializable) with `withConverter` carrying the map shape in exactly one place; document IDs taken from `doc.id` at the converter boundary, never from the map.

### Alternative F: Hotels + rooms two-collection model

*   **Pros**: Booking.com-like visual hierarchy (hotel card -> rooms); cleaner seed structure; supports hotel-level detail pages.
*   **Cons**: Forces a hand-made join on every search; a second stream per row; nested navigation; nothing in the learning goals needs it.
*   **Reason for Rejection**: Rejected by author: one denormalized `rooms` collection; the hotel hierarchy can be added later if it becomes a stated goal.

### Alternative G: Adults/children/rooms triple guest selector

*   **Pros**: Mirrors Booking.com's search bar faithfully.
*   **Cons**: Adds UI state and an ambiguous mapping question ("2 adults + 1 child = capacity 2 or 3?") without exercising any learning goal differently.
*   **Reason for Rejection**: Rejected by author: one guests stepper feeding `capacity >= guests`; the triple selector is a trivial UI exercise to add later.

### Alternative H: Hand-built range calendar widget

*   **Pros**: Full control over range highlighting and the checkout-day policy display.
*   **Cons**: High build cost; RTL edge cases; duplicated logic with `StayDate`; a known scope trap.
*   **Reason for Rejection**: Rejected by author: framework `showDatePicker` calls behind the check-in/check-out fields; never hand-build.

### Alternative I: Rules using `keys().hasOnly([...])` field allow-listing

*   **Pros**: Tight write-shape control; rejects unexpected fields in rules.
*   **Cons**: Rejects new fields an updated client writes while rules lag behind — every additive schema change becomes an outage until rules redeploy.
*   **Reason for Rejection**: Rejected during brainstorm: additive-only schema evolution is the project's own compatibility rule; allow-listing contradicts it.

### Alternative J: Two separate Firebase projects for dev and prod

*   **Pros**: Full data/quota/rules-blast-radius isolation; each flavor gets its own console, rules, and indexes; seed can run freely against dev.
*   **Cons**: Two consoles to manage; longer initial setup; subject to Google account project quotas; `google-services.json`/options per flavor.
*   **Reason for Rejection**: Rejected by author during drafting (2026-11-17): one Firebase project + a `FirestorePaths`-enforced collection prefix is accepted — simpler setup, single console; the missed-prefix risk is mitigated structurally by the paths class, and the shared-quota trade-off is acceptable at training scale.

### Alternative K: No crash reporting at all (silent omission)

*   **Pros**: Zero dependencies and wiring.
*   **Cons**: Silently omitting observability leaves Android crashes invisible and unaggregated.
*   **Reason for Rejection**: Rejected by author during drafting (2026-11-17): Crashlytics on Android with the documented web gap — the decision is written down instead of omitted.

--------------------------------------------------------------------------------

## Detailed Implementation Plan

One unified list, grouped by the staging order; each stage gates the next. All paths relative to the repository root. Generated files (`.g.dart`, `.freezed.dart`) are created by `build_runner` next to their sources and committed.

### Stage 1 — Firebase foundation (gates everything)

1. `firebase.json` (Create) — Registers `firestore` (rules + indexes), `emulators` (firestore, auth), and `hosting` with an SPA rewrite (`/index.html` for any non-file route) enabling path-based web URLs. Without this block the rules and indexes cannot deploy and web refresh breaks.
2. `firestore.rules` (Create) — Prefix-aware rules: night documents are create-only (create succeeds only when the document does not exist, path date components must match field dates, room must exist in the catalog), bookings readable/writable only by their owner, rooms read-only for clients, `booking_failures` create-only. A header comment restates the transaction invariant. This is the second defense line of the core guarantee.
3. `firestore.indexes.json` (Create) — Composite indexes for the search query (`city ASC + capacity ASC + pricePerNight ASC`) and for `bookings` by `userId + createdAt`. Missing indexes surface only at runtime as failed queries.
4. `lib/firebase_options.dart` (Create, generated) — FlutterFire CLI output for android + web against project `sahety-ba784` (`flutterfire configure --project=sahety-ba784`); the CLI registers a **new** Android app (`com.example.booking`) and a **new** Web app in that project, leaving pre-existing registrations untouched. `main_production.dart`/`main_development.dart` depend on it; the web platform entry must exist or the app throws on Chrome.
5. `android/app/google-services.json` (Create, generated) — FlutterFire CLI output for the newly registered package `com.example.booking`; required for Android builds.
6. `lib/main_development.dart` (Create) — Entry point selecting dev environment (`Env.dev`: `dev_` prefix, debug logging level, no Crashlytics), runs `WidgetsFlutterBinding.ensureInitialized`, `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`, `setupGetIt()`, `ScreenUtil.ensureScreenSize()`, Crashlytics wiring only `if (!kIsWeb && Platform.isAndroid)`, then `runApp(BookingApp(...))`. Replaces the default counter `main.dart`.
7. `lib/main_production.dart` (Create) — Identical shape with `Env.prod` (no prefix, Crashlytics on Android, info logging). `lib/main.dart` (Delete) — the Flutter default counter app is removed.
8. `lib/booking_app.dart` (Create) — `MaterialApp` with RTL `Directionality`, `ScreenUtilInit(designSize: 375x812, minTextAdapt: true)` wrapped in `BreakpointShell`, `onGenerateRoute: appRouter.generateRoute`, `initialRoute` from `authStateChanges` (logged-in → home, else login).

### Stage 2 — Core utilities (pure, testable before any feature)

9. `lib/core/env/env.dart` (Create) — `Env` sealed class with `dev`/`prod` const instances: `collectionPrefix`, `enableCrashlytics`, `logLevel`. Flavor entry points pass one instance into `setupGetIt(env)`.
10. `lib/core/data/firestore_paths.dart` (Create) — Every collection and document path in one class (`rooms`, `roomNights(roomId)`, `nightDoc(roomId, date)`, `bookings`, `bookingFailures`, `users`), applying `Env.collectionPrefix` exactly once. Structurally makes a missed prefix impossible.
11. `lib/core/helpers/stay_date.dart` (Create) — Pure `StayDate` (UTC `yyyy-MM-dd`), `nightsBetween`, `StayDateRange`, and the half-open overlap predicate `[checkIn, checkOut)`. Zero Flutter/Firebase imports — the whole date contract of the design lives here.
12. `test/core/helpers/stay_date_test.dart` (Create) — Boundary tests: equal check-ins, equal check-outs, adjacent ranges (checkout day sellable), inverted ranges, 30-night maximum, midnight normalization.
13. `lib/core/error/failure_code.dart` (Create) — Typed enum: `authRequired`, `networkUnavailable`, `ruleDenied`, `conflictLost`, `transactionRetryExhausted`, `unknown`; carries the raw Firebase code alongside.
14. `lib/core/error/result.dart` (Create) — Freezed `Result<T>` (`success(data)` / `failure(BookingFailure)`) — a success/failure envelope every action repo method returns and the cubit unwraps; `BookingFailure` holds `FailureCode` + raw code.
15. `lib/core/error/firebase_error_mapper.dart` (Create) — Maps `FirebaseException` codes and transaction aborts to `FailureCode`; the single place where raw Firebase errors are interpreted, so none ever reach the UI.
16. `lib/core/theming/colors.dart`, `lib/core/theming/styles.dart`, `lib/core/theming/font_weight_helper.dart` (Create) — `ColorsManager` and `TextStyles` static styles with `.sp` and a Booking-like palette.
17. `lib/core/helpers/spacing.dart`, `lib/core/helpers/extensions.dart`, `lib/core/helpers/app_regex.dart`, `lib/core/helpers/constants.dart` (Create) — `verticalSpace`/`horizontalSpace`, navigation extensions (`pushNamed`, `pushReplacementNamed`, `pushNamedAndRemoveUntil`, `pop`), validators, and constants (`maxStayNights = 30`, `resultsLimit = 50`, cache keys).
18. `lib/core/localization/app_strings.dart` (Create) — Every Arabic UI string as a constant, including mapped failure messages; the only place UI text exists.
19. `lib/core/observability/logger.dart`, `lib/core/observability/app_bloc_observer.dart` (Create) — One structured-logging format for both platforms; `BlocObserver` logging transitions/errors; wired in both entry points.
20. `lib/core/widgets/app_text_button.dart`, `lib/core/widgets/app_text_form_field.dart` (Create) — Shared styled widgets used by every form.
21. `lib/core/widgets/empty_state_view.dart`, `lib/core/widgets/failure_retry_card.dart`, `lib/core/widgets/shimmer_box.dart` (Create) — The designed loading/empty/failure pieces every screen reuses.
22. `lib/core/widgets/breakpoint_shell.dart` (Create) — Centered max-width container over ScreenUtil so web reads as a page.
23. `lib/core/di/dependency_injection.dart` (Create) — `setupGetIt(env)`: `FirebaseFirestore`/`FirebaseAuth` as lazySingletons, repos as lazySingletons, cubits as factories — stream cubits strictly factories (screen-bound).
24. `lib/core/routing/routes.dart`, `lib/core/routing/app_router.dart` (Create) — Route name constants; `generateRoute` switch casting one typed argument class per route; results route parses URL query parameters (`city`, `in`, `out`, `guests`); every URL-reachable route survives null args by loading from ID.
25. `lib/core/widgets/app_network_image.dart` (Create) — `cached_network_image` wrapper with shimmer placeholder for room images.

### Stage 3 — Data models, auth, seed (gates search)

26. `lib/features/auth/data/models/login_request_body.dart`, `lib/features/auth/data/models/sign_up_request_body.dart` (Create) — Freezed request bodies (email, password, name).
27. `lib/features/auth/data/models/user_profile.dart` (Create) — Freezed profile model (`name`, `email`, `schemaVersion`) written to `users/{uid}` on registration; additive-only defaults in `fromJson`.
28. `lib/features/auth/data/repos/auth_repo.dart` (Create) — `signIn`, `signUp` (create user + write profile doc), `signOut`; returns `Result<T>`; constructor-injected `FirebaseAuth` and `FirebaseFirestore`. Login and sign-up share one auth feature instead of two duplicate features.
29. `lib/features/auth/logic/cubit/login_cubit.dart`, `lib/features/auth/logic/cubit/login_state.dart` (Create) — Terminal action cubit: `idle/loginLoading/loginSuccess/loginFailure(BookingFailure)`.
30. `lib/features/auth/logic/cubit/sign_up_cubit.dart`, `lib/features/auth/logic/cubit/sign_up_state.dart` (Create) — Same terminal contract; profile-doc write included in the success path.
31. `lib/features/auth/ui/screens/login_screen.dart`, `lib/features/auth/ui/screens/sign_up_screen.dart` (Create) — RTL forms with inline field validation (`app_regex`), `login_bloc_listener.dart` widget handling loading/success/error.
32. `lib/features/search/data/models/room.dart` (Create) — Freezed + json_serializable `Room` (`city`, `title`, `pricePerNight`, `capacity`, `imageUrl`, `isAvailable`, `schemaVersion`) with `Timestamp ↔ DateTime` converters and the `withConverter` extension for the rooms collection.
33. `lib/features/booking/data/models/booking.dart`, `lib/features/booking/data/models/booking_failure_record.dart` (Create) — Freezed models for the audit trail documents (`bookings`, `booking_failures`) with `policyVersion` and `schemaVersion` fields; `withConverter` extensions for both paths.
34. `lib/features/search/data/models/search_query.dart` (Create) — Value object: `city`, `StayDateRange`, `guests`, `maxPrice?`, `sortDescending`; the one object the results route parses from URL.
35. `tool/seed/seed_data.json` (Create) — Committed fixture: ~10 rooms across 3 cities with fixed hand-authored IDs (`room_cairo_01`, ...), stable prices/capacities.
36. `tool/seed/seed.dart` (Create) — Idempotent seed script writing the fixture through `FirestorePaths` with fixed IDs; safe to re-run; targets whichever `Env` it is given (dev by default).

### Stage 4 — Search (gates booking UX)

37. `lib/features/search/data/repos/search_repo.dart` (Create) — `watchRooms(SearchQuery)` cold `Stream<List<Room>>` from the compound query + `.snapshots()` through `withConverter`; `getRoom(id)` one-shot; never calls `.listen`; constructor-injected `FirebaseFirestore`.
38. `lib/features/search/logic/cubit/search_cubit.dart`, `lib/features/search/logic/cubit/search_state.dart` (Create) — Stream cubit per the state contract: one `StreamSubscription` field, cancel-before-requery, `close()` cancels; states `connecting/live(List<Room>)/empty/failure(lastList, FailureCode)` with immutable lists.
39. `lib/features/search/ui/screens/home_screen.dart` (Create) — Search form: `destination_field.dart`, `date_range_fields.dart` (two `showDatePicker` calls, checkout min = checkin + 1, past dates unselectable), `guests_stepper.dart`, `search_button.dart` — plain `setState`, no cubit.
40. `lib/features/search/ui/screens/results_screen.dart` (Create) — Live results: `results_bloc_builder.dart` (shimmer → list → empty → inline retry), `results_list.dart` + `result_item.dart` (stable keys by room ID, in-place updates, sold-out marked in place), `filters_bar.dart` (capacity, max price, sort — debounced), `results_shimmer.dart`, `empty_results_view.dart` (with clear-filters action). Previous list stays dimmed while a new query loads (CUJ 4).
41. `lib/features/room_details/ui/screens/room_details_screen.dart` (Create) — One-shot `getRoom(id)` load exercising the load-from-ID path for shared links; info + book CTA. Backed by `lib/features/room_details/data/repos/room_details_repo.dart` (Create).

### Stage 5 — Booking engine (the core-requirement gate)

42. `lib/features/booking/data/repos/booking_repo.dart` (Create) — `attemptBooking(userId, roomId, StayDateRange)`: one `runTransaction` reading every night doc in `[in, out)`, aborting with `conflictLost` on any existing night, creating night docs + booking doc + the room availability flag update in one commit; `cancelBooking(bookingId)` frees nights + flips status transactionally; best-effort `booking_failures` write on every failure branch (errors ignored); constructor-injected `FirebaseFirestore`.
43. `lib/features/booking/logic/cubit/booking_cubit.dart`, `lib/features/booking/logic/cubit/booking_state.dart` (Create) — Action cubit: `idle/submitting/offlinePending/bookingSuccess/bookingConflict/bookingFailure(BookingFailure)`; owns no stream; `submitting` disables the confirm button (double-tap cannot race itself).
44. `integration_test/booking_race_test.dart` (Create) — Against the Firestore emulator: two concurrent `attemptBooking` calls for the same room with overlapping dates; asserts exactly one commit and one `conflictLost`; plus a cancellation test asserting nights are freed and re-bookable. **This test passing is the gate for the core requirement — nothing in Stage 6 starts before it passes.**
45. `tool/rules/package.json`, `tool/rules/rules_test.mjs` (Create) — `@firebase/rules-unit-testing` suite run under `firebase emulators:exec`: a direct SDK write cannot create an existing night document, cannot write to another user's booking, cannot write rooms; a client can only create nights with path-matching dates.
46. `.github/workflows/ci.yml` (Create) — `flutter analyze`, `dart format --set-exit-if-changed`, `build_runner` freshness check, `flutter test`, rules suite under emulators, integration race test on an Android emulator. Runs on any change to rules, indexes, models, or booking code.
46b. `docs/runbooks/booking_cleanup.md` (Create) — Operational runbook backed by the `status` and `createdAt` fields present from the first booking write: list a room's bookings ordered by `createdAt`, cancel the later of any overlapping pair, free the nights transactionally. Committed from day one so a bad write is cleanable without redesign.

### Stage 6 — Booking UX (after the race test gate)

47. `lib/features/booking/ui/screens/booking_confirm_screen.dart` (Create) — Room summary + chosen dates + confirm button wired to `BookingCubit` (`submitting` disables).
48. `lib/features/booking/ui/screens/conflict_screen.dart` (Create) — Full-screen Arabic notice naming the exact dates with recovery actions: change dates (reopen picker), see similar rooms (re-run search same city), return to results (CUJ 3).
49. `lib/features/booking/ui/screens/my_bookings_screen.dart` (Create) — Live list of the user's bookings: `my_bookings_cubit.dart`/`my_bookings_state.dart` (Create, stream cubit, same contract as search), `booking_item.dart`, `cancel_button.dart`, `my_bookings_bloc_builder.dart`.
50. `lib/features/booking/ui/widgets/confirm_bloc_listener.dart` (Create) — Success → confirmation view; conflict → `conflict_screen`; `offlinePending` → the no-nights-taken notice with retry; failure → mapped Arabic message.

### Stage 7 — Web and polish

51. `lib/core/widgets/breakpoint_shell.dart` refinement — max-width and padding tuned on Chrome; `flutter run -d chrome` smoke verified against home, results (with URL params), and refresh-on-results.
52. `README.md` (Modify) — Project overview, setup (FlutterFire CLI, emulators, seed), run commands for both flavors and web, test commands.
53. `pubspec.yaml` (Modify) — Add `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_crashlytics`, `flutter_bloc`, `freezed_annotation`, `get_it`, `cached_network_image`, `shimmer`, `flutter_screenutil`; dev: `build_runner`, `freezed`, `json_serializable`, `fake_cloud_firestore`. (Listed last because the dependency set is finalized here, but the file itself changes in Stage 1 when the first Firebase package lands.)

### Test Layers (unit / widget / integration / e2e)

*   **Unit** — pure logic, no Firebase: `test/core/helpers/stay_date_test.dart` (boundary suite), `test/core/data/firestore_paths_test.dart` (dev prefix applied exactly once; unprefixed in prod), `test/core/error/firebase_error_mapper_test.dart` (the mapping table: raw Firebase codes and transaction aborts → typed codes).
*   **Widget** — screens driven by fake cubits, wrapped in RTL `Directionality`: `test/features/search/ui/results_screen_test.dart` (shimmer → live → empty → failure with inline retry; previous list dimmed during re-query), `test/features/booking/ui/booking_confirm_screen_test.dart` (`submitting` disables confirm; conflict/failure dispatch; `offlinePending` notice), `test/features/auth/ui/login_screen_test.dart` (inline field validation, mapped error message). Dev dependencies added for this layer: `bloc_test`, `mocktail`.
*   **Integration** — repositories and rules against fakes/emulators: the race test (item 44), search-repo and booking-repo suites against `fake_cloud_firestore` (live/empty/failure stream transitions; the best-effort audit write on failure branches), the Node rules suite (item 45), and the seed idempotency run (item 36). The race-test integration suite additionally needs the `integration_test` SDK package in dev dependencies.
*   **E2E** — full user journeys on an Android emulator with the Firestore emulator, driven by `integration_test` + `flutter drive`: `test_driver/e2e.dart` (driver entry), `integration_test/e2e/search_e2e_test.dart` (CUJ 1: search → live results), `integration_test/e2e/booking_e2e_test.dart` (CUJ 2 success; CUJ 3 conflict exercised by pre-creating the conflicting night documents through a second Firebase app instance), `integration_test/e2e/auth_cancel_e2e_test.dart` (CUJ 5: register → book → cancel frees nights). Additionally, the agentic web-E2E CLI (`npx e2e init`: `package.json`, `e2e.config.ts`, `tests/`, MCP-server configs) is scaffolded **locally only** — its entire footprint is `.gitignore`d and never pushed.

### Verification Plan

*   **Static analysis**: `flutter analyze` clean; `dart format --set-exit-if-changed .`.
*   **Codegen freshness**: `dart run build_runner build --delete-conflicting-outputs` produces zero diffs after a clean checkout.
*   **Unit tests**: `flutter test` — `StayDate` boundary suite, `FirestorePaths` prefix correctness, `FirebaseErrorMapper` mapping table.
*   **Widget tests**: `flutter test` — results-screen state machine (shimmer/live/empty/failure), booking confirm (`submitting` disable, conflict dispatch, offline-pending notice), login form validation — all under RTL.
*   **Integration tests**: `flutter test` — search/booking repos against `fake_cloud_firestore` (stream transitions; best-effort audit write on failure branches); rules suite under emulators; seed idempotency.
*   **E2E**: `flutter drive --driver=test_driver/e2e.dart --target=integration_test/e2e/<suite> -d <android-emulator>` against the Firestore emulator — search (CUJ 1), booking success + conflict (CUJ 2/3), auth → book → cancel (CUJ 5).
*   **Rules tests**: `firebase emulators:exec --only firestore "node tool/rules/rules_test.mjs"` — night-document create-only, ownership, and room-write restrictions.
*   **Race test (core-requirement gate)**: `flutter test integration_test/booking_race_test.dart` on an Android emulator with Firestore emulator — exactly one winner per conflicting pair; cancellation frees nights.
*   **Web smoke**: `flutter run -d chrome` reaches home; `/results?...` URL reproduces results; refresh and back behave per CUJ 6.
*   **Manual pass**: CUJs 1–6 walked through on Android emulator and Chrome against seeded dev data.

--------------------------------------------------------------------------------

### Additional Resources

*   `concepts_brief.md` — brainstorm artifact: 7-lens Goldfish review, resolved decisions, alternatives.
*   `concepts_context.md` — verified project-context facts used by reviewers.

*Drafted with EGM*
