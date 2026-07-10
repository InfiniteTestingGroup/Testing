

// global fetch interceptor to support offline mock mode in superadmin
import { PermissionMap } from './auth';

export interface AuthSession {
  token: string;
  email: string;
  name?: string;
  phone?: string;
  role: 'MASTER_SUPER_ADMIN' | 'SUB_SUPER_ADMIN';
  permissions: PermissionMap;
  expiresAt: number;
}

const defaultPermissions: PermissionMap = {
  dashboard: true,
  analytics: true,
  admins: true,
  publishers: true,
  ads: true,
  revenue: true,
  transactions: true,
  tickets: true,
  auditLogs: true,
  profile: true,
  settings: true,
  subAdmins: true,
};

const mockAdmins = [
  {
    id: "admin-1",
    name: "Shwetha",
    email: "sai17shwe@gmail.com",
    company: "ABC_1704",
    registeredDate: "01 Jun 2026",
    status: "APPROVED",
    phone: "7989248701",
    latitude: 17.306262736516427,
    longitude: 76.81397886331763
  },
  {
    id: "admin-2",
    name: "Divya M",
    email: "divya@example.com",
    company: "Jackfruit Technologies",
    registeredDate: "05 Jun 2026",
    status: "APPROVED",
    phone: "9876543210",
    latitude: 12.9716,
    longitude: 77.5946
  },
  {
    id: "admin-3",
    name: "Keerthi Kumar",
    email: "keerthi@example.com",
    company: "Keliri Ads",
    registeredDate: "08 Jun 2026",
    status: "APPROVED",
    phone: "8765432109",
    latitude: 19.0760,
    longitude: 72.8777
  },
  {
    id: "admin-4",
    name: "Namitha",
    email: "namitha@example.com",
    company: "Namitha Agency",
    registeredDate: "10 Jun 2026",
    status: "APPROVED",
    phone: "7654321098",
    latitude: 18.5204,
    longitude: 73.8567
  },
  {
    id: "admin-5",
    name: "Rajesh",
    email: "rajesh@example.com",
    company: "RK Retail",
    registeredDate: "12 Jun 2026",
    status: "APPROVED",
    phone: "6543210987",
    latitude: 17.3850,
    longitude: 78.4867
  },
  {
    id: "admin-6",
    name: "Amit",
    email: "amit@example.com",
    company: "Amit & Co",
    registeredDate: "14 Jun 2026",
    status: "APPROVED",
    phone: "5432109876",
    latitude: 28.6139,
    longitude: 77.2090
  }
];

const mockTickets = [
  { id: "ticket-1", subject: "Unable to upload video ad creative", category: "TECHNICAL", status: "OPEN", adminId: "admin-1", createdAt: "2026-06-15T10:00:00Z", updatedAt: "2026-06-16T10:00:00Z" },
  { id: "ticket-2", subject: "Billing issue with campaign payment", category: "BILLING", status: "IN_PROGRESS", adminId: "admin-2", createdAt: "2026-06-14T09:00:00Z", updatedAt: "2026-06-15T11:00:00Z" }
];

const mockTicketThreads: Record<string, any> = {
  "ticket-1": {
    id: "ticket-1",
    subject: "Unable to upload video ad creative",
    category: "TECHNICAL",
    status: "OPEN",
    adminId: "admin-1",
    createdAt: "2026-06-15T10:00:00Z",
    updatedAt: "2026-06-16T10:00:00Z",
    messages: [
      { id: "m-1", senderType: "ADMIN", message: "Hi, I get an error 'File format not supported' when uploading an MP4 video.", createdAt: "2026-06-15T10:00:00Z" },
      { id: "m-2", senderType: "SUPER_ADMIN", message: "Hi, we currently support MP4 format under 50MB. Please check the file size.", createdAt: "2026-06-16T09:00:00Z" }
    ]
  },
  "ticket-2": {
    id: "ticket-2",
    subject: "Billing issue with campaign payment",
    category: "BILLING",
    status: "IN_PROGRESS",
    adminId: "admin-2",
    createdAt: "2026-06-14T09:00:00Z",
    updatedAt: "2026-06-15T11:00:00Z",
    messages: [
      { id: "m-1", senderType: "ADMIN", message: "Payment went through but campaign shows unpaid.", createdAt: "2026-06-14T09:00:00Z" },
      { id: "m-2", senderType: "SUPER_ADMIN", message: "Could you please share your transaction ID?", createdAt: "2026-06-15T11:00:00Z" }
    ]
  }
};

const mockSubAdmins = [
  { id: "subadmin-1", name: "Anil Kumar", email: "anil@keliri.com", phone: "9123456780", role: "SUB_SUPER_ADMIN", locked: false, permissions: { ...defaultPermissions, subAdmins: false } }
];

