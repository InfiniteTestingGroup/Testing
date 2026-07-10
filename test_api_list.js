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

async function testList() {
  console.log('Sending request to:', `${AD_MOBILE_API_URL}/v1/company/all/list`);
  try {
    const response = await fetch(`${AD_MOBILE_API_URL}/v1/company/all/list`, {
      method: 'GET',
      headers: mobileHeaders()
    });
    
    console.log('Response Status:', response.status);
    const json = await response.json();
    console.log('Response JSON success:', json.success);
    if (json.data) {
      console.log('Number of companies returned:', json.data.length);
      if (json.data.length > 0) {
        console.log('Sample company:', JSON.stringify(json.data[0], null, 2));
      }
    } else {
      console.log('Full JSON response:', JSON.stringify(json, null, 2));
    }
  } catch (error) {
    console.error('Fetch error:', error);
  }
}

testList();
