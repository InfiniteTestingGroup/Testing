import { MongoClient } from 'mongodb';
const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);
async function run() {
  try {
    if (!uri) {
      throw new Error('Set MONGODB_URI before running this script.');
    }
    await client.connect();
    const database = client.db(process.env.MONGODB_DATABASE || 'keliri_production');
    
    // Find one campaign
    const campaign = await database.collection('ad_campaigns').findOne({ advertisementId: "69f1c273c16749ff8c128473" });
    console.log("Campaign Details:");
    console.log(JSON.stringify(campaign, null, 2));
    // Find another campaign
    const campaign2 = await database.collection('ad_campaigns').findOne({ _id: "keliri_camp_001" });
    console.log("\nCampaign 2 Details:");
    console.log(JSON.stringify(campaign2, null, 2));
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
