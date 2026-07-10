import React, { useEffect, useMemo, useState, useCallback, useRef } from 'react';
import { createPortal } from 'react-dom';
import {
  X, MapPin, Navigation, Loader2, Eye,
  Radio, Target, ChevronRight, Users, MousePointerClick
} from 'lucide-react';
import {
  GoogleMap,
  useJsApiLoader,
  Marker,
  InfoWindow,
  Circle,
} from '@react-google-maps/api';
import StatusBadge from '../shared/StatusBadge';

// ── Google Maps API key from env ─────────────────────────────────────────────
const GOOGLE_MAPS_API_KEY =
  import.meta.env.VITE_GOOGLE_MAPS_API_KEY || '';

// Must be module-level (stable reference) — inline arrays cause useJsApiLoader to warn
const GMAPS_LIBRARIES = ['geocoding'];

// ── Geocode via google.maps.Geocoder ─────────────────────────────────────────
function geocodeLocation(locationName) {
  const cacheKey = `keliri_geo_ad_gmaps_${locationName}`;
  try {
    const cached = sessionStorage.getItem(cacheKey);
    if (cached) return Promise.resolve(JSON.parse(cached));
  } catch { }

  return new Promise((resolve) => {
    try {
      const geocoder = new window.google.maps.Geocoder();
      geocoder.geocode({ address: locationName }, (results, status) => {
        if (status === 'OK' && results && results.length > 0) {
          const loc = results[0].geometry.location;
          const result = { lat: loc.lat(), lng: loc.lng() };
          try { sessionStorage.setItem(cacheKey, JSON.stringify(result)); } catch { }
          resolve(result);
        } else {
          resolve(null);
        }
      });
    } catch {
      resolve(null);
    }
  });
}

// ── Unified status metadata — case-insensitive lookup via getStatusMeta() ────
// Add any new DB status here; the legend is built dynamically from actual data.
const STATUS_COLOR_MAP = {
  active: { hex: '#10b981', colorClass: 'bg-emerald-500', label: 'Active' },
  pending: { hex: '#f59e0b', colorClass: 'bg-amber-500', label: 'Pending' },
  completed: { hex: '#3b82f6', colorClass: 'bg-blue-500', label: 'Completed' },
  suspended: { hex: '#f97316', colorClass: 'bg-orange-500', label: 'Suspended' },
  expired: { hex: '#6366f1', colorClass: 'bg-indigo-500', label: 'Expired' },
  paused: { hex: '#a855f7', colorClass: 'bg-purple-500', label: 'Paused' },
  inactive: { hex: '#94a3b8', colorClass: 'bg-slate-400', label: 'Inactive' },
  draft: { hex: '#6b7280', colorClass: 'bg-gray-500', label: 'Draft' },
};

function getStatusMeta(status = '') {
  return STATUS_COLOR_MAP[status.toLowerCase()] || {
    hex: '#6b7280', colorClass: 'bg-gray-400', label: status,
  };
}

// ── Resolve status from campaign object ───────────────────────────────────────
// DB field is sometimes "compaignsStatus" (typo) and sometimes "status".
// Values may be any case: "ACTIVE", "Active", "active" — all handled.
function resolveStatus(ad) {
  const rawStatus = (ad.status || ad.compaignsStatus || ad.campaignStatus || ad.campaignstatus || '').trim().toLowerCase();
  if (rawStatus === 'active') return 'Active';
  if (rawStatus === 'completed') return 'Completed';
  if (rawStatus === 'inactive') return 'Inactive';
  if (rawStatus === 'suspended') return 'Suspended';
  if (rawStatus === 'paused') return 'Paused';
  if (rawStatus === 'pending') return 'Pending';
  if (rawStatus === 'expired') return 'Expired';
  if (rawStatus === 'draft') return 'Draft';
  return rawStatus ? rawStatus.charAt(0).toUpperCase() + rawStatus.slice(1) : 'Draft';
}

// Keep a flat hex map for inline styles (InfoWindow uses inline styles)
const STATUS_COLORS = Object.fromEntries(
  Object.entries(STATUS_COLOR_MAP).map(([, v]) => [v.label, v.hex])
);

