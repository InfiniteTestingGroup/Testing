// ─────────────────────────────────────────────────────────────────────────────
// Keliri Admin — Central Configuration Constants
// Source of truth: uidflow.md (April 2026)
// ─────────────────────────────────────────────────────────────────────────────
// ── Backend URLs ──────────────────────────────────────────────────────────────
/** Ad Mobile App EC2 backend — all advertisement & campaign API calls */
export const AD_MOBILE_BACKEND_URL =
  import.meta.env.VITE_AD_MOBILE_BACKEND_URL ||
  "http://localhost:3000";
/** Admin Spring Boot backend — admin auth, registration, session */
export const ADMIN_BACKEND_URL =
  import.meta.env.VITE_API_BASE_URL || "";
// ── Google Maps ───────────────────────────────────────────────────────────────
/**
 * Google Maps API Key
 *  - Places Autocomplete: maps.googleapis.com/maps/api/place/autocomplete/json
 *  - Place Details:       maps.googleapis.com/maps/api/place/details/json
 *  - Reverse Geocoding:   maps.googleapis.com/maps/api/geocode/json
 */
export const GOOGLE_MAPS_API_KEY =
  import.meta.env.VITE_GOOGLE_MAPS_API_KEY ||
  ""; // Use empty string to disable Google Maps if not configured
// ── Ad Type UIDs ──────────────────────────────────────────────────────────────
// These are sent as `adType` in the advertisement creation payload.
export const AD_TYPE_UIDS = {
  /** Single high-quality visual banner */
  "Image Ad": "fa2d8d92-bfd7-48af-aad1-8a55c84d436d",
  /** Engaging motion content (MP4, YouTube, Vimeo) */
  Video: "f91cf072-c131-48f5-ae1b-3bd9434e47ac",
  /** Carousel of up to 4 high-impact images */
  Banner: "6707daa0-7efa-4ccd-990d-a97cdb4f0dc7",
} as const;
export type AdTypeName = keyof typeof AD_TYPE_UIDS;
// ── CTA (Call-to-Action) UIDs ─────────────────────────────────────────────────
// Sent as `ctaId` inside `cta.buttons[]` in the advertisement payload.
export const CTA_UIDS = {
  /** Open a website URL */
  REDIRECT: "f9360ea0-6eb0-4206-9496-164ffe50437a",
  /** Dial a phone number */
  DIAL: "725336d4-c052-46e6-a97c-0d3e8d7dfe44",
  /** Open WhatsApp chat */
  WHATSAPP: "1fbc903d-4e08-41ff-bff7-6ad865c6ac69",
  /** Send an email */
  MAIL: "435cc0ec-42ac-451a-9e7b-d40d814a5e9f",
  /** Navigate to a map location */
  TAKEMETO: "2deba5ba-b81b-47d3-afa2-0c9cceaadbd2",
} as const;
export type CTACode = keyof typeof CTA_UIDS;
/**
 * Maps frontend CTA label → backend CTA code.
 * The frontend uses human-readable names; the backend uses uppercase codes.
 */
