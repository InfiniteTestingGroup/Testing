import React, { useEffect, useMemo, useState } from 'react';
import { createPortal } from 'react-dom';
import { X, MapPin, Navigation, Loader2, Eye } from 'lucide-react';
import { LoadScriptNext, GoogleMap, Marker, InfoWindow } from '@react-google-maps/api';

// Leaflet init removed – using Google Maps

// ── Nominatim geocoding (OpenStreetMap, free, no API key) ─────────────────────
async function geocodePublisher(publisher) {
  // Use existing coordinates if present
  if (publisher.latitude != null && publisher.longitude != null) {
    return { lat: publisher.latitude, lng: publisher.longitude };
  }
  // Perform fresh geocoding for missing coordinates
  const cleanLocation = publisher.location.replace(/[\r\n]+/g, ', ');
  const parts = [cleanLocation, publisher.name].filter(Boolean);
  const query = parts.join(', ');
  try {
    const res = await fetch(`https://photon.komoot.io/api/?q=${encodeURIComponent(query)}&limit=1`);
    const data = await res.json();
    if (data && data.features && data.features.length > 0) {
      const lon = data.features[0].geometry.coordinates[0];
      const lat = data.features[0].geometry.coordinates[1];
      return { lat, lng: lon };
    }
  } catch { }
  return null;
}

// ── Custom SVG marker ─────────────────────────────────────────────────────────


const STATUS_COLORS = {
  Active: '#22c55e',
  Inactive: '#f97316',
  Suspended: '#ef4444',
};
const getStatus = (publisher) => {
  const status = String(publisher.status || "").toLowerCase();

  if (status === "suspended") return "suspended";
  if (status === "active" || status === "true") return "active";

  return "inactive";
};

// ── Auto fit bounds ───────────────────────────────────────────────────────────
function BoundsController({ publishers }) { return null; }

// ── Filter config ─────────────────────────────────────────────────────────────
const filterConfig = [
  { key: 'all', label: 'All Publishers', colorClass: 'bg-gray-100 text-gray-700 border-gray-200', dot: 'bg-gray-500' },
  { key: 'active', label: 'Active', colorClass: 'bg-green-50 text-green-700 border-green-200', dot: 'bg-green-500' },
  { key: 'inactive', label: 'Inactive', colorClass: 'bg-orange-50 text-orange-700 border-orange-200', dot: 'bg-orange-500' },
  { key: 'suspended', label: 'Suspended', colorClass: 'bg-red-50 text-red-700 border-red-200', dot: 'bg-red-500' },
];

