// firestore.rules test suite — the second defense line's own test plan.
//
// Run (Node 20+, Java 11+ for the emulator):
//   cd tool/rules && npm install
//   firebase emulators:exec --only firestore "npm test"
//
// The suite pins BOTH collection families (unprefixed + dev_) so prefix
// drift between the Dart FirestorePaths constant and this static file
// surfaces in CI.
import assert from 'node:assert';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';

const PROJECT_ID = 'rules-test-booking';
const HOST = process.env.FIRESTORE_EMULATOR_HOST ?? 'localhost:8080';

const testEnv = await initializeTestEnvironment({
  projectId: PROJECT_ID,
  firestore: { host: HOST.split(':')[0], port: Number(HOST.split(':')[1] ?? 8080), rules: undefined },
});

/** Creates a night doc body bound to a booking the test created. */
async function seedBookingFor(db, userId, roomId, from, to) {
  const bookingRef = db.collection('bookings').doc();
  await bookingRef.set({
    userId,
    roomId,
    checkIn: new Date(from),
    checkOut: new Date(to),
    checkInEpochDay: Math.floor(new Date(from).getTime() / 86400000),
    checkOutEpochDay: Math.floor(new Date(to).getTime() / 86400000),
    status: 'active',
    policyVersion: 1,
    schemaVersion: 1,
  });
  return bookingRef;
}

function epochDay(dateStr) {
  return Math.floor(new Date(dateStr).getTime() / 86400000);
}

