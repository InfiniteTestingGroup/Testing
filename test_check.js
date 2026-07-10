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
console.log('Using MONGODB_URI:', uri);

async function main() {
  if (!uri) {
    console.error('No MONGODB_URI found in .env');
    return;
  }
  const client = new MongoClient(uri);
  try {
    await client.connect();
    console.log('Connected to MongoDB successfully!');
    
    // 1. List all databases
    const adminDb = client.db().admin();
    const dbsList = await adminDb.listDatabases();
    console.log('\n--- Databases ---');
    console.log(dbsList.databases.map(d => `${d.name} (${d.sizeOnDisk} bytes)`));
    
    // 2. Query collections in each database to see if "companies" or similar exists
    for (const dbInfo of dbsList.databases) {
      const dbName = dbInfo.name;
      if (dbName === 'local' || dbName === 'config') continue;
      
      const db = client.db(dbName);
      const collections = await db.listCollections().toArray();
      console.log(`\nDatabase: ${dbName} | Collections:`, collections.map(c => c.name));
      
      for (const col of collections) {
        if (col.name.toLowerCase().includes('compan') || col.name.toLowerCase().includes('publish')) {
          const count = await db.collection(col.name).countDocuments();
          console.log(`  Collection: ${col.name} | Count: ${count}`);
          
          // Print one sample document from this collection
          const sample = await db.collection(col.name).findOne({});
          if (sample) {
            console.log(`  Sample from ${col.name}:`, JSON.stringify(sample, null, 2));
          }
        }
      }
    }
    
  } catch (error) {
    console.error('Error connecting/querying:', error);
  } finally {
    await client.close();
  }
}

main();
