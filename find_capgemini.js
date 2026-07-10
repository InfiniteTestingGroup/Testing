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
    
    const capgemini = await db.collection('companies').findOne({ name: 'Capgemini' });
    console.log('Capgemini Document:', JSON.stringify(capgemini, null, 2));
    
  } catch (error) {
    console.error(error);
  } finally {
    await client.close();
  }
}

main();
