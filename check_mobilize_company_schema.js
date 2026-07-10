const mongoose = require('mongoose');

const mongoUri = process.env.MONGODB_URI;

async function checkSchema() {
    try {
        if (!mongoUri) {
            throw new Error('Set MONGODB_URI before running this script.');
        }
        await mongoose.connect(mongoUri);
        console.log('Connected to MongoDB');

        const Company = mongoose.connection.collection('companies');
        const company = await Company.findOne({});

        if (company) {
            console.log('Found a company record:');
            console.log(JSON.stringify(company, null, 2));
        } else {
            console.log('No company records found in "companies" collection');
        }

        await mongoose.disconnect();
    } catch (err) {
        console.error('Error:', err);
    }
}

checkSchema();
