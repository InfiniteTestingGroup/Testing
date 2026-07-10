const { MongoClient } = require('mongodb');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../Admin-Super-Admin/admin/.env') });

const MONGO_URI = process.env.MONGODB_URI;
if (!MONGO_URI) {
  throw new Error('Set MONGODB_URI in your .env before running this script.');
}
const DB_NAME = process.env.MONGODB_DATABASE;
if (!DB_NAME) {
  throw new Error('Set MONGODB_DATABASE in your .env before running this script.');
}
(async () => {
  const client = new MongoClient(MONGO_URI);
  try {
    await client.connect();
    const db = client.db(DB_NAME);
    const companies = db.collection('companies');
    const count = await companies.countDocuments();
    console.log('Total companies:', count);
    const sample = await companies.find().limit(5).toArray();
    console.log('Sample documents:', JSON.stringify(sample, null, 2));
  } catch (e) {
    console.error('Error:', e);
  } finally {
    await client.close();
  }
})();
