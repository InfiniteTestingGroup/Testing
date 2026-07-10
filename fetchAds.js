import axios from 'axios';
require('dotenv').config()

async function fetchAds() {
  try {
    const res = await axios.get('http://ec2-15-206-186-192.ap-south-1.compute.amazonaws.com:3000/v1/ad-campaigns?page=1&limit=50', {
      headers: {
        Authorization: `Bearer ${process.env.VITE_AD_MOBILE_TOKEN || ''}`
      }
    });
    const campaigns = res.data.data;
    campaigns.forEach(c => {
      const adUid = c.advertisementId ? c.advertisementId.uid : 'NO_AD_UID';
      const title = c.advertisementId ? c.advertisementId.title : 'NO_TITLE';
      console.log(`Camp UID: ${c.uid} | Ad UID: ${adUid} | Title: ${title} | Status: ${c.compaignsStatus} | Created: ${c.createdAt}`);
    });
  } catch (err) {
    console.error(err.message);
  }
}
fetchAds();
