import { adMobileApi, api } from './api';
import {
  AD_TYPE_UIDS,
  CTA_UIDS,
  CTA_LABEL_TO_CODE,
  ENDPOINTS,
  buildCreateAdPayload,
  buildCreateCampaignPayload,
} from '../config/constants';
// Re-export UIDs so existing imports don't break
export { AD_TYPE_UIDS, CTA_UIDS };
// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────
export type AdStatus = 'Draft' | 'Pending' | 'Active' | 'Expired' | 'Suspended';
export type PaymentStatus = 'Paid' | 'Pending' | 'Failed';
export interface Advertisement {
  id: string;
  dbId?: string; // MongoDB _id
  title: string;
  publishers: string[];
  status: AdStatus;
  startDate: string;
  endDate: string;
  impressions: number;
  clicks: number;
  ctr: number;
  paymentStatus: PaymentStatus;
  adTypeUID?: string;
  imageAdUID?: string; // was "thumbnailUID" — renamed to match frontend field
  customTextSection?: { title: string; description: string }[];
  createdAt?: string;
}
// ─────────────────────────────────────────────────────────────────────────────
// Ad Location Marker (for Map View)
// ─────────────────────────────────────────────────────────────────────────────
export interface AdLocationMarker {
  id: string;
  title: string;
  adType: 'Image Ad' | 'Video' | 'Banner';
  lat: number;
  lng: number;
  locationName: string;
  range: number;
  publishDate: string;
  thumbnailUrl?: string;
  status: string;
}
/**
 * Fetches all published ad locations by joining campaigns (which have location data)
 * with their corresponding advertisement details (title, type, thumbnail).
 * Used by the Dashboard Map View.
 */
