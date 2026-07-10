const { MongoClient } = require('mongodb');

const remoteUri = process.env.REMOTE_MONGODB_URI;
if (!remoteUri) {
    throw new Error('Set REMOTE_MONGODB_URI in your .env before running this script.');
}
const localUri = "mongodb://localhost:27017";

const BLACKLIST = [
    'txn_user_locations_archives',
    'txn_user_locations',
    'locationUpdate',
    'audit_logs',
    'website_hits',
    'txn_user_publishings',
    'txn_publishing_view_counts'
];

async function main() {
    console.log("Connecting to remote MongoDB...");
    const remoteClient = new MongoClient(remoteUri);
    await remoteClient.connect();
    const remoteDb = remoteClient.db('keliri_production');

    console.log("Connecting to local MongoDB...");
    const localClient = new MongoClient(localUri);
    await localClient.connect();
    const localDb = localClient.db('keliri_production');

    console.log("Fetching collection list from remote...");
    const collections = await remoteDb.listCollections().toArray();
    console.log(`Found ${collections.length} collections.`);

    for (const colInfo of collections) {
        const colName = colInfo.name;
        if (BLACKLIST.includes(colName)) {
            console.log(`Skipping blacklisted collection: "${colName}"`);
            continue;
        }

        console.log(`Cloning collection: "${colName}"...`);

        // Drop local collection if it exists
        try {
            await localDb.collection(colName).drop();
        } catch (e) {
            // Ignore if collection doesn't exist locally
        }

        const remoteCol = remoteDb.collection(colName);
        const localCol = localDb.collection(colName);

        const count = await remoteCol.countDocuments();
        console.log(`  - Remote document count: ${count}`);

        if (count === 0) {
            console.log(`  - Skipping empty collection.`);
            continue;
        }

        const cursor = remoteCol.find({});
        let batch = [];
        let totalCopied = 0;

        while (await cursor.hasNext()) {
            const doc = await cursor.next();
            batch.push(doc);

            if (batch.length >= 1000) {
                await localCol.insertMany(batch);
                totalCopied += batch.length;
                console.log(`  - Inserted ${totalCopied} documents...`);
                batch = [];
            }
        }

        if (batch.length > 0) {
            await localCol.insertMany(batch);
            totalCopied += batch.length;
        }

        console.log(`  - Successfully cloned ${totalCopied} documents.`);
    }

    console.log("Database cloning completed successfully!");
    await remoteClient.close();
    await localClient.close();
}

main().catch(console.error);