const mockPayments = [
  { id: "pay-1", reference: "order_ABC123", amount: 15000, status: "Completed", date: "2026-06-16T10:30:00Z", incoming: true, adminName: "Shwetha" }
];

const mockAuditLogs = [
  { id: "log-1", timestamp: "2026-06-16T12:00:00Z", actorName: "Super Admin", actorRole: "MASTER_SUPER_ADMIN", actionType: "APPROVE_ADMIN", entityType: "ADMIN", entityId: "admin-1", action: "Approved administrator Shwetha (ABC_1704)", ip: "192.168.1.50" }
];

const mockAds = [
  {
    id: "ad-campaign-1",
    title: "Summer Special Offer",
    description: "Get 20% off on all products",
    type: "Image Ad",
    adminId: "admin-1",
    adminName: "Shwetha",
    publisherId: "pub-1",
    publisherName: "Shwetha's Publisher Shop",
    createdDate: "2026-06-10",
    status: "Active",
    impressions: 1500,
    clicks: 124,
    ctr: 8.27,
    startDate: "2026-06-10",
    endDate: "2026-07-10",
    location: "Kalaburagi",
    radius: "5 km",
    image: "https://keliri.s3.ap-south-1.amazonaws.com/registrations/sai17shwe_gmail_com/company/7adad654-6c8c-4c45-bad6-6c8dcec3709d_single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg",
    lat: 17.306262736516427,
    lng: 76.81397886331763,
    locationRange: 5000
  }
];

const mockAnalyticsSummary = {
  kpis: [
    { title: "Total Ads", value: 156, change: 12 },
    { title: "Total Campaigns", value: 45, change: 8 },
    { title: "Active Ads", value: 28, change: 5 },
    { title: "Publishers", value: 212, change: 3 },
    { title: "Total Users", value: 1205, change: 15 },
    { title: "Total Admins", value: 6, change: 0 }, // MUST be exactly 6!
    { title: "Total Transactions", value: 89, change: 10 },
    { title: "Geo-Targeted", value: 28, change: 12 }
  ],
  topLocation: "Kalaburagi",
  locationRows: [
    { city: "Kalaburagi", campaigns: 12, activeCampaigns: 8, averageRadiusKm: 15, status: "Active", latitude: 17.306262736516427, longitude: 76.81397886331763 },
    { city: "Bangalore", campaigns: 25, activeCampaigns: 15, averageRadiusKm: 10, status: "Active", latitude: 12.9716, longitude: 77.5946 },
    { city: "Mumbai", campaigns: 18, activeCampaigns: 10, averageRadiusKm: 8, status: "Active", latitude: 19.0760, longitude: 72.8777 },
    { city: "Pune", campaigns: 8, activeCampaigns: 4, averageRadiusKm: 5, status: "Active", latitude: 18.5204, longitude: 73.8567 },
    { city: "Hyderabad", campaigns: 15, activeCampaigns: 9, averageRadiusKm: 12, status: "Active", latitude: 17.3850, longitude: 78.4867 },
    { city: "Delhi", campaigns: 14, activeCampaigns: 7, averageRadiusKm: 20, status: "Active", latitude: 28.6139, longitude: 77.2090 }
  ],
  adTypeBreakdown: [
    { name: "Image Ads", count: 85, value: 85 },
    { name: "Video Ads", count: 39, value: 39 },
    { name: "Banner Ads", count: 32, value: 32 }
  ],
  topCampaigns: [
    { name: "Summer Special Offer", count: 12, value: 12 },
    { name: "New Product Launch", count: 8, value: 8 },
    { name: "Discount Sale", count: 6, value: 6 }
  ],
  radiusBreakdown: [
    { name: "0-5 km", value: 25 },
    { name: "5-10 km", value: 15 },
    { name: "10+ km", value: 5 }
  ],
  creatorRows: [
    { rank: 1, name: "Shwetha", campaigns: 15, activeCampaigns: 10, targetedLocations: 3 },
    { rank: 2, name: "Divya M", campaigns: 12, activeCampaigns: 8, targetedLocations: 2 },
    { rank: 3, name: "Keerthi Kumar", campaigns: 8, activeCampaigns: 5, targetedLocations: 1 }
  ],
  campaignsPerCreator: [
    { name: "Shwetha", value: 15 },
    { name: "Divya M", value: 12 },
    { name: "Keerthi Kumar", value: 8 }
  ],
  publisherRows: [
    { name: "Bangalore Mall Network", location: "Bangalore, Karnataka", campaignsNearby: 5, activeCampaignsNearby: 3, status: "Active" },
    { name: "Kalaburagi Retail Hub", location: "Kalaburagi, Karnataka", campaignsNearby: 3, activeCampaignsNearby: 2, status: "Active" }
  ],
  monthlyTrend: [
    { name: "Jan", value: 12 },
    { name: "Feb", value: 19 },
    { name: "Mar", value: 25 },
    { name: "Apr", value: 32 },
    { name: "May", value: 45 },
    { name: "Jun", value: 56 }
  ],
  weeklyTrend: [
    { name: "Mon", value: 5 },
    { name: "Tue", value: 8 },
    { name: "Wed", value: 12 },
    { name: "Thu", value: 15 },
    { name: "Fri", value: 18 },
    { name: "Sat", value: 22 },
    { name: "Sun", value: 10 }
  ],
  durationBreakdown: [
    { name: "7 Days", value: 15 },
    { name: "30 Days", value: 20 },
    { name: "90 Days", value: 10 }
  ]
};

