import { API_BASE_URL, AuthError, getAuthSession } from './auth';

export interface AdminRecord {
  id: string;
  name: string;
  email: string;
  company: string;
  registeredDate: string;
  status: string;
  phone: string;
  latitude?: number;
  longitude?: number;
  city?: string;
  businessAddress?: string;
  location?: string;
}

export interface PublisherMini {
  id: string;
  name: string;
  status: string;
  adsPosted: number;
}

export interface AdminDetail extends AdminRecord {
  performance: {
    totalAds: number;
    revenue: number;
    avgCtr: number;
  };
  registration?: {
    authorizedPerson?: string;
    businessAddress?: string;
    addressLine2?: string;
    city?: string;
    state?: string;
    zipCode?: string;
    country?: string;
    gstNumber?: string;
    companyType?: string;
    countryCode?: string;
    mobileNumber?: string;
    submittedAt?: string;
  };
  documents: Array<{
    name: string;
    type: string;
    url: string;
  }>;
  publishers: PublisherMini[];
}

export interface EmailNotificationRecord {
  id: string;
  trigger: string;
  to: string;
  content: string;
  timestamp: string;
}

export interface AdminActionResponse {
  admin: AdminRecord;
  emailNotification?: EmailNotificationRecord | null;
}

export interface PublisherRecord {
  id: string;
  name: string;
  adminId: string;
  adminName: string;
  location: string;
  adsPosted: number;
  impressions: number;
  clicks: number;
  engagement: number;
  status: string;
  email: string;
  phone: string;
  joinDate: string;
  // New fields for geolocation
  latitude?: number | null;
  longitude?: number | null;
}

export interface PublisherDetail extends PublisherRecord {
  ads: Array<{
    id: string;
    title: string;
    type: string;
    status: string;
    ctr: number;
  }>;
}

export interface AuditLogRecord {
  id: string;
  timestamp: string;
  actorName: string;
  actorRole: string;
  actionType: string;
  entityType: string;
  entityId: string;
  action: string;
  ip: string;
}

function authHeaders() {
  const session = getAuthSession();
  return session?.token
    ? {
      Authorization: `Bearer ${session.token}`,
    }
    : undefined;
}

async function handleJsonResponse<T>(response: Response, fallbackMessage: string): Promise<T> {
  const payload = (await response.json().catch(() => null)) as T | { error?: string; message?: string } | null;
  if (!response.ok) {
    const errorMessage =
      (payload && typeof payload === 'object' && 'message' in payload && payload.message) ||
      (payload && typeof payload === 'object' && 'error' in payload && payload.error) ||
      fallbackMessage;
    throw new AuthError(String(errorMessage), response.status);
  }
  return payload as T;
}

export async function fetchAdmins(params?: { search?: string; status?: string }): Promise<AdminRecord[]> {
  const query = new URLSearchParams();
  if (params?.search) query.set('search', params.search);

  if (params?.status) query.set('status', params.status);
  const response = await fetch(`${API_BASE_URL}/api/superadmin/admins?${query.toString()}`, {
    headers: authHeaders(),
  });
  return handleJsonResponse<AdminRecord[]>(response, 'Unable to fetch admins');
}

export async function fetchAdminDetail(adminId: string): Promise<AdminDetail> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/admins/${adminId}`, {
    headers: authHeaders(),
  });
  return handleJsonResponse<AdminDetail>(response, 'Unable to fetch admin details');
}

export async function runAdminAction(adminId: string, action: 'approve' | 'reject' | 'suspend' | 'reinstate', reason?: string): Promise<AdminActionResponse> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/admins/${adminId}/${action}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(authHeaders() ?? {}),
    },
    body: (action === 'reject' || action === 'suspend') ? JSON.stringify({ reason }) : undefined,
  });
  return handleJsonResponse<AdminActionResponse>(response, 'Unable to perform admin action');
}

export async function deleteAdmin(adminId: string): Promise<void> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/admins/${adminId}`, {
    method: 'DELETE',
    headers: authHeaders(),
  });
  if (!response.ok) {
    const payload = await response.json().catch(() => null) as { message?: string; error?: string } | null;
    throw new AuthError(payload?.message || payload?.error || 'Unable to delete admin', response.status);
  }
}

export async function fetchAdminNotifications(): Promise<EmailNotificationRecord[]> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/admin-notifications`, {
    headers: authHeaders(),
  });
  return handleJsonResponse<EmailNotificationRecord[]>(response, 'Unable to fetch notifications');
}

export interface SuperAdminTicketRecord {
  id?: string
  _id?: string
  ticketId?: string
  subject?: string
  title?: string
  description?: string
  status?: string
  adminName?: string
  company?: string
  companyName?: string
  createdByName?: string
  raisedBy?: string
  raisedByRole?: string
  createdByRole?: string
  userType?: string
  role?: string
  createdAt?: string
  created_at?: string
  updatedAt?: string
  timestamp?: string
}

export async function fetchSuperAdminTickets(): Promise<SuperAdminTicketRecord[]> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/tickets`, {
    headers: authHeaders(),
  })

  return handleJsonResponse<SuperAdminTicketRecord[]>(response, 'Unable to fetch tickets')
}

