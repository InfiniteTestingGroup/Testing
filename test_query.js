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
    
    // Find in companies
    const company = await db.collection('companies').findOne({ email: 'prakash@gmail.com' });
    console.log('Company lookup for prakash@gmail.com:', company);
    
    // Find in users
    const user = await db.collection('users').findOne({ email: 'prakash@gmail.com' });
    console.log('User lookup for prakash@gmail.com:', user);
    
    // Find recently created companies (last 5)
    const recentCompanies = await db.collection('companies').find({}).sort({ createdAt: -1 }).limit(5).toArray();
    console.log('Recent Companies:', recentCompanies.map(c => ({ _id: c._id, name: c.name, email: c.email, createdAt: c.createdAt })));

    // Find recently created users (last 5)
    const recentUsers = await db.collection('users').find({}).sort({ createdAt: -1 }).limit(5).toArray();
    console.log('Recent Users:', recentUsers.map(u => ({ _id: u._id, name: u.name, email: u.email, createdAt: u.createdAt })));
    
  } catch (error) {
    console.error(error);
  } finally {
    await client.close();
  }
}

main();
