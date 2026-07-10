const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI;
const dbName = process.env.MONGODB_DATABASE || "keliri_production";

async function main() {
    const client = new MongoClient(uri);
    try {
        if (!uri) {
            throw new Error("Set MONGODB_URI before running this script.");
        }
        await client.connect();
        console.log("Connected to replicated EC2 MongoDB");
        const db = client.db(dbName);

        const admins = await db.collection('admins').find({}).toArray();
        console.log("Admins Count:", admins.length);
        console.log("Admins Sample:", JSON.stringify(admins, null, 2));

        const regs = await db.collection('admin_registrations').find({}).toArray();
        console.log("Registrations Count:", regs.length);
        console.log("Registrations Sample:", JSON.stringify(regs, null, 2));

    } catch (e) {
        console.error(e);
    } finally {
        await client.close();
    }
}

main();
