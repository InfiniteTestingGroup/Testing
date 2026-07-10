import { API_BASE_URL, AuthError, getAuthSession } from './auth'

export interface AdvertisementRecord {
  id: string
  title: string
  description?: string | null
  type: string
  adminId: string
  adminName: string
  publisherId: string
  publisherName: string
  createdDate: string
  createdAt?: string
  status: string
  impressions?: number | null
  clicks?: number | null
  ctr?: number | null
  startDate: string
  endDate: string
  location: string
  radius: string
  image?: string | null
  lat?: number | null
  lng?: number | null
  locationRange?: number | null
}

function authHeaders(): Record<string, string> {
  const session = getAuthSession()
  return session?.token
    ? { Authorization: `Bearer ${session.token}` }
    : {}
}

async function handleJsonResponse<T>(response: Response, fallbackMessage: string): Promise<T> {
  const payload = await response.json().catch(() => null) as T | { error?: string; message?: string } | null

  if (!response.ok) {
    const errorMessage =
      (payload && typeof payload === 'object' && 'message' in payload && payload.message) ||
      (payload && typeof payload === 'object' && 'error' in payload && payload.error) ||
      fallbackMessage
    throw new AuthError(String(errorMessage), response.status)
  }

  return payload as T
}

// Maps raw MongoDB adType ObjectId strings to human-readable labels.
const AD_TYPE_MAP: Record<string, string> = {
  '64887c11cce361dafc86c23b': 'Banner',
  '64887c11cce361dafc86c23c': 'Video',
  '64887c11cce361dafc86c23d': 'Image',
}

function resolveAdType(raw: string | null | undefined): string {
  if (!raw) return 'Banner'
  return AD_TYPE_MAP[raw] ?? raw
}

// ── Normalize status from any casing/field name ───────────────────────────────
// The backend DB field is "compaignsStatus" (typo) and values come as uppercase
// e.g. "ACTIVE", "SUSPENDED", "INACTIVE", "COMPLETED", "PAUSED", "PENDING", "EXPIRED".
// The backend's normalizeCampaignStatus() already converts these to Capitalized form
// before sending to the frontend, but we normalize here too as a safety net in case
// any raw value slips through (e.g. from suspendAdvertisement response).
function normalizeStatus(status?: string | null): string {
  if (!status) return 'Draft';
  const trimmed = status.trim().toLowerCase();
  if (trimmed === 'active') return 'Active';
  if (trimmed === 'completed') return 'Completed';
  if (trimmed === 'inactive') return 'Inactive';
  if (trimmed === 'suspended') return 'Suspended';
  if (trimmed === 'paused') return 'Paused';
  if (trimmed === 'pending') return 'Pending';
  if (trimmed === 'expired') return 'Expired';
  if (trimmed === 'draft') return 'Draft';
  // Capitalize any unknown status rather than losing it
  return status.trim().charAt(0).toUpperCase() + status.trim().slice(1).toLowerCase();
}

// ── Resolve the raw status value from any possible field name ─────────────────
// The backend sometimes sends "status" (after normalization) and sometimes
// "compaignsStatus" (the original DB field with the typo). We check all variants.
function resolveRawStatus(ad: any): string | null {
  return (
    ad.status ??
    ad.compaignsStatus ??
    ad.campaignStatus ??
    ad.campaignstatus ??
    null
  )
}

// Extract the mapping logic into a reusable function
function mapAd(ad: any): AdvertisementRecord {
  const impressions = ad.impressions ?? null
  const clicks = ad.clicks ?? null
  const ctr = ad.ctr ?? (
    impressions && clicks && impressions > 0
      ? parseFloat(((clicks / impressions) * 100).toFixed(2))
      : null
  )

  return {
    id: ad.id ?? ad._id ?? '',
    title: ad.title ?? 'Untitled Campaign',
    description: ad.description ?? null,
    type: resolveAdType(ad.adType ?? ad.type),
    adminId: ad.adminId ?? 'N/A',
    adminName: ad.adminName ?? 'Admin',
    publisherId: ad.publisherId ?? 'N/A',
    publisherName: ad.publisherName ?? 'Publisher Network',
    createdDate: ad.createdDate ?? '',
    createdAt: ad.createdAt ?? null,
    status: normalizeStatus(resolveRawStatus(ad)),
    impressions,
    clicks,
    ctr,
    startDate: ad.startDate ?? 'N/A',
    endDate: ad.endDate ?? 'N/A',
    location: ad.location ?? 'Unknown',
    radius: ad.radius ?? 'N/A',
    image: ad.image ?? null,
    lat: ad.lat != null ? Number(ad.lat) : null,
    lng: ad.lng != null ? Number(ad.lng) : null,
    locationRange: ad.locationRange != null ? Number(ad.locationRange) : null,
  };
}

/**
 * Fetch all ad campaigns directly from the local Spring Boot backend.
 * Endpoint: GET /api/superadmin/ads
 *
 * ── FIX: now handles both response shapes ──────────────────────────────────
 * The backend was updated to return a paginated object { content, totalElements, totalPages }.
 * The old check (!Array.isArray(payload) → return []) silently returned empty for all calls
 * used by filters, map view, and CSV export. Now handles both shapes correctly.
 */
export async function fetchAdvertisements(): Promise<AdvertisementRecord[]> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/ads`, {
    headers: authHeaders(),
  }).catch(() => null)

  if (!response?.ok) {
    console.warn('Could not fetch advertisements from backend. Returning empty.')
    return []
  }

  const payload = await response.json().catch(() => null)

  // ✅ Handle paginated response shape: { content: [], totalElements, totalPages }
  if (payload && !Array.isArray(payload) && Array.isArray(payload.content)) {
    return (payload.content as any[]).map(mapAd)
  }

  // ✅ Handle flat array (legacy / backward-compatible)
  if (Array.isArray(payload)) {
    return (payload as any[]).map(mapAd)
  }

  console.warn('Unexpected response shape from /api/superadmin/ads:', payload)
  return []
}

/**
 * Suspend an ad campaign via the local backend.
 * Endpoint: POST /api/superadmin/ads/{campaignId}/suspend
 */
export async function suspendAdvertisement(campaignId: string): Promise<AdvertisementRecord> {
  const response = await fetch(`${API_BASE_URL}/api/superadmin/ads/${campaignId}/suspend`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders(),
    },
  })

  const rawAd = await handleJsonResponse<any>(response, 'Unable to suspend advertisement')
  return mapAd(rawAd)
}

export async function fetchAdvertisementsPaginated(
  page: number = 0,
  size: number = 20
): Promise<{ content: AdvertisementRecord[]; totalElements: number; totalPages: number }> {
  const response = await fetch(
    `${API_BASE_URL}/api/superadmin/ads?page=${page}&size=${size}`,
    { headers: authHeaders() }
  ).catch(() => null);

  if (!response?.ok) return { content: [], totalElements: 0, totalPages: 0 };

  const payload = await response.json().catch(() => null);

  // If backend returns paginated object
  if (payload && !Array.isArray(payload)) {
    return {
      content: (payload.content ?? []).map(mapAd),
      totalElements: payload.totalElements ?? 0,
      totalPages: payload.totalPages ?? 0,
    };
  }

  // Fallback if backend still returns array (client-side slice)
  const all = (Array.isArray(payload) ? payload : []).map(mapAd);
  return {
    content: all.slice(page * size, (page + 1) * size),
    totalElements: all.length,
    totalPages: Math.ceil(all.length / size),
  };
}