const SCENARIOS = [
  {
    name: 'a signed-in client CANNOT create a night for another user’s booking (ownership)',
    fn: async () => {
      const attackerDb = testEnv.authenticatedContext('attacker').firestore();
      
      // Seed a legit booking owned by 'victim' via a privileged path:
      const victimDb = testEnv.authenticatedContext('victim').firestore();
      const bookingRef = victimDb.collection('bookings').doc();
      await bookingRef.set({
        userId: 'victim',
        roomId: 'room_x',
        checkInEpochDay: epochDay('2027-01-01'),
        checkOutEpochDay: epochDay('2027-01-03'),
        status: 'active',
        policyVersion: 1,
        schemaVersion: 1,
        checkIn: new Date('2027-01-01'),
        checkOut: new Date('2027-01-03'),
      });
      // The attacker references the victim's booking: rules must reject.
      await assertFails(
        attackerDb.collection('rooms/room_x/nights').doc(String(epochDay('2027-01-01'))).set({
          bookingId: bookingRef.id,
          epochDay: epochDay('2027-01-01'),
        }),
      );
    },
  },
  {
    name: 'the booking owner CAN create nights bound to their own booking',
    fn: async () => {
      const db = testEnv.authenticatedContext('owner').firestore();
      const bookingRef = await seedBookingFor(db, 'owner', 'room_y', '2027-02-01', '2027-02-03');
      await assertSucceeds(
        db.collection('rooms/room_y/nights').doc(String(epochDay('2027-02-01'))).set({
          bookingId: bookingRef.id,
          epochDay: epochDay('2027-02-01'),
        }),
      );
    },
  },
  {
    name: 'dev family: the owner CAN create nights bound to their own dev_bookings doc',
    fn: async () => {
      // Regression pin: a dev night must read its booking from dev_bookings —
      // pointing at the unprefixed family reads a missing document and would
      // deny every dev booking.
      const db = testEnv.authenticatedContext('dev_owner').firestore();
      const bookingRef = db.collection('dev_bookings').doc();
      await bookingRef.set({
        userId: 'dev_owner',
        roomId: 'dev_room_y',
        checkIn: new Date('2027-02-01'),
        checkOut: new Date('2027-02-03'),
        checkInEpochDay: epochDay('2027-02-01'),
        checkOutEpochDay: epochDay('2027-02-03'),
        status: 'active',
        policyVersion: 1,
        schemaVersion: 1,
      });
      await assertSucceeds(
        db.collection('dev_rooms/dev_room_y/nights').doc(String(epochDay('2027-02-01'))).set({
          bookingId: bookingRef.id,
          epochDay: epochDay('2027-02-01'),
        }),
      );
    },
  },
  {
    name: 'a night doc CANNOT be created when it already exists (no double booking)',
    fn: async () => {
      const dbA = testEnv.authenticatedContext('owner_a').firestore();
      const dbB = testEnv.authenticatedContext('owner_b').firestore();
      const refA = await seedBookingFor(dbA, 'owner_a', 'room_z', '2027-03-01', '2027-03-03');
      const refB = await seedBookingFor(dbB, 'owner_b', 'room_z', '2027-03-01', '2027-03-03');
      const nightRef = dbA.collection('rooms/room_z/nights').doc(String(epochDay('2027-03-01')));
      await assertSucceeds(
        nightRef.set({ bookingId: refA.id, epochDay: epochDay('2027-03-01') }),
      );
      await assertFails(
        dbB.collection('rooms/room_z/nights').doc(String(epochDay('2027-03-01'))).set({
          bookingId: refB.id,
          epochDay: epochDay('2027-03-01'),
        }),
      );
    },
  },
  {
    name: 'a night doc CANNOT be deleted by anyone but the referenced booking’s owner',
    fn: async () => {
      const ownerDb = testEnv.authenticatedContext('night_owner').firestore();
      const bookingRef = await seedBookingFor(ownerDb, 'night_owner', 'room_d', '2027-04-01', '2027-04-02');
      const nightRef = ownerDb.collection('rooms/room_d/nights').doc(String(epochDay('2027-04-01')));
      await assertSucceeds(
        nightRef.set({ bookingId: bookingRef.id, epochDay: epochDay('2027-04-01') }),
      );
      const attackerDb = testEnv.authenticatedContext('night_attacker').firestore();
      await assertFails(nightRef.delete());
      await assertSucceeds(nightRef.delete());
    },
  },
  {
    name: 'clients CANNOT write rooms at all',
    fn: async () => {
      const db = testEnv.authenticatedContext('writer').firestore();
      await assertFails(db.collection('rooms').doc('room_new').set({ city: 'x' }));
    },
  },
  {
    name: 'registration CAN write its own users doc, CANNOT touch others',
    fn: async () => {
      const db = testEnv.authenticatedContext('new_user').firestore();
      await assertSucceeds(db.collection('users').doc('new_user').set({ name: 'x', email: 'x@y.z' }));
      await assertFails(db.collection('users').doc('other_user').set({ name: 'x' }));
    },
  },
  {
    name: 'a booking CANNOT exceed the 30-night maximum (server-enforced)',
    fn: async () => {
      const db = testEnv.authenticatedContext('greedy').firestore();
      await assertFails(
        db.collection('bookings').doc().set({
          userId: 'greedy',
          roomId: 'room_g',
          checkIn: new Date('2027-05-01'),
          checkOut: new Date('2027-08-01'),
          checkInEpochDay: epochDay('2027-05-01'),
          checkOutEpochDay: epochDay('2027-08-01'),
          status: 'active',
          policyVersion: 1,
          schemaVersion: 1,
        }),
      );
    },
  },
  {
    name: 'a booking CANNOT start in the past',
    fn: async () => {
      const db = testEnv.authenticatedContext('time_traveler').firestore();
      await assertFails(
        db.collection('bookings').doc().set({
          userId: 'time_traveler',
          roomId: 'room_p',
          checkIn: new Date('2020-01-01'),
          checkOut: new Date('2020-01-03'),
          checkInEpochDay: epochDay('2020-01-01'),
          checkOutEpochDay: epochDay('2020-01-03'),
          status: 'active',
          policyVersion: 1,
          schemaVersion: 1,
        }),
      );
    },
  },
];

let passed = 0;
for (const scenario of SCENARIOS) {
  try {
    await scenario.fn();
    passed += 1;
    console.log(`✓ ${scenario.name}`);
  } catch (error) {
    console.error(`✗ ${scenario.name}`);
    console.error(error);
    process.exitCode = 1;
  } finally {
    await testEnv.clearFirestoreData();
  }
}

console.log(`\n${passed}/${SCENARIOS.length} rules scenarios passed`);
await testEnv.cleanup();