// ── Main PublisherMapView ─────────────────────────────────────────────────────
export function PublisherMapView({ isOpen, onClose, publishers = [], onPublisherClick }) {
  const [filter, setFilter] = useState('all');
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [geocodedPublishers, setGeocodedPublishers] = useState([]);
  const [currentLocation, setCurrentLocation] = useState(null);
  const [mapCenter, setMapCenter] = useState({ lat: 20.5937, lng: 78.9629 });
  const [zoomLevel, setZoomLevel] = useState(5);
  const [mapRef, setMapRef] = useState(null);

  // Detect GPS on open
  useEffect(() => {
    if (!isOpen) return;
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (pos) => {
          const loc = { lat: pos.coords.latitude, lng: pos.coords.longitude };
          setCurrentLocation(loc);
          setMapCenter(loc);
        },
        () => setCurrentLocation({ lat: 20.5937, lng: 78.9629 }),
        { enableHighAccuracy: true, timeout: 6000 }
      );
    }
  }, [isOpen]);

  // Update map when location changes (in case it updates later)
  useEffect(() => {
    if (currentLocation) {
      setMapCenter(currentLocation);
    }
  }, [currentLocation]);

  // Cache for geocoded results to avoid re‑fetching on every modal open


  // Use existing latitude/longitude from publisher records directly for map markers
  useEffect(() => {
    if (!isOpen) return;

    const results = publishers.map((pub) => {
      let latitude = pub.latitude;
      let longitude = pub.longitude;

      // If lat/lng are missing, extract from location string
      if (
        (latitude == null || longitude == null) &&
        typeof pub.location === "string"
      ) {
        const parts = pub.location.split(",");

        if (parts.length >= 2) {
          const lat = parseFloat(parts[0].trim());
          const lng = parseFloat(parts[1].trim());

          if (!isNaN(lat) && !isNaN(lng)) {
            latitude = lat;
            longitude = lng;
          }
        }
      }

      return {
        ...pub,
        latitude,
        longitude,
      };
    });

    console.log("Publishers mapped for map:", results);

    setGeocodedPublishers(results);
  }, [isOpen, publishers]);

  const validPublishers = useMemo(() => {
    return geocodedPublishers.filter(p => p.latitude != null && p.longitude != null && !isNaN(p.latitude) && !isNaN(p.longitude));
  }, [geocodedPublishers]);

  const filtered = useMemo(() => {
    if (filter === 'all') return validPublishers;
    return validPublishers.filter((p) => getStatus(p) === filter);
  }, [validPublishers, filter]);

  const displayPublishers = useMemo(() => {
    const groups = {};
    filtered.forEach(p => {
      const key = `${p.latitude},${p.longitude}`;
      if (!groups[key]) groups[key] = [];
      groups[key].push(p);
    });

    const result = [];
    Object.values(groups).forEach(group => {
      if (group.length === 1) {
        result.push({ ...group[0], originalLat: group[0].latitude, originalLng: group[0].longitude, isGroup: false });
      } else if (zoomLevel < 12) {
        const representative = group.find(p => getStatus(p) === 'active') || group[0];
        result.push({
          ...representative,
          id: `group-${group[0].latitude}-${group[0].longitude}`,
          originalLat: group[0].latitude,
          originalLng: group[0].longitude,
          isGroup: true,
          groupedPublishers: group,
          latitude: group[0].latitude,
          longitude: group[0].longitude
        });
      } else {
        const radius = 0.0003;
        group.forEach((p, index) => {
          const angle = (2 * Math.PI * index) / group.length;
          result.push({
            ...p,
            originalLat: p.latitude,
            originalLng: p.longitude,
            latitude: p.latitude + radius * Math.cos(angle),
            longitude: p.longitude + radius * Math.sin(angle),
            isGroup: false
          });
        });
      }
    });
    return result;
  }, [filtered, zoomLevel]);

  const isEmpty = validPublishers.length === 0;
  const defaultCenter = mapCenter;

  if (!isOpen) return null;

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 md:p-6">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-fade-in" onClick={onClose} />

      {/* Modal */}
      <div
        className="relative bg-white rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-fade-in-scale border border-gray-200" style={{ width: '95vw', maxWidth: 1100, height: '90vh', maxHeight: 700 }}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 bg-white flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-orange-50 rounded-xl">
              <MapPin className="w-5 h-5 text-orange-500" />
            </div>
            <div>
              <h2 className="text-base font-bold text-gray-900">Publisher Locations Map</h2>
              <p className="text-xs text-gray-400 mt-0.5">
                {isEmpty
                  ? 'No publisher data'
                  : `${filtered.length} of ${validPublishers.length} publisher${validPublishers.length !== 1 ? 's' : ''} shown`}
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

        {/* Body */}
        <div className="flex flex-1 min-h-0">
          {/* Map */}
          <div className="flex-1 relative">

            <LoadScriptNext googleMapsApiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY || ""}>
              <GoogleMap
                mapContainerStyle={{ width: '100%', height: '100%' }}
                center={defaultCenter}
                zoom={5}
                options={{ mapTypeControl: false, streetViewControl: false, fullscreenControl: false }}
                onLoad={(map) => setMapRef(map)}
                onZoomChanged={() => {
                  if (mapRef) {
                    const newZoom = mapRef.getZoom();
                    setZoomLevel(prev => {
                      if ((prev < 12 && newZoom >= 12) || (prev >= 12 && newZoom < 12)) {
                        setSelectedLocation(null);
                      }
                      return newZoom;
                    });
                  }
                }}
              >
                {/* Publisher markers */}
                {displayPublishers.map((pub) => (
                  <Marker
                    key={pub.id}
                    position={{
                      lat: pub.latitude,
                      lng: pub.longitude,
                    }}
                    onClick={() => setSelectedLocation(pub)}
                    icon={{
                      path: window.google?.maps?.SymbolPath?.CIRCLE,
                      fillColor:
                        getStatus(pub) === 'active'
                          ? '#22c55e'
                          : getStatus(pub) === 'suspended'
                            ? '#ef4444'
                            : '#f97316',
                      fillOpacity: 1,
                      strokeColor: '#fff',
                      strokeWeight: 2,
                      scale: 8,
                    }}
                  />
                ))}

                {selectedLocation && (
                  <InfoWindow position={{
                    lat: selectedLocation.latitude,
                    lng: selectedLocation.longitude,
                  }}
                    onCloseClick={() => setSelectedLocation(null)}
                  >
                    {(() => {
                      const pubsAtLocation = selectedLocation.isGroup ? selectedLocation.groupedPublishers : [selectedLocation];
                      return (
                        <div className="p-3 max-h-[300px] overflow-y-auto w-64 custom-scrollbar">
                          {pubsAtLocation.length > 1 && (
                            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3 border-b border-gray-100 pb-2">
                              {pubsAtLocation.length} Publisher{pubsAtLocation.length !== 1 ? 's' : ''} Here
                            </p>
                          )}
                          {pubsAtLocation.map((pub, idx) => (
                            <div key={pub.id} className={`${idx > 0 ? 'mt-4 pt-4 border-t border-gray-100' : ''}`}>
                              <div className="flex justify-between items-start mb-1">
                                <p className="font-bold text-sm text-gray-900 pr-2">
                                  {pub.name}
                                </p>
                                <div className="flex items-center gap-1 shrink-0 bg-gray-50 px-1.5 py-0.5 rounded-md">
                                  <div className={`w-1.5 h-1.5 rounded-full ${getStatus(pub) === 'active' ? 'bg-green-500' : getStatus(pub) === 'suspended' ? 'bg-red-500' : 'bg-orange-500'}`} />
                                  <span className="text-[10px] text-gray-600 capitalize font-medium">{getStatus(pub)}</span>
                                </div>
                              </div>

                              <p className="text-[11px] text-gray-500 mb-2 truncate">
                                {pub.email || "No email"}
                              </p>

                              <div className="flex items-center gap-3 mb-3">
                                <div className="text-center bg-gray-50 rounded-md px-2 py-1 flex-1">
                                  <p className="text-[9px] text-gray-400 uppercase font-bold">Ads</p>
                                  <p className="text-xs font-semibold text-gray-700">{pub.adsPosted}</p>
                                </div>
                                <div className="text-center bg-gray-50 rounded-md px-2 py-1 flex-1">
                                  <p className="text-[9px] text-gray-400 uppercase font-bold">Engage</p>
                                  <p className="text-xs font-semibold text-primary-600">{pub.engagement}%</p>
                                </div>
                              </div>

                              <button
                                onClick={() => onPublisherClick?.(pub)}
                                className="w-full py-1.5 bg-primary-50 hover:bg-primary-500 text-primary-600 hover:text-white rounded-lg text-xs font-bold transition-colors flex items-center justify-center gap-1"
                              >
                                <Eye size={12} />
                                View Details
                              </button>
                            </div>
                          ))}
                        </div>
                      );
                    })()}
                  </InfoWindow>
                )}
                {currentLocation && (
                  <>
                    {/* Blue circle – your location */}
                    <Marker
                      position={currentLocation}
                      zIndex={1}
                      onClick={() => {
                        const groupHere = displayPublishers.find(
                          p =>
                            Math.abs(p.latitude - currentLocation.lat) < 0.0001 &&
                            Math.abs(p.longitude - currentLocation.lng) < 0.0001
                        );
                        if (groupHere) setSelectedLocation(groupHere);
                      }}
                      icon={{
                        path: (window.google && window.google.maps && window.google.maps.SymbolPath && window.google.maps.SymbolPath.FORWARD_CLOSED_ARROW) || undefined,
                        fillColor: '#3b82f6', // blue
                        fillOpacity: 1,
                        strokeColor: '#fff',
                        strokeWeight: 2,
                        scale: 6,
                      }}
                    />
                    {/* Green circle – overlay when an active publisher shares the same location */}
                    {displayPublishers.some(
                      p =>
                        Math.abs(p.latitude - currentLocation.lat) < 0.0001 &&
                        Math.abs(p.longitude - currentLocation.lng) < 0.0001 &&
                        getStatus(p) === 'active'
                    ) && (
                        <Marker
                          position={currentLocation}
                          zIndex={2}
                          icon={{
                            path: window.google?.maps?.SymbolPath?.CIRCLE,
                            fillColor: '#22c55e', // green
                            fillOpacity: 1,
                            strokeColor: '#fff',
                            strokeWeight: 2,
                            scale: 12,
                          }}
                        />
                      )}
                  </>
                )}
              </GoogleMap>
            </LoadScriptNext>
          </div>


          {/* Right Filter Panel */}
          <div className="w-52 flex-shrink-0 border-l border-gray-100 bg-white flex flex-col">
            <div className="px-4 pt-4 pb-3">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider mb-3">Filter by Status</p>
              <div className="flex flex-col gap-2">
                {filterConfig.map((f) => {
                  const count = f.key === 'all'
                    ? validPublishers.length
                    : validPublishers.filter((p) => getStatus(p) === f.key).length;
                  const isActive = filter === f.key;
                  return (
                    <button
                      key={f.key}
                      onClick={() => { setFilter(f.key); setSelectedLocation(null); }}
                      className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-all text-left ${isActive ? f.colorClass + ' shadow-sm' : 'bg-transparent border-transparent text-gray-500 hover:bg-gray-50'}`}
                    >
                      <span className={`w-2 h-2 rounded-full flex-shrink-0 ${f.dot} ${!isActive ? 'opacity-40' : ''}`} />
                      <span className="flex-1 truncate">{f.label}</span>
                      <span className={`text-xs font-semibold px-1.5 py-0.5 rounded-md ${isActive ? 'bg-white/50' : 'bg-gray-100 text-gray-400'}`}>{count}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Legend */}
            <div className="mt-auto px-4 pb-4 pt-3 border-t border-gray-100">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider mb-2.5">Legend</p>
              <div className="flex flex-col gap-2">
                {[
                  { label: 'Active Publisher', color: 'bg-green-500' },
                  { label: 'Inactive Publisher', color: 'bg-orange-500' },
                  { label: 'Suspended Publisher', color: 'bg-red-500' },
                  { label: 'Your Location', color: 'bg-blue-500' },
                ].map((l) => (
                  <div key={l.label} className="flex items-center gap-2">
                    <div className={`w-3 h-3 rounded-full ${l.color} flex-shrink-0`} />
                    <span className="text-xs text-gray-500">{l.label}</span>
                  </div>
                ))}
              </div>
              <p className="text-[10px] text-gray-400 mt-3 leading-relaxed">Click any pin to see publisher details</p>
            </div>
          </div> {/* Right Filter Panel */}
        </div> {/* Body */}
      </div> {/* Modal */}
    </div>,   // Root Portal Container
    document.body
  );
}

export default PublisherMapView;