import { api } from './api'
import type { RazorpayOrder } from "../types/payment"
import type { Invoice } from "../types/invoice"

interface AdminProfile {
  name?: string;
  email?: string;
  emailId?: string;
  companyName?: string;
  businessAddress?: string;
  mobileNumber?: string;
  contactNumber?: string;
  company?: string;
  address?: string;
  phone?: string;
  mobile?: string;
  // Nested registration sub-object — Spring Boot backend often wraps registration fields here
  registration?: {
    mobileNumber?: string;
    contactNumber?: string;
    phone?: string;
    businessAddress?: string;
    authorizedPerson?: string;
    companyName?: string;
  };
}

async function fetchOwnAdminProfile(): Promise<AdminProfile | null> {
  try {
    const response = await api.get('/api/admin/profile');
    if (!response.data.success) return null;
    return response.data.data as AdminProfile;
  } catch {
    return null;
  }
}

// Scans only Admin advertisement endpoints to find the clean Campaign Title
async function fetchAdCampaignTitle(adId?: string): Promise<string | null> {
  if (!adId) return null;
  const endpoints = [
    '/api/admin/ads',
    '/api/admin/advertisements',
    '/api/advertisements',
    '/api/ads',
    '/api/admin/campaigns'
  ];

  for (const endpoint of endpoints) {
    try {
      const res = await api.get(endpoint);
      const payload = res?.data;
      const ads = payload?.data || payload?.content || (Array.isArray(payload) ? payload : []);
      if (Array.isArray(ads)) {
        const matched = ads.find((a: any) =>
          a.id === adId || a._id === adId || a.campaignId === adId || a.adId === adId
        );
        if (matched && (matched.title || matched.name || matched.campaignTitle || matched.adTitle)) {
          return matched.title || matched.name || matched.campaignTitle || matched.adTitle;
        }
      }
    } catch {
      // Continue to next endpoint if this one fails or 404s
    }
  }
  return null;
}

export const createOrder = async (adId: string, amount: number): Promise<RazorpayOrder> => {
  const response = await api.post('/api/admin/payments/create-order', {
    adId,
    amount
  });

  if (!response.data.success) {
    throw new Error(response.data.message || 'Failed to create order');
  }

  return {
    id: response.data.id,
    amount: response.data.amount,
    currency: response.data.currency,
    keyId: response.data.keyId
  }
}

export const verifyPayment = async (payload: {
  razorpay_payment_id: string
  razorpay_order_id: string
  razorpay_signature: string
}): Promise<boolean> => {
  const response = await api.post('/api/admin/payments/verify', payload);
  return response.data.success;
}

/**
 * Notifies the backend that the user dismissed/cancelled the Razorpay modal.
 * The backend will mark the transaction as FAILED if it is still PENDING.
 */
export const markPaymentFailed = async (orderId: string): Promise<void> => {
  try {
    await api.post('/api/admin/payments/mark-failed', { orderId });
  } catch (err) {
    console.error('[payment.ts] markPaymentFailed failed for orderId=', orderId, err);
  }
}

export interface FetchPaymentsArgs {
  page: number
  limit: number
  search?: string
  status?: string
}

export const fetchPayments = async ({ page, limit, search, status }: FetchPaymentsArgs) => {
  const response = await api.get('/api/admin/payments');
  const allData = response.data.data || [];

  let filtered = allData.map((t: any) => ({
    id: t.id,
    transactionId: t.razorpayPaymentId || t.razorpayOrderId || t.id,
    adName: t.adId,
    amount: t.amount,
    status: t.status === 'SUCCESS' ? 'Success' : t.status === 'FAILED' ? 'Failed' : 'Pending',
    method: 'Razorpay',
    date: new Date(t.createdAt).toISOString().split('T')[0],
    invoiceUrl: '#'
  }));

  if (search) {
    const s = search.toLowerCase();
    filtered = filtered.filter((t: any) => t.transactionId?.toLowerCase().includes(s));
  }

  if (status && status !== 'All') {
    filtered = filtered.filter((t: any) => t.status === status);
  }

  const totalItems = filtered.length;
  const totalPages = Math.ceil(totalItems / limit) || 1;
  const paginated = filtered.slice((page - 1) * limit, page * limit);

  return {
    data: paginated,
    totalItems,
    totalPages,
    stats: {
      totalRevenue: allData.filter((t: any) => t.status === 'SUCCESS').reduce((acc: number, t: any) => acc + t.amount, 0),
      successRate: allData.length > 0 ? Math.round((allData.filter((t: any) => t.status === 'SUCCESS').length / allData.length) * 100) : 0,
      recentSettlements: allData.filter((t: any) => t.status === 'SUCCESS').length
    }
  }
}

export const getInvoiceById = async (transactionId: string): Promise<Invoice> => {
  const response = await api.get('/api/admin/payments');
  const allData = response.data.data || [];

  const txn = allData.find((t: any) =>
    t.id === transactionId || t.razorpayOrderId === transactionId || t.razorpayPaymentId === transactionId
  );

  const amount = txn?.amount || 365;
  const rzpTxnId = txn?.razorpayPaymentId || txn?.razorpayOrderId || transactionId;
  const statusStr = txn?.status === 'SUCCESS' ? 'Paid' : (txn?.status === 'FAILED' ? 'Failed' : 'Pending');

  // Fetch admin profile and advertisement title in parallel
  const [profile, adTitle] = await Promise.all([
    fetchOwnAdminProfile(),
    fetchAdCampaignTitle(txn?.adId || txn?.campaignId)
  ]);

  const adminUserStr = localStorage.getItem('admin_user');
  const adminUser = adminUserStr ? JSON.parse(adminUserStr) : null;

  // Resolve clean title instead of displaying UUID
  const itemDescription = adTitle || txn?.title || txn?.adTitle || txn?.adName || txn?.campaignTitle || "Advertisement Placement System";

  return {
    invoiceNumber: `INV-${rzpTxnId.slice(-6).toUpperCase()}`,
    date: txn ? new Date(txn.createdAt).toISOString().split("T")[0] : new Date().toISOString().split("T")[0],
    transactionId: rzpTxnId,
    paymentMethod: "Razorpay Checkout",
    status: statusStr as any,

    from: {
      company: "Jackfruit Software Labs Pvt. Ltd.",
      address: "No.473, 16th Main, Poornapragna Layout, Uttarahalli, Bangalore, Karnataka, India, 560061",
      pan: "AADCJ7471Q"
    },

    to: {
      name: profile?.name || adminUser?.name || adminUser?.authorizedPerson || "Admin",
      company: profile?.companyName || profile?.company || adminUser?.companyName || adminUser?.company || "Keliri Admin Account",
      address: profile?.registration?.businessAddress || profile?.businessAddress || profile?.address || adminUser?.businessAddress || adminUser?.address || "",
      email: profile?.email || profile?.emailId || adminUser?.emailId || adminUser?.email || "Not available",
      mobile:
        profile?.registration?.mobileNumber ||
        profile?.registration?.contactNumber ||
        profile?.registration?.phone ||
        profile?.mobileNumber ||
        profile?.contactNumber ||
        profile?.mobile ||
        profile?.phone ||
        adminUser?.mobileNumber ||
        adminUser?.contactNumber ||
        adminUser?.phoneNumber ||
        adminUser?.phone ||
        "Not available"
    },
    items: [
      {
        id: "1",
        // Displays clean advertisement title under Description column
        description: itemDescription,
        quantity: 1,
        rate: amount,
        amount: amount
      }
    ],

    subtotal: amount,
    tax: 0,
    total: amount
  }
}