export const fetchAdLocations = async (companyUID?: string): Promise<AdLocationMarker[]> => {
  const params: Record<string, any> = { page: 1, limit: 500 };
  if (companyUID) params.companyUID = companyUID;
  const [campaignsRes, adsRes] = await Promise.all([
    adMobileApi.get(ENDPOINTS.campaignsList, { params }).catch(() => ({ data: { data: [] } })),
    adMobileApi.get(ENDPOINTS.adsList, { params }).catch(() => ({ data: { data: [] } })),
  ]);
  const rawCampaigns: any[] = campaignsRes.data?.data ?? [];
  let rawAds: any[] = adsRes.data?.data ?? [];
  // Filter ads by company if admin-scoped
  if (companyUID) {
    rawAds = rawAds.filter((ad: any) => {
      const adCompanyId = ad.company?.uid || ad.company?._id || ad.company;
      return String(adCompanyId) === String(companyUID);
    });
  }
  // Build a lookup map: ad UID and _id → ad details
  const adsMap = new Map<string, any>();
  for (const ad of rawAds) {
    if (ad.uid) adsMap.set(String(ad.uid), ad);
    if (ad._id || ad.id) adsMap.set(String(ad._id || ad.id), ad);
  }
  // Reverse lookup: map ad type UID → human-readable label
  const adTypeUidToLabel: Record<string, 'Image Ad' | 'Video' | 'Banner'> = {};
  for (const [label, uid] of Object.entries(AD_TYPE_UIDS)) {
    adTypeUidToLabel[uid] = label as 'Image Ad' | 'Video' | 'Banner';
  }
  const markers: AdLocationMarker[] = [];
  for (const camp of rawCampaigns) {
    const loc = camp.location;
    if (!loc) continue;
    // Allow campaigns with missing or (0,0) coordinates if they have a non-empty locationName for geocoding
    const hasCoords = loc.lat != null && loc.lng != null && !(loc.lat === 0 && loc.lng === 0);
    const hasName = typeof loc.locationName === 'string' && loc.locationName.trim().length > 0;
    if (!hasCoords && !hasName) continue;

    const adIdStr = camp.advertisementId?._id || (typeof camp.advertisementId === 'string' ? camp.advertisementId : null);
    const adUidStr = camp.advertisementId?.uid;
    const ad = (adUidStr ? adsMap.get(String(adUidStr)) : null) || (adIdStr ? adsMap.get(String(adIdStr)) : null);

    // If company-scoped, only include campaigns whose ad belongs to the company
    if (companyUID && !ad) continue;

    const status = (camp.compaignsStatus || '').toUpperCase();

    // Include ACTIVE and PENDING campaigns (published ads)
    if (status !== 'ACTIVE' && status !== 'PENDING') continue;

    // Resolve ad type
    let adType: 'Image Ad' | 'Video' | 'Banner' = 'Image Ad';
    if (ad?.adType) {
      adType = adTypeUidToLabel[ad.adType] || 'Image Ad';
    }
    // Resolve thumbnail URL
    let thumbnailUrl: string | undefined;
    if (ad?.thumbnail?.url) {
      thumbnailUrl = ad.thumbnail.url;
    } else if (ad?.thumbnail?.s3Location) {
      thumbnailUrl = ad.thumbnail.s3Location;
    }
    markers.push({
      id: camp.uid || adIdStr || adUidStr || `marker-${markers.length}`,
      title: ad?.title || camp.advertisementId?.title || 'Untitled Ad',
      adType,
      lat: loc.lat ?? 0,
      lng: loc.lng ?? 0,
      locationName: loc.locationName || 'Unknown Location',
      range: loc.range || 0,
      publishDate: camp.dateRange?.fromDate || camp.createdAt || '',
      thumbnailUrl,
      status: status === 'ACTIVE' ? 'Active' : 'Pending',
    });
  }
  return markers;
};
export interface Company {
  uid: string;
  name: string;
  logoUrl?: string;
}
// ─────────────────────────────────────────────────────────────────────────────
// Media Upload
// POST /v1/media/upload  (multipart/form-data, field: "file")
// Response: { data: { uid: "<media-uid>" } }
// ─────────────────────────────────────────────────────────────────────────────
export const uploadMedia = async (file: File): Promise<string> => {
  console.log('📤 Uploading media:', { fileName: file.name, mimeType: file.type });
  try {
    const formData = new FormData();
    formData.append('file', file);
    const response = await api.post('/api/admin/media/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    let responseData = response.data;
    if (typeof responseData === 'string') {
      try {
        responseData = JSON.parse(responseData);
      } catch (e) {
        console.warn('Could not parse response data as JSON:', responseData);
      }
    }
    console.log('📦 Media upload response:', responseData);
    // Safely get the uid. Some backend versions might return it directly, or nested in data
    const uid = responseData?.data?.uid || responseData?.uid;
    if (!uid) {
      console.error('❌ Failed to extract uid from response:', responseData);
      throw new Error('No UID returned from media upload');
    }
    return uid;
  } catch (error) {
    console.error('❌ Media Upload API Error:', error);
    throw error;
  }
};
// ─────────────────────────────────────────────────────────────────────────────
// Company API
// GET /v1/company/PRODUCTS_SERVICES?all=yes
// Response: { success: true, data: [{ uid, name, companyLogo: { url } }] }
// ─────────────────────────────────────────────────────────────────────────────
export const fetchCompanies = async (): Promise<Company[]> => {
  const response = await adMobileApi.get(ENDPOINTS.companyList, {
    params: { all: 'yes' },
  });
  const list: any[] = response.data.data ?? [];
  return list.map((c) => ({
    uid: c.uid,
    name: c.name,
    logoUrl: c.companyLogo?.url,
  }));
};

export interface FetchAdsArgs {
  page: number;
  limit: number;
  search?: string;
  status?: string;
  publisher?: string;
  companyUID?: string;
  dateRange?: { start?: string; end?: string };
  paymentStatus?: string;
}

export interface FetchAdsResult {
  data: Advertisement[];
  totalItems: number;
  totalPages: number;
  uniquePublishers: string[];
}

async function fetchPaidAdIds(): Promise<Set<string>> {
  try {
    const token = localStorage.getItem('admin_token');
    const res = await api.get('/api/admin/payments/paid-ads', {
      headers: token ? { Authorization: `Bearer ${token}` } : {}
    });
    const ids: string[] = res.data?.paidAdIds ?? [];
    return new Set(ids);
  } catch {
    return new Set();
  }
}

let cachedAds: Advertisement[] | null = null;
let cachedUniquePublishers: string[] = [];

export const clearAdsCache = () => {
  cachedAds = null;
  cachedUniquePublishers = [];
};

export const fetchAds = async ({
  page,
  limit,
  search,
  status,
  companyUID,
  paymentStatus,
  publisher,
  dateRange,
}: FetchAdsArgs): Promise<FetchAdsResult> => {
  if (!cachedAds) {
    // Fetch all records for client-side filtering and pagination (limit set high)
    const params: Record<string, any> = { page: 1, limit: 10000 };
    if (companyUID) params.companyUID = companyUID;

    const [campaignsRes, adsRes, paidAdIds] = await Promise.all([
      adMobileApi.get(ENDPOINTS.campaignsList, { params }).catch((err) => {
        console.error("❌ [fetchAds] campaignsList error:", err.response?.status, err.response?.data || err.message);
        return { data: { data: [] } };
      }),
      adMobileApi.get(ENDPOINTS.adsList, { params }).catch((err) => {
        console.error("❌ [fetchAds] adsList error:", err.response?.status, err.response?.data || err.message);
        return { data: { data: [] } };
      }),
      fetchPaidAdIds()
    ]);

    const rawCampaigns = campaignsRes.data?.data ?? [];
    let rawAds = adsRes.data?.data ?? [];

    const publisherList = await fetchPublisherNames();

    const publisherMap = new Map(
      publisherList.map(p => [String(p.id), p.name])
    );

    if (companyUID) {
      rawAds = rawAds.filter((ad: any) => {
        const adCompanyId = ad.company?.uid || ad.company?._id || ad.company;
        return String(adCompanyId) === String(companyUID);
      });
    }

    const campaignMap = new Map<string, any>();
    for (const camp of rawCampaigns) {
      const adIdStr = camp.advertisementId?._id || (typeof camp.advertisementId === 'string' ? camp.advertisementId : null);
      const adUidStr = camp.advertisementId?.uid;

      const setInMap = (key: string, value: any) => {
        if (!key) return;
        const existing = campaignMap.get(key);
        if (!existing) {
          campaignMap.set(key, value);
        } else {
          const currentStatus = (value.compaignsStatus || '').toUpperCase();
          const existingStatus = (existing.compaignsStatus || '').toUpperCase();

          const priority: Record<string, number> = { 'ACTIVE': 3, 'PENDING': 2, 'INACTIVE': 1 };
          const currentPrio = priority[currentStatus] || 0;
          const existingPrio = priority[existingStatus] || 0;

          if (currentPrio > existingPrio || (currentPrio === existingPrio && new Date(value.createdAt).getTime() > new Date(existing.createdAt).getTime())) {
            campaignMap.set(key, value);
          }
        }
      };

      if (adIdStr) setInMap(String(adIdStr), camp);
      if (adUidStr) setInMap(String(adUidStr), camp);
      if (!adIdStr && !adUidStr && camp.uid) setInMap(String(camp.uid), camp);
    }

    const getPublishersFromCustomText = (customTextSection: any) => {
      if (customTextSection && Array.isArray(customTextSection)) {
        const pubSection = customTextSection.find(
          (s: any) => s.title === "assigned_publishers"
        );

        if (pubSection?.description) {
          try {
            const parsed = JSON.parse(pubSection.description);

            if (Array.isArray(parsed)) {
              return parsed;
            }
          } catch (e) {
            console.warn("Failed to parse assigned publishers", e);
          }
        }
      }

      return [];
    };

    let mergedAds: Advertisement[] = rawAds.map((ad: any) => {
      const adUid = ad.uid;
      const adId = ad._id || ad.id;
      const camp = (adUid ? campaignMap.get(String(adUid)) : null) || (adId ? campaignMap.get(String(adId)) : null);

      let normalizedStatus: AdStatus = 'Draft';
      let backendStatus = '';

      if (camp) {
        backendStatus = (camp.compaignsStatus || '').toUpperCase();
        const toDate = camp.dateRange?.toDate ? new Date(camp.dateRange.toDate) : null;
        const isExpired = toDate && toDate.getTime() < Date.now();

        if (isExpired || backendStatus === 'EXPIRED' || backendStatus === 'COMPLETED') normalizedStatus = 'Expired';
        else if (backendStatus === 'ACTIVE') normalizedStatus = 'Active';
        else if (backendStatus === 'PENDING') normalizedStatus = 'Pending';
        else if (backendStatus === 'SUSPENDED') normalizedStatus = 'Suspended';
        else if (backendStatus === 'INACTIVE') normalizedStatus = 'Draft';
      }
      const isPaid =
        paidAdIds.has(adUid) ||
        paidAdIds.has(adId) ||
        (ad.paymentStatus && ad.paymentStatus.toLowerCase() === 'paid');

      const assignedPublishers =
        getPublishersFromCustomText(ad.customTextSection);

      const publisherNames = assignedPublishers.map(
        (id: string) => publisherMap.get(String(id)) || id
      );

      return {
        id: adUid,
        title: ad.title || 'Untitled Campaign',
        publishers:
          publisherNames.length > 0
            ? publisherNames
            : (ad.company?.name ? [ad.company.name] : []),
        status: normalizedStatus,
        startDate: camp?.dateRange?.fromDate || ad.startDate,
        endDate: camp?.dateRange?.toDate || ad.endDate,
        impressions: camp?.reachedPublishingCount ?? 0,
        clicks: camp?.clicks ?? 0,
        ctr: camp?.ctr ?? 0,
        paymentStatus: isPaid ? ('Paid' as const) : ('Pending' as const),
        createdAt: ad.createdAt || undefined,
      };
    });

    const createdAtMap = new Map<string, number>();
    rawAds.forEach((ad: any) => {
      if (ad.uid && ad.createdAt) {
        createdAtMap.set(ad.uid, new Date(ad.createdAt).getTime());
      }
    });

    mergedAds.sort((a, b) => {
      return (
        new Date(b.startDate || '').getTime() -
        new Date(a.startDate || '').getTime()
      );
    });

    cachedAds = mergedAds;
    cachedUniquePublishers = Array.from(new Set(mergedAds.flatMap(ad => ad.publishers))).filter(Boolean);
  }

  let filtered = [...cachedAds];

  if (search) {
    const s = search.toLowerCase();
    filtered = filtered.filter(a => a.title.toLowerCase().includes(s));
  }
  if (status && status !== 'All') {
    filtered = filtered.filter(a => a.status === status);
  }
  if (paymentStatus && paymentStatus !== 'All') {
    filtered = filtered.filter(a => a.paymentStatus === paymentStatus);
  }
  if (publisher && publisher !== 'All') {
    filtered = filtered.filter(a => a.publishers.includes(publisher));
  }
  if (dateRange && (dateRange.start || dateRange.end)) {
    let startStr = dateRange.start;
    if (startStr && startStr.length === 10) {
      startStr += "T00:00:00.000";
    }

    let endStr = dateRange.end;
    if (endStr && endStr.length === 10) {
      endStr += "T23:59:59.999";
    }

    const filterStart = startStr ? new Date(startStr).getTime() : -Infinity;
    const filterEnd = endStr ? new Date(endStr).getTime() : Infinity;

    filtered = filtered.filter(a => {
      const adTime = new Date(a.startDate).getTime();

      return (
        !isNaN(adTime) &&
        adTime >= filterStart &&
        adTime <= filterEnd
      );
    });
  }

  const totalItems = filtered.length;
  const totalPages = Math.ceil(totalItems / limit) || 1;
  const paginatedAds = filtered.slice((page - 1) * limit, page * limit);

  return {
    data: paginatedAds,
    totalItems,
    totalPages,
    uniquePublishers: cachedUniquePublishers,
  };
};

// ─────────────────────────────────────────────────────────────────────────────
// Get Ad By ID
// GET /v1/advertisements/:uid
// ─────────────────────────────────────────────────────────────────────────────
export const getAdById = async (id: string): Promise<Advertisement> => {
  const getPublishersFromCustomText = (customTextSection: any) => {
    if (customTextSection && Array.isArray(customTextSection)) {
      const pubSection = customTextSection.find((s: any) => s.title === 'assigned_publishers');
      if (pubSection && pubSection.description) {
        try {
          const parsed = JSON.parse(pubSection.description);
          if (Array.isArray(parsed) && parsed.length > 0) {
            return parsed;
          }
        } catch (e) {
          console.warn('Failed to parse assigned_publishers from customTextSection:', e);
        }
      }
    }
    return null;
  };

  const paidAdIds = await fetchPaidAdIds();

  // Try the Ad Mobile API first (for ads that were created/synced there)
  try {
    const response = await adMobileApi.get(ENDPOINTS.adById(id))
    const ad = response.data.data
    if (!ad) throw new Error('Empty ad data from Ad Mobile API')

    let publishersList: string[] = ad.company?.name ? [ad.company.name] : [];
    const dbPublishers = getPublishersFromCustomText(ad.customTextSection);
    if (dbPublishers) {
      publishersList = dbPublishers;
    } else {
      try {
        const stored = localStorage.getItem(`assigned_publishers_${id}`);
        if (stored) {
          const parsed = JSON.parse(stored);
          if (Array.isArray(parsed) && parsed.length > 0) {
            publishersList = parsed;
          }
        }
      } catch (e) {
        console.warn('Failed to parse stored publishers:', e);
      }
    }

    const isPaid = paidAdIds.has(ad.uid || id);

    return {
      id: ad.uid || id,
      dbId: ad._id,
      title: ad.title,
      publishers: publishersList,
      status: ad.status ?? 'Draft',
      startDate: ad.startDate,
      endDate: ad.endDate,
      impressions: ad.impressions ?? 0,
      clicks: ad.clicks ?? 0,
      ctr: ad.ctr ?? 0,
      paymentStatus: isPaid ? 'Paid' : 'Pending',
      customTextSection: ad.customTextSection,
    }
  } catch (primaryErr) {
    console.warn('[getAdById] Ad Mobile API lookup failed, falling back to Spring Boot:', primaryErr)
  }

  // Fallback: fetch directly from Spring Boot (covers newly-created ads whose UUID
  // was assigned by Spring Boot before the Ad Mobile system synced it)
  const token = localStorage.getItem('admin_token')
  const fallback = await api.get(`/api/admin/advertisements/${id}`, {
    headers: token ? { Authorization: `Bearer ${token}` } : {}
  })
  const ad = fallback.data?.data
  if (!ad) throw new Error(`Advertisement ${id} not found`)

  let publishersList: string[] = [];
  const dbPublishers = getPublishersFromCustomText(ad.customTextSection);
  if (dbPublishers) {
    publishersList = dbPublishers;
  } else {
    try {
      const stored = localStorage.getItem(`assigned_publishers_${id}`);
      if (stored) {
        const parsed = JSON.parse(stored);
        if (Array.isArray(parsed) && parsed.length > 0) {
          publishersList = parsed;
        }
      }
    } catch (e) {
      console.warn('Failed to parse stored publishers:', e);
    }
  }

  const isPaid = paidAdIds.has(ad.uid || ad.id || id);

  return {
    id: ad.uid || ad.id || id,
    dbId: ad._id || ad.id,
    title: ad.title || 'Untitled Ad',
    publishers: publishersList,
    status: 'Draft',
    startDate: ad.startDate,
    endDate: ad.endDate,
    impressions: 0,
    clicks: 0,
    ctr: 0,
    paymentStatus: isPaid ? 'Paid' : 'Pending',
    customTextSection: ad.customTextSection,
  }
}

export const getAdDetail = async (id: string): Promise<any> => {
  const response = await adMobileApi.get(ENDPOINTS.adById(id));
  const ad = response.data.data;

  // Resolve main campaign status
  try {
    const userStr = localStorage.getItem('admin_user');
    let companyUID = undefined;
    if (userStr) {
      const user = JSON.parse(userStr);
      companyUID = user.companyUID || user.companyId || user.uid;
    }
    const params: Record<string, any> = {};
    if (companyUID) params.companyUID = companyUID;

    const campaignsRes = await adMobileApi.get(ENDPOINTS.campaignsList, { params }).catch(() => ({ data: { data: [] } }));
    const campaigns = campaignsRes.data?.data || [];
    const camp = campaigns.find((c: any) => {
      const adIdStr = c.advertisementId?._id || (typeof c.advertisementId === 'string' ? c.advertisementId : null);
      const adUidStr = c.advertisementId?.uid;
      return String(adIdStr) === String(ad._id || ad.id) || String(adUidStr) === String(ad.uid);
    });

    let normalizedStatus = 'Draft';
    if (camp) {
      const backendStatus = (camp.compaignsStatus || '').toUpperCase();
      const toDate = camp.dateRange?.toDate ? new Date(camp.dateRange.toDate) : null;
      const isExpired = toDate && toDate.getTime() < Date.now();

      if (isExpired || backendStatus === 'EXPIRED' || backendStatus === 'COMPLETED') normalizedStatus = 'Expired';
      else if (backendStatus === 'ACTIVE') normalizedStatus = 'Active';
      else if (backendStatus === 'PENDING') normalizedStatus = 'Pending';
      else if (backendStatus === 'SUSPENDED') normalizedStatus = 'Suspended';
      else if (backendStatus === 'INACTIVE') normalizedStatus = 'Draft';
    } else {
      normalizedStatus = ad.status === true || ad.status === 'ACTIVE' || ad.status === 'Active' ? 'Active' : 'Draft';
    }
    ad.status = normalizedStatus;
  } catch (err) {
    console.warn("Failed to resolve ad status from campaign:", err);
  }

  // Resolve main thumbnail image
  if (ad?.thumbnail) {
    if (typeof ad.thumbnail === 'object' && ad.thumbnail.url && ad.thumbnail.url.startsWith('http')) {
      // Already populated with valid HTTP URL, keep it!
    } else {
      const thumbUid = typeof ad.thumbnail === 'string' ? ad.thumbnail : (ad.thumbnail.uid || ad.thumbnail._id || ad.thumbnail.toString());
      if (thumbUid && !thumbUid.startsWith('http') && thumbUid !== '[object Object]') {
        try {
          const mediaUrlsRes = await adMobileApi.post('/v1/media/uids', { medias: [thumbUid] });
          const resolvedUrls = mediaUrlsRes.data?.data || mediaUrlsRes.data;
          if (Array.isArray(resolvedUrls) && resolvedUrls.length > 0) {
            const found = resolvedUrls[0];
            ad.thumbnail = {
              uid: thumbUid,
              url: found?.url || found?.s3Location || (typeof found === 'string' ? found : null)
            };
          }
        } catch (err) {
          console.warn("Failed to resolve thumbnail UID to S3 URL:", err);
        }
      }
    }
  }

  // Resolve banners if it's a Banner ad and contains UIDs
  if (ad?.content?.banners && ad.content.banners.length > 0) {
    try {
      const uidsToResolve = ad.content.banners.filter((b: string) => b && !b.startsWith('http'));
      if (uidsToResolve.length > 0) {
        const mediaUrlsRes = await adMobileApi.post('/v1/media/uids', { medias: uidsToResolve });
        const resolvedUrls = mediaUrlsRes.data?.data || mediaUrlsRes.data;

        ad.content.banners = ad.content.banners.map((b: string) => {
          if (!b || b.startsWith('http')) return b;
          if (Array.isArray(resolvedUrls)) {
            const found = resolvedUrls.find((r: any) => r?.uid === b || String(r?._id) === b || r === b);
            return found?.url || found?.s3Location || (typeof found === 'string' ? found : null) || `https://placehold.co/150?text=Banner-${b.substring(0, 8)}`;
          }
          return `https://placehold.co/150?text=Banner-${b.substring(0, 8)}`;
        });
      }
    } catch (err) {
      console.warn("Failed to resolve banner UIDs to S3 URLs:", err);
    }
  }

  return ad;
};
// ─────────────────────────────────────────────────────────────────────────────
// Create Advertisement (Draft)
// POST /v1/advertisements/create
//
// Payload built using buildCreateAdPayload() from constants.ts
// ─────────────────────────────────────────────────────────────────────────────
// Sanitize helper to prevent regex-based backend crashes on special characters
const sanitize = (str: string) => {
  if (!str) return str;
  return str.replace(/[()]/g, (match) => `\\${match}`);
};
export const createAd = async (data: any): Promise<Advertisement> => {
  // Resolve frontend CTA label → backend CTA code
  const ctaCode = CTA_LABEL_TO_CODE[data.ctaType] ?? 'REDIRECT';
  const payload = buildCreateAdPayload({
    title: sanitize(data.title),
    description: sanitize(data.description),
    adType: data.type,
    imageAdUID: data.imageAdUID,     // uploaded thumbnail/Image Ad UID
    companyUID: data.companyUID,
    ctaLabel: data.ctaLabel,
    ctaCode,
    ctaActionValue: data.ctaActionValue,
    customSections: (data.customSections ?? []).map((s: any) => ({
      title: sanitize(s.title),
      description: sanitize(s.description)
    })),
    bannerUIDs: data.bannerUIDs,
    videoUID: data.videoUID,
    videoUrl: data.videoUrl,
    videoType: data.videoType,
  });
  console.log("🚀 [CREATE] Advertisement Payload:", JSON.stringify(payload, null, 2));
  console.log('🚀 [CREATE] Payload company:', payload.company);
  const response = await api.post('/api/admin/advertisements/create', payload);
  console.log('📦 Create Ad Response:', response.data);
  console.log('📦 Created ad companyUID:', response.data.data?.company || response.data.data?.company?._id || response.data.data?.companyId);

  // Handle different response formats
  if (!response.data.success) {
    throw new Error(response.data.message || response.data.data || "Failed to create advertisement");
  }
  const result = response.data.data || response.data;
  clearAdsCache();
  return {
    id: result.uid || result._id,
    title: result.title || data.title,
    publishers: [],
    status: 'Draft',
    startDate: result.startDate || data.startDate,
    endDate: result.endDate || data.endDate,
    impressions: 0,
    clicks: 0,
    ctr: 0,
    paymentStatus: 'Pending',
  };
};
// ─────────────────────────────────────────────────────────────────────────────
// Update Advertisement
// PUT /v1/advertisements/update/:uid
// ─────────────────────────────────────────────────────────────────────────────
export const updateAd = async (id: string, data: any): Promise<Advertisement> => {
  // Fetch existing ad details to check for metadata we want to preserve
  let existingPublishersSection: any = null;
  try {
    const existingAd = await getAdById(id);
    if (existingAd.customTextSection && Array.isArray(existingAd.customTextSection)) {
      existingPublishersSection = existingAd.customTextSection.find((s: any) => s.title === 'assigned_publishers');
    }
  } catch (e) {
    console.warn('Failed to retrieve existing ad details for merging:', e);
  }

  const ctaCode = CTA_LABEL_TO_CODE[data.ctaType] ?? 'REDIRECT';
  const customSections = (data.customSections ?? []).map((s: any) => ({
    title: sanitize(s.title),
    description: sanitize(s.description)
  }));

  if (existingPublishersSection) {
    customSections.push(existingPublishersSection);
  }

  const payload = buildCreateAdPayload({
    title: sanitize(data.title),
    description: sanitize(data.description),
    adType: data.type,
    imageAdUID: data.imageAdUID,
    companyUID: data.companyUID,
    ctaLabel: data.ctaLabel,
    ctaCode,
    ctaActionValue: data.ctaActionValue,
    customSections,
    bannerUIDs: data.bannerUIDs,
    videoUID: data.videoUID,
    videoUrl: data.videoUrl,
    videoType: data.videoType,
  });
  console.log(`🚀 [UPDATE] Advertisement (${id}) Payload:`, JSON.stringify(payload, null, 2));
  const response = await api.put(`/api/admin/advertisements/update/${id}`, payload);
  console.log(`📦 Update Ad ${id} Response:`, response.data);

  if (!response.data.success) {
    throw new Error(response.data.message || response.data.data || "Failed to update advertisement");
  }
  const result = response.data.data;
  clearAdsCache();
  return {
    id: result.uid || result._id,
    title: result.title,
    publishers: [],
    status: 'Draft',
    startDate: result.startDate,
    endDate: result.endDate,
    impressions: 0,
    clicks: 0,
    ctr: 0,
    paymentStatus: 'Pending',
    customTextSection: result.customTextSection,
  };
};

export const updateAdPublicationDetails = async (
  id: string,
  data: {
    startDate: string;
    endDate: string;
    customTextSection?: { title: string; description: string }[];
  }
): Promise<void> => {
  const payload = {
    startDate: data.startDate,
    endDate: data.endDate,
    customTextSection: data.customTextSection,
  };
  console.log(`🚀 [UPDATE PUBLICATION DETAILS] Advertisement (${id}) Payload:`, JSON.stringify(payload, null, 2));
  const response = await api.put(`/api/admin/advertisements/update/${id}`, payload);
  if (!response.data.success) {
    throw new Error(response.data.message || response.data.data || "Failed to update publication details");
  }
  clearAdsCache();
};
// ─────────────────────────────────────────────────────────────────────────────
// Publish Ad → Create Campaign
// POST /v1/ad-campaigns/create
//
// Payload:
// {
//   advertisementId: "<ad-uid>",
//   dateRange: { fromDate, toDate },
//   location: { lat, lng, locationName, range },  ← range in METRES
//   compaignsStatus: "ACTIVE" | "PENDING",        ← backend typo preserved
//   createdThrough: "WEB"
// }
// ─────────────────────────────────────────────────────────────────────────────
export interface PublishPayload {
  startDate: string;
  endDate: string;
  // Geo-targeting from TargetingStep
  latitude: number;
  longitude: number;
  radiusKm: number;        // converted to metres for the backend
  locationName?: string;
}
export const finalizeAdPublication = async (
  advertisementId: string,
  data: PublishPayload
): Promise<void> => {
  // Resolve string UUID to MongoDB ObjectId first so Spring Boot can parse it
  let targetId = advertisementId;
  try {
    const ad = await getAdById(advertisementId);
    if (ad.dbId) {
      targetId = ad.dbId;
      console.log(`🎯 [finalizeAdPublication] Resolved UUID ${advertisementId} to MongoDB _id ${targetId}`);
    }
  } catch (e) {
    console.warn(`[finalizeAdPublication] Failed to resolve MongoDB _id for ad ${advertisementId}:`, e);
  }

  const payload = buildCreateCampaignPayload({
    advertisementId: targetId,
    fromDate: data.startDate,
    toDate: data.endDate,
    lat: data.latitude,
    lng: data.longitude,
    locationName: data.locationName ?? 'Selected Target Area',
    rangeMeters: Math.round(data.radiusKm * 1000), // km → metres
  });
  console.log("🚀 [PUBLISH] Campaign Payload:", JSON.stringify(payload, null, 2));
  const response = await api.post('/api/admin/campaigns/create', payload);
  console.log('📦 Create Campaign Response:', response.data);
  if (!response.data.success) {
    throw new Error(response.data.message || response.data.data || "Failed to publish advertisement");
  }
  clearAdsCache();
};
// ─────────────────────────────────────────────────────────────────────────────
// Delete Advertisement
// DELETE /v1/advertisements/:uid
// ─────────────────────────────────────────────────────────────────────────────
export const archiveAd = async (id: string): Promise<void> => {
  await api.delete(`/api/admin/advertisements/${id}`);
  clearAdsCache();
};
// ─────────────────────────────────────────────────────────────────────────────
// Stub helpers kept for backward compatibility with other pages
// These still use mock data until the API endpoints are confirmed
// ─────────────────────────────────────────────────────────────────────────────
export const publishAd = async (_id: string): Promise<Advertisement> => {
  // Kick off the campaign via API — for now returns a minimal shape
  // Real implementation should call finalizeAdPublication() from the publish wizard
  throw new Error(
    'Use finalizeAdPublication() from the publish wizard instead of publishAd().'
  );
};
export const duplicateAd = async (id: string): Promise<Advertisement> => {
  const original = await getAdById(id);
  // Duplicate by creating a new draft with the same title
  return createAd({
    title: `${original.title} (Copy)`,
    description: '',
    type: 'Image Ad',
    ctaType: 'Redirect',
    ctaLabel: 'Learn More',
    ctaActionValue: '',
    customSections: [{ title: '', description: '' }],
  });
};
export const fetchPublisherNames = async (): Promise<{ id: string; name: string }[]> => {
  const response = await api.get('/api/admin/publishers');
  const rawData = response.data?.publishers || [];
  return rawData.map((p: any) => ({
    id: p.id,
    name: p.name || 'Unknown',
  }));
};

