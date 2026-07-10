const fs = require('fs');
const path = require('path');

// Read config from .env
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

const AD_MOBILE_API_URL = env.VITE_AD_MOBILE_BACKEND_URL ?? 'http://ec2-15-206-186-192.ap-south-1.compute.amazonaws.com:3000';
const AD_MOBILE_TOKEN = env.VITE_AD_MOBILE_TOKEN ?? '';

function mobileHeaders() {
  return {
    'Authorization': `Bearer ${AD_MOBILE_TOKEN}`,
    'Content-Type': 'application/json'
  };
}

async function testCreate() {
  const companyPayload = {
    name: 'Big basket',
    email: 'prakash@gmail.com',
    companyType: 'PRODUCTS_SERVICES',
    phoneNumber: { countryCode: '+91', dialNumber: '9482422802' },
    billingAddress: {
      addressLine1: 'Test Address Line 1',
      city: 'Bangalore',
      state: 'Karnataka',
      zipCode: '560001',
      country: 'India',
      latitude: 12.9716,
      longitude: 77.5946
    },
    primaryContact: {
      name: 'Prakash HS',
      email: 'prakash@gmail.com',
      isSameAsBilling: true,
      phoneNumber: { countryCode: '+91', dialNumber: '9482422802' }
    }
  };

  console.log('Sending payload to:', `${AD_MOBILE_API_URL}/v1/company`);
  try {
    const response = await fetch(`${AD_MOBILE_API_URL}/v1/company`, {
      method: 'POST',
      headers: mobileHeaders(),
      body: JSON.stringify(companyPayload)
    });
    
    console.log('Response Status:', response.status);
    console.log('Response Status Text:', response.statusText);
    const json = await response.json();
    console.log('Response JSON:', JSON.stringify(json, null, 2));
  } catch (error) {
    console.error('Fetch error:', error);
  }
}

testCreate();