export const AD_MOBILE_API_URL = import.meta.env.VITE_AD_MOBILE_BACKEND_URL ?? 'http://ec2-15-206-186-192.ap-south-1.compute.amazonaws.com:3000';
export const AD_MOBILE_TOKEN =




  import.meta.env.VITE_AD_MOBILE_TOKEN || '';
export function mobileHeaders() {
  return {
    Authorization: `Bearer ${AD_MOBILE_TOKEN}`,
    'Content-Type': 'application/json',
  };
}

export async function fetchPublishers(
  params?: { status?: string; location?: string; search?: string }
): Promise<PublisherRecord[]> {

  const query = new URLSearchParams();

  if (params?.status) query.set('status', params.status);
  if (params?.location) query.set('location', params.location);
  if (params?.search) query.set('search', params.search);

  const response = await fetch(
    `${API_BASE_URL}/api/superadmin/publishers?${query.toString()}`,
    {
      headers: authHeaders(),
    }
  );

  return handleJsonResponse<PublisherRecord[]>(
    response,
    'Unable to fetch publishers'
  );
}

// Removed legacy superadmin publisher fetch implementation



// Duplicate fetchPublishers logic removed

export async function fetchPublisherDetail(
  publisherId: string
): Promise<PublisherDetail> {
  const response = await fetch(
    `${API_BASE_URL}/api/superadmin/publishers/${publisherId}`,
    {
      headers: authHeaders(),
    }
  );

  return handleJsonResponse<PublisherDetail>(
    response,
    'Unable to fetch publisher details'
  );
}

export async function createCompany(companyData: any): Promise<any> {
  const response = await fetch(`${AD_MOBILE_API_URL}/v1/company`, {
    method: 'POST',
    headers: mobileHeaders(),
    body: JSON.stringify(companyData),
  });
  return handleJsonResponse<any>(response, 'Unable to create company');
}

export async function createPublisherUser(userData: any): Promise<any> {
  const response = await fetch(`${AD_MOBILE_API_URL}/v1/user/create/PUBLISHER`, {
    method: 'POST',
    headers: mobileHeaders(),
    body: JSON.stringify(userData),
  });
  return handleJsonResponse<any>(response, 'Unable to create user');
}

export async function createPublisherRecord(data: any): Promise<any> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/publishers`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders()
    },
    body: JSON.stringify(data),
  });
  return handleJsonResponse<any>(response, 'Failed to create publisher');
}

export async function fetchAuditLogs(params?: { search?: string; actionType?: string; actorRole?: string; entityType?: string; fromDate?: string; toDate?: string }): Promise<AuditLogRecord[]> {
  const query = new URLSearchParams();
  if (params?.search) query.set('search', params.search);
  if (params?.actionType) query.set('actionType', params.actionType);
  if (params?.actorRole) query.set('actorRole', params.actorRole);
  if (params?.entityType) query.set('entityType', params.entityType);
  if (params?.fromDate) query.set('fromDate', params.fromDate);
  if (params?.toDate) query.set('toDate', params.toDate);
  const response = await fetch(`${API_BASE_URL}/api/superadmin/audit-logs?${query.toString()}`, { headers: authHeaders() });
  return handleJsonResponse<AuditLogRecord[]>(response, 'Unable to fetch audit logs');
}

export async function createAdminRecord(formData: FormData, jsonPayload: any): Promise<any> {
  try {
    const adMobileRes = await fetch(`${AD_MOBILE_API_URL}/v1/company`, { method: 'POST', headers: { Authorization: `Bearer ${AD_MOBILE_TOKEN}`, 'Content-Type': 'application/json' }, body: JSON.stringify(jsonPayload) });
    const adMobileData = await adMobileRes.json().catch(() => null);
    if (adMobileRes.ok && adMobileData && adMobileData.success !== false) {
      const companyId = adMobileData?.data?.companyId || adMobileData?.companyId || adMobileData?.data?._id || '';
      if (companyId) formData.append('companyId', companyId);
    } else {
      console.warn('[CreateAdmin] Ad Mobile registration skipped:', adMobileData?.message || adMobileData?.error || 'unknown error');
    }
  } catch (err) {
    console.warn('[CreateAdmin] Ad Mobile API unreachable, continuing with local registration:', err);
  }
  formData.append('superAdminCreate', 'true');
  const headers = authHeaders() ?? {};
  const springBootRes = await fetch(`${API_BASE_URL}/api/admin/register`, { method: 'POST', headers, body: formData });
  const springBootData = await springBootRes.json().catch(() => null);
  if (!springBootRes.ok || !springBootData || springBootData.success === false) {
    throw new Error(springBootData?.message || springBootData?.error || 'Registration failed');
  }
  return springBootData;
}