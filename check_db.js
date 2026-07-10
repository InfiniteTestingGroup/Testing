const mongoose = require('mongoose');

const mongoUri = process.env.MONGODB_URI;

async function checkCompanies() {
    try {
        if (!mongoUri) {
            throw new Error('Set MONGODB_URI before running this script.');
        }
        await mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true });
        console.log('Connected to replicated EC2 MongoDB');

        const db = mongoose.connection.db;
        const collections = await db.listCollections().toArray();
        console.log('Collections:', collections.map(c => c.name));

        const companies = db.collection('companies');
        const count = await companies.countDocuments();
        console.log('Total Companies:', count);

        const pending = await companies.countDocuments({ status: false });
        console.log('Companies with status:false:', pending);

        const firstFew = await companies.find({}).limit(5).toArray();
        console.log('Sample Companies:', JSON.stringify(firstFew, null, 2));

        process.exit(0);
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

checkCompanies();
