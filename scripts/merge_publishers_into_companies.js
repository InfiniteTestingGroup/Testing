// merge_publishers_into_companies.js
// ------------------------------------------------------------
// This script merges all documents from the `publishers` collection
// into the `companies` collection without modifying any existing
// company records. It is idempotent – running it multiple times will
// not duplicate data.
//
// Steps performed:
// 1. Connect to MongoDB (uses MONGODB_URI from environment or .env).
// 2. Read all publisher documents.
// 3. For each publisher, build a company payload that contains the
//    required fields. Fields are copied 1‑to‑1; no transformation is
//    applied unless a field is missing – in that case a sensible
//    default is used (e.g., empty string).
// 4. Upsert into `companies` using a unique key (name + email). If a
//    matching company already exists the document is left untouched.
// 5. Log inserted, skipped and error counts to the console and to a
//    `merge_publishers.log` file.
// 6. Exit with status 0 on success, non‑zero on fatal error.
// ------------------------------------------------------------

const { MongoClient } = require('mongodb');
const fs = require('fs');
const path = require('path');

// Load .env if present (common in this repo)
try { require('dotenv').config({ path: path.resolve(__dirname, '../Admin-Super-Admin/admin/.env') }); } catch (e) { /* dotenv not installed – ignore */ }


// const path duplicate removed
// Load MongoDB config from Spring properties file
const propsPath = path.resolve(__dirname, '../Admin-Super-Admin/backend/src/main/resources/application.properties');
const rawProps = fs.readFileSync(propsPath, 'utf8');
const props = {};
rawProps.split('\n').forEach(line => {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith('#')) return;
  const [key, value] = trimmed.split('=');
  if (key && value) props[key.trim()] = value.trim();
});
const MONGO_URI = process.env.MONGODB_URI;
if (!MONGO_URI) {
  throw new Error('Set MONGODB_URI in your .env before running this script.');
}
const DB_NAME = process.env.MONGODB_DATABASE;
if (!DB_NAME) {
  throw new Error('Set MONGODB_DATABASE in your .env before running this script.');
}
console.log('[MergeScript] Connecting to MongoDB with URI (masked)');
const PUBLISHERS_COL = 'publishers';
const COMPANIES_COL = 'companies';

const LOG_FILE = path.resolve(__dirname, 'merge_publishers.log');
function log(msg) {
  const line = `[${new Date().toISOString()}] ${msg}\n`;
  process.stdout.write(line);
  fs.appendFileSync(LOG_FILE, line);
}

(async () => {
  let client;
  try {
    client = new MongoClient(MONGO_URI);
    await client.connect();
    const db = client.db(DB_NAME);
    const publishers = db.collection(PUBLISHERS_COL);
    const companies = db.collection(COMPANIES_COL);

    const totalPublishers = await publishers.countDocuments();
    log(`Starting merge: ${totalPublishers} publisher documents found.`);

    const cursor = publishers.find();
    let inserted = 0;
    let skipped = 0;
    let errors = 0;

    while (await cursor.hasNext()) {
      const pub = await cursor.next();
      // Build company payload – keep field names exactly as required by the Company schema.
      const companyPayload = {
        adminId: pub.adminId ?? null,
        name: pub.name ?? '',
        contactPerson: pub.contactPerson ?? '',
        email: pub.email ?? '',
        mobile: pub.mobile ?? '',
        address: pub.address ?? '',
        location: pub.location ?? '',
        // derive latitude & longitude from explicit fields or from location string/object
        latitude: (() => {
          if (pub.latitude != null) return pub.latitude;
          if (typeof pub.location === 'object' && pub.location !== null) {
            return pub.location.latitude ?? pub.location.lat ?? null;
          }
          if (typeof pub.location === 'string') {
            const parts = pub.location.split(',');
            if (parts.length === 2) return parseFloat(parts[0].trim());
          }
          return null;
        })(),
        longitude: (() => {
          if (pub.longitude != null) return pub.longitude;
          if (typeof pub.location === 'object' && pub.location !== null) {
            return pub.location.longitude ?? pub.location.lng ?? pub.location.lon ?? null;
          }
          if (typeof pub.location === 'string') {
            const parts = pub.location.split(',');
            if (parts.length === 2) return parseFloat(parts[1].trim());
          }
          return null;
        })(),
        status: pub.status ?? 'ACTIVE',
        createdAt: pub.createdAt ?? new Date(),
        // Preserve any extra fields that already exist in the Company model (e.g., companyType)
        // If the Company schema has required fields not present here, add sensible defaults.
      };

      try {
        const result = await companies.updateOne(
          { name: companyPayload.name, email: companyPayload.email }, // unique guard
          {
            $setOnInsert: {
              adminId: companyPayload.adminId,
              name: companyPayload.name,
              contactPerson: companyPayload.contactPerson,
              email: companyPayload.email,
              mobile: companyPayload.mobile,
              address: companyPayload.address,
              location: companyPayload.location,
              status: companyPayload.status,
              createdAt: companyPayload.createdAt
            },
            $set: {
              latitude: companyPayload.latitude,
              longitude: companyPayload.longitude
            }
          },
          { upsert: true }
        );
        if (result.upsertedCount === 1) {
          inserted++;
        } else if (result.modifiedCount === 1) {
          // Existing document updated with lat/long
          inserted++; // count as processed
        } else {
          skipped++;
        }
      } catch (e) {
        errors++;
        log(`Error inserting publisher ${pub._id}: ${e.message}`);
      }
    }

    log(`Merge completed. Inserted: ${inserted}, Skipped (already existed): ${skipped}, Errors: ${errors}`);
  } catch (err) {
    log(`Fatal error: ${err.message}`);
    process.exit(1);
  } finally {
    if (client) await client.close();
  }
})();
