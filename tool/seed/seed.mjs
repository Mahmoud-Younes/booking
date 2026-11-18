// Idempotent seed script — writes fixed-ID rooms into Firestore.
//
// Runs through the ADMIN SDK, which bypasses security rules by design: the
// rules make `rooms` client-read-only and catalog writes come from seeding
// only. The collection prefix mirrors FirestorePaths
// (lib/core/data/firestore_paths.dart) — keep the two in lockstep.
//
// Usage (development, against the emulator — no credentials needed):
//   firebase emulators:start --only firestore
//   FIRESTORE_EMULATOR_HOST=localhost:8080 SEED_PREFIX=dev_ node tool/seed/seed.mjs
//
// Usage (production project):
//   GOOGLE_APPLICATION_CREDENTIALS=<service-account.json> node tool/seed/seed.mjs
//
// Idempotency: every write targets a fixed hand-authored document ID with
// the same fields, so re-running never orphans existing bookings. Verify by
// running twice and asserting the room set is unchanged.
import { readFileSync } from 'node:fs';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const data = JSON.parse(
  readFileSync(new URL('./seed_data.json', import.meta.url), 'utf8'),
);
const prefix = process.env.SEED_PREFIX ?? '';
const projectId = process.env.SEED_PROJECT_ID ?? 'sahety-ba784';

initializeApp({ projectId });
const db = getFirestore();

const batch = db.batch();
for (const room of data.rooms) {
  batch.set(db.collection(`${prefix}rooms`).doc(room.id), {
    city: room.city,
    title: room.title,
    pricePerNight: room.pricePerNight,
    capacity: room.capacity,
    imageUrl: room.imageUrl,
    schemaVersion: data.schemaVersion,
  });
}
await batch.commit();
console.log(
  `Seeded ${data.rooms.length} rooms into "${prefix}rooms" (project: ${projectId})`,
);