export const CTA_LABEL_TO_CODE: Record<string, CTACode> = {
  Redirect: "REDIRECT",
  Dial: "DIAL",
  WhatsApp: "WHATSAPP",
  Email: "MAIL",    // frontend "Email" → backend "MAIL"
  Map: "TAKEMETO",  // frontend "Map"   → backend "TAKEMETO"
};
// ── API Endpoints (Ad Mobile Backend) ────────────────────────────────────────
export const ENDPOINTS = {
  // Auth
  login: "/v1/user/login",                   // POST ?authType=PHONE&userType=PUBLISHER
  verifyOtp: "/v1/user/verify-otp",          // POST
  resendOtp: "/v1/user/resend-otp",          // POST
  // Media
  mediaUpload: "/v1/media/upload",           // POST multipart/form-data { file }
  // Response: { data: { uid: "<media-uid>" } }
  // Advertisements
  adsCreate: "/v1/advertisements/create",    // POST
  adsUpdate: (uid: string) => `/v1/advertisements/update/${uid}`, // PUT
  adsDelete: (uid: string) => `/v1/advertisements/${uid}`,        // DELETE
  adsList: "/v1/advertisements",             // GET ?page=N&limit=5
  adById: (uid: string) => `/v1/advertisements/${uid}`,           // GET
  // Campaigns
  campaignCreate: "/v1/ad-campaigns/create",                             // POST
  campaignDelete: (uid: string) => `/v1/ad-campaigns/${uid}`,            // DELETE
  campaignsByUser: (userUid: string) => `/v1/ad-campaigns/user-uid/${userUid}`, // GET
  campaignsList: "/v1/ad-campaigns",          // GET ?page=N&limit=5
  // Company
  companyList: "/v1/company/PRODUCTS_SERVICES", // GET ?all=yes
} as const;
// ── Maps API Endpoints ────────────────────────────────────────────────────────
export const MAPS_ENDPOINTS = {
  placesAutocomplete: (input: string) =>
    GOOGLE_MAPS_API_KEY
      ? `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${encodeURIComponent(input)}&key=${GOOGLE_MAPS_API_KEY}`
      : null,
  placeDetails: (placeId: string) =>
    GOOGLE_MAPS_API_KEY
      ? `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${GOOGLE_MAPS_API_KEY}`
      : null,
  reverseGeocode: (lat: number, lng: number) =>
    GOOGLE_MAPS_API_KEY
      ? `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${GOOGLE_MAPS_API_KEY}`
      : null,
} as const;
// ── Campaign Status ───────────────────────────────────────────────────────────
export const CAMPAIGN_STATUS = {
  /** start date = today */
  ACTIVE: "ACTIVE",
  /** end date is in the past */
  COMPLETED: "COMPLETED",
  /** default — future start date */
  PENDING: "PENDING",
} as const;
export const CREATED_THROUGH = "WEB" as const;
// ── Payload Builders ──────────────────────────────────────────────────────────
export interface CreateAdPayloadArgs {
  title: string;
  description: string;
  adType: AdTypeName;
  imageAdUID?: string;       // media UID — the "Image Ad" / cover image (backend field: thumbnail)
  companyUID?: string;
  startDate?: string;
  endDate?: string;
  ctaLabel: string;
  ctaCode: CTACode;
  ctaActionValue: string;
  customSections: { title: string; description: string }[];
  // Type-specific content
  bannerUIDs?: string[];     // Banner Ad  — banner image media UIDs
  videoUID?: string;         // Video Ad   — uploaded video media UID
  videoUrl?: string;         // Video Ad   — YouTube / Vimeo URL
  videoType?: "VIDEO" | "YOUTUBE" | "VIMEO";
}
/** Builds the exact POST /v1/advertisements/create payload */
export function buildCreateAdPayload(args: CreateAdPayloadArgs) {
  const {
    title, description, adType, imageAdUID, companyUID,
    startDate, endDate,
    ctaLabel, ctaCode, ctaActionValue,
    customSections,
    bannerUIDs, videoUID, videoUrl, videoType,
  } = args;
  const content =
    adType === "Image Ad"
      ? { simpleTextFile: null, AdText: "" }
      : adType === "Banner"
        ? { banners: bannerUIDs ?? [] }
        : {
          videoType: videoType ?? (videoUID ? "VIDEO" : videoUrl?.includes("youtube") ? "YOUTUBE" : "VIMEO"),
          videoLink: videoUID ?? videoUrl ?? "",
        };
  return {
    title,
    description,
    adType: AD_TYPE_UIDS[adType],
    thumbnail: imageAdUID,          // backend expects field name "thumbnail"
    company: companyUID,
    startDate: startDate ?? new Date().toISOString(),
    endDate: endDate ?? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
    cta: {
      ctaType: "Button",
      buttons: [
        {
          ctaId: CTA_UIDS[ctaCode],
          content: {
            label: ctaLabel,
            buttonType: "Button",
            action: ctaActionValue,
            style: {
              icon: "open_in_browser",
              backgroundColor: "#004369",
              textColor: "#ffffff",
            },
          },
        },
      ],
    },
    customTextSection: customSections,
    content,
  };
}
export interface CreateCampaignPayloadArgs {
  advertisementId: string;
  fromDate: string;
  toDate: string;
  lat: number;
  lng: number;
  locationName: string;
  rangeMeters: number; // radius in metres
}
/** Builds the exact POST /v1/ad-campaigns/create payload */
export function buildCreateCampaignPayload(args: CreateCampaignPayloadArgs) {
  const { advertisementId, fromDate, toDate, lat, lng, locationName, rangeMeters } = args;
  return {
    advertisementId,
    dateRange: {
      fromDate,
      toDate,
      startDate: fromDate, // Support both node and java backend date schemas
      endDate: toDate,     // Support both node and java backend date schemas
    },
    location: {
      lat,
      lng,
      locationName,
      range: rangeMeters,           // backend field is "range" in metres
    },
    compaignsStatus: CAMPAIGN_STATUS.PENDING, // Created as PENDING before payment
    createdThrough: CREATED_THROUGH,
  };
}