async function getMockResponse(url: string, init?: RequestInit): Promise<Response> {
  const method = (init?.method || 'GET').toUpperCase();
  let status = 200;
  let body: any = null;

  // Route URL
  if (url.includes('/api/auth/superadmin/login')) {
    body = {
      token: "mock-superadmin-token-12345",
      message: "Login successful",
      email: "superadmin@example.com",
      name: "Super Admin",
      phone: "9999999999",
      role: "MASTER_SUPER_ADMIN",
      permissions: defaultPermissions
    };
  } else if (url.includes('/api/auth/superadmin/me')) {
    const raw = localStorage.getItem('keliri_superadmin_auth');
    if (raw) {
      body = JSON.parse(raw);
    } else {
      status = 401;
      body = { message: "Unauthorized" };
    }
  } else if (url.includes('/api/auth/superadmin/logout')) {
    body = { success: true, message: "Logged out successfully" };
  } else if (url.includes('/api/superadmin/analytics/summary')) {
    body = mockAnalyticsSummary;
  } else if (url.includes('/api/superadmin/analytics/revenue')) {
    body = {
      revenueTrend: [
        { label: "Jan", value: 5000 },
        { label: "Feb", value: 12000 },
        { label: "Mar", value: 18000 }
      ],
      totalRevenue: 35000
    };
  } else if (url.includes('/api/superadmin/analytics')) {
    body = mockAnalyticsSummary;
  } else if (url.includes('/api/superadmin/admins/')) {
    // Detail or sub-action
    const parts = url.split('/admins/');
    const subParts = parts[1].split('?')[0].split('/');
    const adminId = subParts[0];
    const action = subParts[1];

    if (action) {
      // Admin actions like approve/reject/suspend/reinstate
      const ad = mockAdmins.find(a => a.id === adminId) || mockAdmins[0];
      const nextStatus = action === 'approve' ? 'APPROVED'
        : action === 'reject' ? 'REJECTED'
          : action === 'suspend' ? 'SUSPENDED'
            : 'APPROVED';
      body = {
        admin: { ...ad, status: nextStatus },
        emailNotification: {
          id: `notif-${Date.now()}`,
          trigger: `ADMIN_${action.toUpperCase()}`,
          to: ad.email,
          content: `Your administrator account has been ${action}d.`,
          timestamp: new Date().toISOString()
        }
      };
    } else {
      // Get detail
      const ad = mockAdmins.find(a => a.id === adminId) || mockAdmins[0];
      body = {
        ...ad,
        performance: { totalAds: 24, revenue: 15600, avgCtr: 3.2 },
        documents: [
          { name: "GST Certificate", type: "PDF", url: "https://keliri.s3.ap-south-1.amazonaws.com/registrations/sai17shwe_gmail_com/company/7adad654-6c8c-4c45-bad6-6c8dcec3709d_single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg" },
          { name: "Company Registration Certificate", type: "Image", url: "https://keliri.s3.ap-south-1.amazonaws.com/registrations/sai17shwe_gmail_com/company/7adad654-6c8c-4c45-bad6-6c8dcec3709d_single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg" },
          { name: "Authorized Representative ID Proof", type: "Image", url: "https://keliri.s3.ap-south-1.amazonaws.com/registrations/sai17shwe_gmail_com/id/3f069c5a-0585-47c3-a8e5-d2826f5ece1e_single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg" }
        ],
        publishers: [
          { id: "pub-1", name: "Shwetha's Publisher Shop", status: "Active", adsPosted: 12 }
        ],
        registration: {
          authorizedPerson: ad.name,
          businessAddress: "Vardha Nagar, Karuneshwar Nagar, Kalaburagi, Karnataka",
          city: "Kalaburagi",
          state: "Karnataka",
          zipCode: "585102",
          country: "India",
          gstNumber: "29ABCDE1234F1Z5",
          companyType: "PRODUCTS_SERVICES",
          countryCode: "+91",
          mobileNumber: ad.phone,
          submittedAt: "2026-06-16T12:00:00Z"
        }
      };
    }
  } else if (url.includes('/api/superadmin/admins')) {
    body = mockAdmins;
  } else if (url.includes('/api/superadmin/admin-notifications')) {
    body = [];
  } else if (url.includes('/api/superadmin/publishers')) {
    body = [
      { id: "pub-1", name: "Shwetha's Publisher Shop", adminId: "admin-1", adminName: "Shwetha", location: "Kalaburagi, Karnataka", adsPosted: 5, impressions: 1200, clicks: 84, engagement: 7.0, status: "Active", email: "sai17shwe@gmail.com", phone: "7989248701", joinDate: "01 Jun 2026" },
      { id: "pub-2", name: "Bangalore Electronics", adminId: "admin-2", adminName: "Divya M", location: "Bangalore, Karnataka", adsPosted: 8, impressions: 2400, clicks: 156, engagement: 6.5, status: "Active", email: "pub2@gmail.com", phone: "9876543210", joinDate: "05 Jun 2026" }
    ];
  } else if (url.includes('/api/superadmin/audit-logs')) {
    body = mockAuditLogs;
  } else if (url.includes('/api/superadmin/sub-admins/')) {
    const parts = url.split('/sub-admins/');
    const subParts = parts[1].split('?')[0].split('/');
    const subAdminId = subParts[0];
    const action = subParts[1];
    const ad = mockSubAdmins.find(a => a.id === subAdminId) || mockSubAdmins[0];
    body = {
      ...ad,
      locked: action === 'lock' ? true : action === 'unlock' ? false : ad.locked
    };
  } else if (url.includes('/api/superadmin/sub-admins')) {
    body = mockSubAdmins;
  } else if (url.includes('/api/superadmin/payments')) {
    body = { success: true, data: mockPayments };
  } else if (url.includes('/api/superadmin/tickets/')) {
    const parts = url.split('/tickets/');
    const subParts = parts[1].split('?')[0].split('/');
    const ticketId = subParts[0];
    const subAction = subParts[1];

    if (subAction === 'reply') {
      const payload = init?.body ? JSON.parse(init.body as string) : {};
      body = {
        success: true,
        message: {
          id: `msg-${Date.now()}`,
          message: payload.message || '',
          senderType: 'SUPER_ADMIN',
          createdAt: new Date().toISOString()
        }
      };
    } else if (subAction === 'status') {
      body = { success: true };
    } else {
      body = mockTicketThreads[ticketId] || mockTicketThreads["ticket-1"];
    }
  } else if (url.includes('/api/superadmin/tickets')) {
    body = { success: true, tickets: mockTickets };
  } else if (url.includes('/api/superadmin/ads/')) {
    const parts = url.split('/ads/');
    const subParts = parts[1].split('?')[0].split('/');
    const adId = subParts[0];
    const ad = mockAds.find(a => a.id === adId) || mockAds[0];
    body = { ...ad, status: 'Suspended' };
  } else if (url.includes('/api/superadmin/ads')) {
    body = mockAds;
  } else if (url.includes('/api/admin/register')) {
    body = { success: true, message: "Registration submitted successfully" };
  } else {
    // Catch-all
    body = { success: true, message: "Mock response" };
  }

  // Return custom Response object
  const responseBlob = new Blob([JSON.stringify(body)], { type: 'application/json' });
  const responseInit = {
    status,
    statusText: status === 200 ? 'OK' : 'Unauthorized',
    headers: { 'Content-Type': 'application/json' }
  };
  return new Response(responseBlob, responseInit);
}

export function setupMockInterceptor() {
  const originalFetch = window.fetch;
  window.fetch = async function (input, init) {
    const url = typeof input === 'string' ? input : input.url;

    if (url.includes('/api/')) {
      try {
        const response = await originalFetch(input, init);
        // If Spring Boot returns Gateway error or Connection failure (502 / 503 / 504)
        if (response.status === 502 || response.status === 504 || response.status === 503) {
          console.warn(`[Mock Mode API] Live API returned ${response.status} for ${url}, using offline mock data.`);
          return getMockResponse(url, init);
        }
        return response;
      } catch (error) {
        console.warn(`[Mock Mode API] Live API failed for ${url}, using offline mock data:`, error);
        return getMockResponse(url, init);
      }
    }
    return originalFetch(input, init);
  };
}
