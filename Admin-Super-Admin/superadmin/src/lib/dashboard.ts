// // src/lib/dashboard.ts
// import { mobileHeaders, AD_MOBILE_API_URL } from './management';
// import { fetchSuperAdminAnalyticsSummary, fetchRevenueAnalytics } from './analytics';
// // duplicate import removed



// /** Helper to perform fetch with timeout */
// function fetchWithTimeout(
//   url: string,
//   options: RequestInit = {},
//   timeoutMs = 8000
// ): Promise<Response | null> {
//   const controller = new AbortController();

//   const timeout = setTimeout(() => {
//     controller.abort();
//   }, timeoutMs);

//   return fetch(url, {
//     ...options,
//     signal: controller.signal,
//   })
//     .then((res) => {
//       clearTimeout(timeout);
//       return res;
//     })
//     .catch((err) => {
//       clearTimeout(timeout);
//       console.error("Fetch failed:", url, err);
//       return null;
//     });

// }
// export interface TrendPoint {
//   label: string
//   value: number
// }

// export interface RecentActivity {
//   id: string
//   action: string
//   status: string
//   locationName: string
//   occurredAt: string
// }

// export interface TopCreator {
//   rank: number
//   name: string
//   email: string
//   campaignCount: number
//   activeCampaignCount: number
//   locationCount: number
//   change: number
// }

// export interface SuperAdminDashboardPayload {
//   summary: any
//   kpis: any[]
//   publishingTrend: TrendPoint[]
//   topCreators: any[]
//   recentActivities: RecentActivity[]
//   adTypeBreakdown: any[]
//   locationBreakdown: any[]
// }
// export interface DashboardKpi {
//   id: string
//   title: string
//   value: string
//   change: number
//   changeLabel: string
//   prefix?: string
// }


// // /** Fetch only the counts KPI data */
// /** Fetch only the counts KPI data */
// export async function fetchDashboardCounts() {
//   // 1️⃣ Get KPI cards from analytics summary endpoint
//   // 1️⃣ Get KPI cards from analytics summary endpoint
//   const summaryPayload = await fetchSuperAdminAnalyticsSummary();
//   const kpis = summaryPayload?.data?.kpis || [];

//   // 2️⃣ Get revenue from revenue endpoint
//   const revenuePayload = await fetchRevenueAnalytics();
//   const totalRevenue = revenuePayload?.data?.totalRevenue ?? 0;

//   // Helper to get value by title
//   const map = (title: string) =>
//     kpis.find((c: any) => c.title === title)?.value ?? 0;

//   return {
//     summary: {
//       totalAds: map('Total Ads'),
//       totalCampaigns: map('Total Campaigns'),
//       activeCampaigns: map('Active Ads'), // maps to Active Campaigns KPI
//       totalPublishers: map('Publishers'),
//       totalUsers: map('Total Users'),
//       totalAdmins: map('Total Admins'),
//       totalRevenue,
//     },
//     kpis: [
//       { id: 'ads', title: 'Total Advertisements', value: map('Total Ads').toString(), change: 0, changeLabel: '' },
//       { id: 'campaigns', title: 'Total Campaigns', value: map('Total Campaigns').toString(), change: 0, changeLabel: '' },
//       { id: 'activeCampaigns', title: 'Active Campaigns', value: map('Active Ads').toString(), change: 0, changeLabel: '' },
//       { id: 'publishers', title: 'Active Publishers', value: map('Publishers').toString(), change: 0, changeLabel: '' },
//       { id: 'admins', title: 'Total Admins', value: map('Total Admins').toString(), change: 0, changeLabel: '' },
//       { id: 'users', title: 'Total Users', value: map('Total Users').toString(), change: 0, changeLabel: '' },
//       { id: 'revenue', title: 'Total Revenue', value: `₹${totalRevenue}`, change: 0, changeLabel: '' },
//     ],
//   };



// }