// ── Custom SVG marker icon (Google Maps) ─────────────────────────────────────
function makeMarkerIcon(color, isSelected = false) {
  const size = isSelected ? 36 : 28;
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size + 8}" viewBox="0 0 24 32">
      <circle cx="12" cy="12" r="10" fill="${color}" stroke="white" stroke-width="${isSelected ? 3 : 2}"/>
      <polygon points="12,32 7,20 17,20" fill="${color}"/>
    </svg>`;
  return {
    url: `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`,
    scaledSize: { width: size, height: size + 8 },
    anchor: { x: size / 2, y: size + 8 },
  };
}

// ── Group campaigns by resolved lat/lng ──────────────────────────────────────
function groupByLocation(campaigns) {
  const map = new Map();
  campaigns.forEach((ad) => {
    const key = `${ad._resolvedLat}_${ad._resolvedLng}`;
    if (!map.has(key)) {
      map.set(key, {
        locationName: ad.location || 'Unknown',
        lat: ad._resolvedLat,
        lng: ad._resolvedLng,
        range: ad.locationRange || null,
        campaigns: [],
      });
    }
    map.get(key).campaigns.push(ad);
  });
  return Array.from(map.values());
}

// ── Format helpers ────────────────────────────────────────────────────────────
function formatMetric(value, suffix = '') {
  if (value === null || value === undefined) return 'N/A';
  if (typeof value === 'number') return `${value.toLocaleString()}${suffix}`;
  return `${value}${suffix}`;
}

// ── Google Map style (clean, muted) ──────────────────────────────────────────
const MAP_STYLES = [
  { featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }] },
  { featureType: 'transit', stylers: [{ visibility: 'off' }] },
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#f5f5f5' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#c9e8f9' }] },
  { featureType: 'landscape', elementType: 'geometry', stylers: [{ color: '#f9f9f9' }] },
];

const MAP_CONTAINER_STYLE = { width: '100%', height: '100%' };
const DEFAULT_CENTER = { lat: 20.5937, lng: 78.9629 }; // India fallback


// ── Main AdvertisementMapView ─────────────────────────────────────────────────
export function AdvertisementMapView({ isOpen, onClose, campaigns = [], onViewDetails }) {
  const { isLoaded, loadError } = useJsApiLoader({
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: GMAPS_LIBRARIES,
  });

  const [selectedLocationKey, setSelectedLocationKey] = useState(null);
  const [openPopupKey, setOpenPopupKey] = useState(null);
  const [resolvedCampaigns, setResolvedCampaigns] = useState([]);
  const [isGeocoding, setIsGeocoding] = useState(false);
  const [geocodeProgress, setGeocodeProgress] = useState(0);
  const mapRef = useRef(null);

  // Reset on close
  useEffect(() => {
    if (!isOpen) {
      setSelectedLocationKey(null);
      setOpenPopupKey(null);
      setResolvedCampaigns([]);
    }
  }, [isOpen]);

  // Resolve lat/lng for all campaigns — deduplicated by unique location name.
  useEffect(() => {
    if (!isOpen || campaigns.length === 0 || !isLoaded) return;

    const resolve = async () => {
      setIsGeocoding(true);
      setGeocodeProgress(0);

      // Phase 1: Separate campaigns that already have coordinates from those needing geocoding
      const withCoords = [];
      const needsGeocode = [];

      for (const ad of campaigns) {
        if (ad.lat && ad.lng && !isNaN(ad.lat) && !isNaN(ad.lng)) {
          withCoords.push({ ...ad, _resolvedLat: ad.lat, _resolvedLng: ad.lng });
        } else {
          needsGeocode.push(ad);
        }
      }

      if (withCoords.length > 0) {
        setResolvedCampaigns([...withCoords]);
        setGeocodeProgress(Math.round((withCoords.length / campaigns.length) * 100));
      }

      // Phase 2: Deduplicate remaining campaigns by location name
      const uniqueLocations = new Map();
      for (let i = 0; i < needsGeocode.length; i++) {
        const loc = needsGeocode[i].location;
        if (loc && loc !== 'Unknown') {
          if (!uniqueLocations.has(loc)) {
            uniqueLocations.set(loc, []);
          }
          uniqueLocations.get(loc).push(i);
        }
      }

      // Phase 3: Geocode only unique locations
      const coordsByLocation = new Map();
      const locationEntries = Array.from(uniqueLocations.entries());
      let geocodedCount = 0;

      for (let i = 0; i < locationEntries.length; i++) {
        const [locationName] = locationEntries[i];
        let didGeocode = false;

        const cacheKey = `keliri_geo_ad_gmaps_${locationName}`;
        let coords = null;
        try {
          const cached = sessionStorage.getItem(cacheKey);
          if (cached) coords = JSON.parse(cached);
        } catch { }

        if (!coords) {
          didGeocode = true;
          coords = await geocodeLocation(locationName);
        }

        if (coords) coordsByLocation.set(locationName, coords);

        geocodedCount++;
        const totalDone = withCoords.length + Math.round(
          (geocodedCount / locationEntries.length) * needsGeocode.length
        );
        setGeocodeProgress(Math.round((Math.min(totalDone, campaigns.length) / campaigns.length) * 100));

        if (didGeocode && i < locationEntries.length - 1) {
          await new Promise((r) => setTimeout(r, 200));
        }
      }

      // Phase 4: Map resolved coordinates back to all campaigns
      const geocodedResults = [];
      for (const ad of needsGeocode) {
        const coords = ad.location ? coordsByLocation.get(ad.location) : null;
        if (coords) {
          geocodedResults.push({ ...ad, _resolvedLat: coords.lat, _resolvedLng: coords.lng });
        }
      }

      const allResults = [...withCoords, ...geocodedResults];
      setResolvedCampaigns(allResults);
      setGeocodeProgress(100);
      setIsGeocoding(false);
    };

    resolve();
  }, [isOpen, campaigns, isLoaded]);

  // NOTE: fitBounds is intentionally removed — the map starts on India (zoom 5)
  // and stays there until the user manually zooms or clicks a marker/location.

  // Pan to selected location
  useEffect(() => {
    if (!mapRef.current || !selectedGroup) return;
    mapRef.current.panTo({ lat: selectedGroup.lat, lng: selectedGroup.lng });
    mapRef.current.setZoom(13);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedLocationKey]);

  const locationGroups = useMemo(() => groupByLocation(resolvedCampaigns), [resolvedCampaigns]);

  const selectedGroup = useMemo(() => {
    if (!selectedLocationKey) return null;
    return locationGroups.find((g) => `${g.lat}_${g.lng}` === selectedLocationKey) || null;
  }, [selectedLocationKey, locationGroups]);

  // ── Dynamic legend: count ALL campaigns from the DB prop (not just geocoded ones)
  // This ensures Pending/Inactive/etc. ads without a location still appear in counts.
  const legendItems = useMemo(() => {
    const counts = new Map();
    campaigns.forEach((ad) => {
      const s = resolveStatus(ad);
      if (!s) return;
      counts.set(s, (counts.get(s) || 0) + 1);
    });
    return Array.from(counts.entries())
      .sort((a, b) => b[1] - a[1])
      .map(([statusKey, count]) => ({
        statusKey,
        count,
        ...getStatusMeta(statusKey),
      }));
  }, [campaigns]);

  const handleMarkerClick = useCallback((group) => {
    const key = `${group.lat}_${group.lng}`;
    setSelectedLocationKey((prev) => (prev === key ? null : key));
    setOpenPopupKey((prev) => (prev === key ? null : key));
  }, []);

  const handleSidebarLocationClick = useCallback((group) => {
    const key = `${group.lat}_${group.lng}`;
    setSelectedLocationKey(key);
    setOpenPopupKey(key);
  }, []);

  const isEmpty = resolvedCampaigns.length === 0;

  if (!isOpen) return null;

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 md:p-6">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-fade-in"
        onClick={onClose}
      />

      {/* Modal */}
      <div
        className="relative bg-white rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-fade-in-scale border border-gray-200"
        style={{ width: '95vw', maxWidth: 1280, height: '92vh', maxHeight: 820 }}
      >
        {/* ─── Header ──────────────────────────────────────────────────── */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 bg-white flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-primary-50 rounded-xl">
              <MapPin className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="text-base font-bold text-gray-900">Campaign Locations Map</h2>
              <p className="text-xs text-gray-400 mt-0.5">
                {isGeocoding
                  ? `Locating campaigns… ${geocodeProgress}%`
                  : isEmpty && campaigns.length === 0
                    ? 'No campaigns to display'
                    : isEmpty
                      ? `${campaigns.length} campaign${campaigns.length !== 1 ? 's' : ''} total · no location data to plot`
                      : `${locationGroups.length} location${locationGroups.length !== 1 ? 's' : ''} · ${resolvedCampaigns.length} plotted of ${campaigns.length} total`}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-all"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* ─── Body ────────────────────────────────────────────────────── */}
        <div className="flex flex-1 min-h-0">

          {/* Left Sidebar */}
          <div className="w-64 flex-shrink-0 border-r border-gray-100 bg-gray-50/50 flex flex-col overflow-hidden">
            <div className="px-4 pt-4 pb-2">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider">
                Locations ({locationGroups.length})
              </p>
            </div>
            <div className="flex-1 overflow-y-auto px-2 pb-3 space-y-1">
              {isGeocoding && locationGroups.length === 0 ? (
                <div className="flex items-center justify-center py-12">
                  <Loader2 className="w-5 h-5 text-primary-400 animate-spin" />
                </div>
              ) : locationGroups.length === 0 ? (
                <p className="text-xs text-gray-400 text-center py-8 px-2">No locations available</p>
              ) : (
                locationGroups.map((group) => {
                  const key = `${group.lat}_${group.lng}`;
                  const isActive = selectedLocationKey === key;
                  return (
                    <button
                      key={key}
                      onClick={() => handleSidebarLocationClick(group)}
                      className={`w-full text-left px-3 py-3 rounded-xl transition-all group/loc flex items-start gap-2.5 ${isActive
                        ? 'bg-primary-50 border border-primary-200 shadow-sm'
                        : 'hover:bg-white border border-transparent hover:border-gray-200 hover:shadow-sm'
                        }`}
                    >
                      <div className={`mt-0.5 p-1.5 rounded-lg flex-shrink-0 transition-colors ${isActive ? 'bg-primary-100 text-primary-600' : 'bg-gray-100 text-gray-400 group-hover/loc:bg-gray-200'
                        }`}>
                        <MapPin size={14} />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className={`text-sm font-semibold truncate ${isActive ? 'text-primary-700' : 'text-gray-800'}`}>
                          {group.locationName}
                        </p>
                        <p className="text-[10px] text-gray-400 mt-0.5">
                          {group.campaigns.length} campaign{group.campaigns.length !== 1 ? 's' : ''}
                        </p>
                      </div>
                      <ChevronRight
                        size={14}
                        className={`mt-1 flex-shrink-0 transition-transform ${isActive ? 'text-primary-500 rotate-90' : 'text-gray-300'}`}
                      />
                    </button>
                  );
                })
              )}
            </div>
          </div>

          {/* Center — Map */}
          <div className="flex-1 relative flex flex-col">
            <div className="flex-1 relative">

              {/* Geocoding overlay */}
              {isGeocoding && (
                <div className="absolute top-4 left-1/2 -translate-x-1/2 z-[1000]">
                  <div className="flex items-center gap-2.5 bg-white/95 backdrop-blur-sm px-4 py-2.5 rounded-xl shadow-lg border border-gray-200">
                    <Loader2 className="w-4 h-4 text-primary-500 animate-spin flex-shrink-0" />
                    <p className="text-xs font-medium text-gray-700 whitespace-nowrap">
                      Locating campaigns on map… {geocodeProgress}%
                    </p>
                  </div>
                </div>
              )}

              {/* Empty state */}
              {!isGeocoding && isEmpty && (
                <div className="absolute top-4 left-1/2 -translate-x-1/2 z-[1000] pointer-events-none">
                  <div className="flex items-center gap-2.5 bg-white/95 backdrop-blur-sm px-4 py-2.5 rounded-xl shadow-lg border border-gray-200">
                    <Navigation className="w-4 h-4 text-blue-500 flex-shrink-0" />
                    <p className="text-xs font-medium text-gray-700 whitespace-nowrap">
                      No campaign location data available
                    </p>
                  </div>
                </div>
              )}

              {/* API load error */}
              {loadError && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-50">
                  <p className="text-sm text-red-500 font-medium">Failed to load Google Maps. Check your API key.</p>
                </div>
              )}

              {/* Google Map */}
              {isLoaded && !loadError && (
                <GoogleMap
                  mapContainerStyle={MAP_CONTAINER_STYLE}
                  center={DEFAULT_CENTER}
                  zoom={5}
                  options={{
                    styles: MAP_STYLES,
                    disableDefaultUI: false,
                    mapTypeControl: false,
                    streetViewControl: false,
                    fullscreenControl: false,
                    zoomControlOptions: {
                      position: window.google.maps.ControlPosition.RIGHT_CENTER,
                    },
                  }}
                  onLoad={(map) => {
                    mapRef.current = map;
                    map.setCenter(DEFAULT_CENTER);
                    map.setZoom(5);
                  }}
                >
                  {/* Campaign markers */}
                  {locationGroups.map((group) => {
                    const key = `${group.lat}_${group.lng}`;
                    const isSelected = selectedLocationKey === key;
                    const primaryStatus = resolveStatus(group.campaigns[0]) || 'Draft';
                    const color = getStatusMeta(primaryStatus).hex;

                    return (
                      <React.Fragment key={key}>
                        <Marker
                          position={{ lat: group.lat, lng: group.lng }}
                          icon={makeMarkerIcon(color, isSelected)}
                          onClick={() => handleMarkerClick(group)}
                        />

                        {/* InfoWindow popup */}
                        {openPopupKey === key && (
                          <InfoWindow
                            position={{ lat: group.lat, lng: group.lng }}
                            onCloseClick={() => setOpenPopupKey(null)}
                            options={{ pixelOffset: new window.google.maps.Size(0, -(28 + 8)) }}
                          >
                            <div style={{ fontFamily: 'system-ui, sans-serif', maxWidth: 300 }}>
                              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
                                <div style={{
                                  width: 32, height: 32, borderRadius: 8,
                                  background: '#f0f9ff', display: 'flex', alignItems: 'center',
                                  justifyContent: 'center', flexShrink: 0,
                                }}>
                                  <span style={{ fontSize: 16 }}>📍</span>
                                </div>
                                <div>
                                  <p style={{ margin: 0, fontWeight: 700, fontSize: 14, color: '#111827' }}>
                                    {group.locationName}
                                  </p>
                                  <p style={{ margin: 0, fontSize: 10, color: '#9ca3af', fontFamily: 'monospace' }}>
                                    {group.lat.toFixed(4)}, {group.lng.toFixed(4)}
                                  </p>
                                </div>
                              </div>
                              <div style={{ maxHeight: 200, overflowY: 'auto' }}>
                                {group.campaigns.map((ad) => (
                                  <div
                                    key={ad.id}
                                    style={{
                                      padding: '8px 10px', marginBottom: 6,
                                      background: '#f9fafb', borderRadius: 10,
                                      border: '1px solid #f3f4f6',
                                    }}
                                  >
                                    <p style={{ margin: 0, fontWeight: 700, fontSize: 12, color: '#111827', marginBottom: 4 }}>
                                      {ad.title}
                                    </p>
                                    <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', fontSize: 10, color: '#6b7280' }}>
                                      <span style={{
                                        padding: '1px 6px', borderRadius: 999, fontSize: 9,
                                        fontWeight: 600, color: '#fff',
                                        background: getStatusMeta(resolveStatus(ad)).hex,
                                      }}>
                                        {getStatusMeta(resolveStatus(ad)).label}
                                      </span>
                                      <span>👁 {formatMetric(ad.impressions)}</span>
                                      <span>📊 {formatMetric(ad.ctr, '%')}</span>
                                    </div>
                                    {onViewDetails && (
                                      <button
                                        onClick={() => onViewDetails(ad)}
                                        style={{
                                          marginTop: 6, width: '100%', padding: '5px 0',
                                          background: '#6366f1', color: '#fff', border: 'none',
                                          borderRadius: 6, fontSize: 11, fontWeight: 700,
                                          cursor: 'pointer',
                                        }}
                                      >
                                        View Details →
                                      </button>
                                    )}
                                  </div>
                                ))}
                              </div>
                            </div>
                          </InfoWindow>
                        )}

                        {/* Range circle for selected location */}
                        {isSelected && group.range && (
                          <Circle
                            center={{ lat: group.lat, lng: group.lng }}
                            radius={group.range}
                            options={{
                              strokeColor: color,
                              strokeOpacity: 0.8,
                              strokeWeight: 2,
                              fillColor: color,
                              fillOpacity: 0.08,
                            }}
                          />
                        )}
                      </React.Fragment>
                    );
                  })}
                </GoogleMap>
              )}

              {/* Loading skeleton while Google Maps JS loads */}
              {!isLoaded && !loadError && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-100">
                  <Loader2 className="w-6 h-6 text-primary-400 animate-spin" />
                </div>
              )}
            </div>

          </div>

          {/* Right Panel — Campaign Details */}
          <div className="w-72 flex-shrink-0 border-l border-gray-100 bg-white flex flex-col overflow-hidden">
            <div className="px-4 pt-4 pb-2 border-b border-gray-50">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider">
                Campaign Details
              </p>
            </div>

            <div className="flex-1 overflow-y-auto px-3 py-3">
              {!selectedGroup ? (
                <div className="flex flex-col items-center justify-center h-full text-center px-4">
                  <div className="w-14 h-14 bg-gray-50 rounded-2xl flex items-center justify-center text-gray-300 mb-3">
                    <Target size={28} />
                  </div>
                  <p className="text-sm font-semibold text-gray-500">Select a location</p>
                  <p className="text-xs text-gray-400 mt-1">
                    Click a marker or location from the sidebar to view campaign details
                  </p>
                </div>
              ) : (
                <div className="space-y-2 animate-fade-in">
                  <div className="bg-primary-50/50 rounded-xl px-3 py-2.5 mb-3 border border-primary-100">
                    <div className="flex items-center gap-2">
                      <MapPin size={14} className="text-primary-500 flex-shrink-0" />
                      <p className="text-sm font-bold text-primary-800 truncate">{selectedGroup.locationName}</p>
                    </div>
                    <p className="text-[10px] text-primary-400 mt-0.5 font-mono ml-5">
                      {selectedGroup.lat.toFixed(4)}, {selectedGroup.lng.toFixed(4)}
                      {selectedGroup.range && ` · ${selectedGroup.range}m radius`}
                    </p>
                  </div>

                  {selectedGroup.campaigns.map((ad) => (
                    <div
                      key={ad.id}
                      className="bg-white rounded-xl border border-gray-100 shadow-sm p-3 hover:shadow-md hover:border-gray-200 transition-all"
                    >
                      <div className="flex items-start justify-between mb-2">
                        <h5 className="text-sm font-bold text-gray-900 leading-tight line-clamp-2 flex-1 mr-2">
                          {ad.title}
                        </h5>
                        <StatusBadge status={resolveStatus(ad)} />
                      </div>

                      <div className="space-y-1.5 mb-3">
                        <div className="flex items-center gap-1.5 text-[10px]">
                          <span className="font-bold text-gray-400 uppercase tracking-tighter">ID</span>
                          <span className="font-mono text-gray-500 truncate">{ad.id}</span>
                        </div>
                        <div className="flex items-center gap-1.5 text-[10px]">
                          <Radio size={10} className="text-purple-400" />
                          <span className="text-gray-500 truncate">{ad.publisherName}</span>
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-2 mb-3">
                        <div className="bg-gray-50 rounded-lg px-2 py-1.5 text-center">
                          <p className="text-[9px] font-bold text-gray-400 uppercase">Impressions</p>
                          <p className="text-xs font-black text-gray-900">{formatMetric(ad.impressions)}</p>
                        </div>
                        <div className="bg-gray-50 rounded-lg px-2 py-1.5 text-center">
                          <p className="text-[9px] font-bold text-gray-400 uppercase">CTR</p>
                          <p className="text-xs font-black text-primary-500">{formatMetric(ad.ctr, '%')}</p>
                        </div>
                      </div>

                      {onViewDetails && (
                        <button
                          onClick={() => onViewDetails(ad)}
                          className="w-full flex items-center justify-center gap-1.5 px-3 py-2 bg-gray-900 hover:bg-gray-800 text-white rounded-lg text-xs font-bold transition-all active:scale-95"
                        >
                          <Eye size={12} />
                          View Details
                        </button>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* ─── Legend with status counts ───────────────────────────── */}
            <div className="px-4 pb-4 pt-3 border-t border-gray-100 flex-shrink-0">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider mb-2.5">
                Legend
              </p>
              {legendItems.length === 0 ? (
                <p className="text-[11px] text-gray-400">No campaigns loaded yet</p>
              ) : (
                <div className="flex flex-col gap-1.5">
                  {legendItems.map((l) => (
                    <div key={l.statusKey} className="flex items-center justify-between gap-2">
                      <div className="flex items-center gap-2">
                        <div className={`w-2.5 h-2.5 rounded-full ${l.colorClass} flex-shrink-0`} />
                        <span className="text-[11px] text-gray-500">{l.label} Campaign</span>
                      </div>
                      <span className="text-[11px] font-bold text-gray-700 bg-gray-100 rounded-md px-1.5 py-0.5 min-w-[28px] text-center tabular-nums">
                        {l.count.toLocaleString()}
                      </span>
                    </div>
                  ))}
                </div>
              )}
            </div>

          </div>

        </div>
      </div>
    </div>,
    document.body
  );
}

export default AdvertisementMapView;