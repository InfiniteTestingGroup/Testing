import { MongoClient } from 'mongodb';
import bcrypt from 'bcryptjs';
const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);
async function run() {
  if (process.env.ALLOW_DB_WRITE !== 'true') {
    throw new Error('Refusing to write to MongoDB. Set ALLOW_DB_WRITE=true only when you intentionally want to upsert a test admin.');
  }
  if (!uri) {
    throw new Error('Set MONGODB_URI before running this script.');
  }

  try {
    await client.connect();
    const database = client.db(process.env.MONGODB_DATABASE || 'keliri_production');
    const users = database.collection('users');
    
    // Hash password "Password@123"
    const passwordHash = await bcrypt.hash("Password@123", 10);
    
    const testAdmin = {
      fullName: "Test Admin User",
      phoneNumber: {
        countryCode: "+91",
        dialNumber: "9999999999"
      },
      emailAddress: "testadmin@keliri.com",
      userType: "ADMIN",
      givendor: 1,
      latitude: 0,
      longitude: 0,
      password: passwordHash,
      companyName: "Koppa Hardware's & Paint's",
      companyUID: "64fb117a-f530-4f98-a5d3-21f7feec9047", // Use a valid company UID from .env VITE_AD_MOBILE_TOKEN
      accountStatus: "ACTIVE",
      _class: "org.jackfruit.keliri.model.users"
    };
    // Upsert testAdmin
    const result = await users.replaceOne(
      { emailAddress: "testadmin@keliri.com" },
      testAdmin,
      { upsert: true }
    );
    
    console.log("Upserted test admin:");
    console.log(result);
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