// /** Fetch the remaining dashboard data (trend, activities, etc.) */
// export async function fetchDashboardDetails(): Promise<Partial<SuperAdminDashboardPayload>> {
//   const [analyticsRes, adsRes, campaignsRes, companyRes] = await Promise.allSettled([
//     fetchWithTimeout(`${AD_MOBILE_API_URL}/v1/ad-campaigns/count/dateRange`, {
//       method: 'POST',
//       headers: mobileHeaders(),
//       body: JSON.stringify({
//         fromDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
//         toDate: new Date().toISOString(),
//       }),
//     }, 8000),
//     fetchWithTimeout(`${AD_MOBILE_API_URL}/v1/advertisements?page=1&limit=200`, { headers: mobileHeaders() }, 8000),
//     fetchWithTimeout(`${AD_MOBILE_API_URL}/v1/ad-campaigns?page=1&limit=200`, { headers: mobileHeaders() }, 8000),
//     fetchWithTimeout(`${AD_MOBILE_API_URL}/v1/company/PRODUCTS_SERVICES?all=yes`, { headers: mobileHeaders() }, 8000),
//   ]).then((results) => results.map((r) => (r.status === 'fulfilled' ? r.value : null)) as any);

//   const analyticsPayload = await (analyticsRes?.json?.() ?? Promise.resolve({}));
//   console.log("ANALYTICS PAYLOAD:", analyticsPayload);
//   const adsPayload = await (adsRes?.json?.() ?? Promise.resolve({}));
//   console.log("ADS PAYLOAD:", adsPayload);
//   const campaignsPayload = await (campaignsRes?.json?.() ?? Promise.resolve({}));
//   console.log("CAMPAIGNS PAYLOAD:", campaignsPayload);
//   const companyPayload = await (companyRes?.json?.() ?? Promise.resolve({}));
//   console.log("COMPANY PAYLOAD:", companyPayload);

//   const analytics = analyticsPayload?.data || analyticsPayload || {};
//   const adsData = adsPayload?.data || (Array.isArray(adsPayload) ? adsPayload : []);

//   // reuse previous processing for trend and recent activities
//   const publishingTrend: TrendPoint[] = (analytics.performanceTrend && analytics.performanceTrend.length > 0)
//     ? analytics.performanceTrend.map((d: any) => ({ label: new Date(d.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }), value: d.clicks || 0 }))
//     : Array.from({ length: 7 }).map((_, i) => {
//       const d = new Date();
//       d.setDate(d.getDate() - (6 - i));
//       return { label: d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }), value: [10, 25, 12, 45, 30, 22, 55][i] };
//     });

//   const recentActivities: RecentActivity[] = adsData.slice(0, 5).map((ad: any) => {
//     const adTitle = ad.advertisementId?.title || ad.title;
//     const titleStr = typeof adTitle === 'string' ? adTitle : adTitle?.name || adTitle?.text || 'New Advertisement';
//     return {
//       id: ad.uid || ad._id || Math.random().toString(),
//       action: `Created: ${titleStr}`,
//       status: (ad.status === 'ACTIVE' || ad.status === 'Active' || ad.compaignsStatus === 'ACTIVE') ? 'Active' : 'Draft',
//       locationName: typeof ad.location === 'string' ? ad.location : (ad.location?.locationName || ad.company?.name || 'Global'),
//       occurredAt: new Date(ad.createdAt || Date.now()).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
//     };
//   });

//   return { publishingTrend, recentActivities };
// }

// /** Original function kept for backward compatibility – now uses parallel settled calls with timeout */
// export async function fetchSuperAdminDashboard(): Promise<SuperAdminDashboardPayload> {
//   // Fetch counts first (fast path)
//   const countsResult = await fetchDashboardCounts();
//   // Fetch remaining data in background (won't block UI if called separately)
//   const details = await fetchDashboardDetails();
//   return {
//     summary: countsResult.summary,
//     kpis: countsResult.kpis,
//     publishingTrend: details.publishingTrend ?? [],
//     topCreators: [],
//     recentActivities: details.recentActivities ?? [],
//     adTypeBreakdown: [],
//     locationBreakdown: [],
//   };
// }
