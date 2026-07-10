const { MongoClient } = require('mongodb');
const fs = require('fs');
const path = require('path');

// Read MONGODB_URI from .env
const envPath = path.join(__dirname, '.env');
const envContent = fs.readFileSync(envPath, 'utf8');
const env = {};
envContent.split('\n').forEach(line => {
  const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
  if (match) {
    let value = match[2] ? match[2].trim() : '';
    if (value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1);
    }
    env[match[1]] = value;
  }
});

const uri = env.MONGODB_URI;
const dbName = env.MONGODB_DATABASE || 'keliri_production';

async function main() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    const db = client.db(dbName);
    
    const sampleUser = await db.collection('users').findOne({ email: { $exists: true } });
    console.log('Sample User with email:', JSON.stringify(sampleUser, null, 2));

    const sampleUserNoEmail = await db.collection('users').findOne({ email: { $exists: false } });
    console.log('Sample User without email:', JSON.stringify(sampleUserNoEmail, null, 2));

    // Also look at user_profiles
    const sampleProfile = await db.collection('user_profiles').findOne({});
    console.log('Sample User Profile:', JSON.stringify(sampleProfile, null, 2));
    
  } catch (error) {
    console.error(error);
  } finally {
    await client.close();
  }
}

main();
