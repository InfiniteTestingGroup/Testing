import { useEffect, useMemo, useState } from 'react';
import { createPortal } from 'react-dom';
import { X, MapPin, Eye } from 'lucide-react';
import { useJsApiLoader, GoogleMap, Marker, InfoWindow } from '@react-google-maps/api';
import type { Publisher } from '../../services/publishers';
import { useTheme } from '../../context/ThemeContext';

// Leaflet init removed – using Google Maps



const getStatus = (publisher: any) => {
  const status = String(publisher.status || "").toLowerCase();

  if (status === "suspended") return "suspended";
  if (status === "active") return "active";

  return "inactive";
};

// ── Filter config ─────────────────────────────────────────────────────────────
const filterConfig = [
  { key: 'all', label: 'All Publishers', dot: 'bg-gray-400', darkColor: 'bg-gray-800 text-white border-gray-700', lightColor: 'bg-gray-100 text-gray-700 border-gray-200' },
  { key: 'active', label: 'Active', dot: 'bg-green-500', darkColor: 'bg-gray-800 text-green-400 border-gray-700', lightColor: 'bg-green-50 text-green-700 border-green-200' },
  { key: 'inactive', label: 'Inactive', dot: 'bg-orange-500', darkColor: 'bg-gray-800 text-orange-400 border-gray-700', lightColor: 'bg-orange-50 text-orange-700 border-orange-200' },
  { key: 'suspended', label: 'Suspended', dot: 'bg-red-500', darkColor: 'bg-gray-800 text-red-400 border-gray-700', lightColor: 'bg-red-50 text-red-700 border-red-200' },
];

// ── Main PublisherMapView ─────────────────────────────────────────────────────
export function PublisherMapView({
  isOpen,
  onClose,
  publishers = [],
  onPublisherClick
}: {
  isOpen: boolean;
  onClose: () => void;
  publishers?: Publisher[];
  onPublisherClick?: (publisher: Publisher) => void;
}) {
  const [filter, setFilter] = useState<string>('all');
  const [selectedLocation, setSelectedLocation] = useState<any | null>(null);
  const [geocodedPublishers, setGeocodedPublishers] = useState<Publisher[]>([]);
  const [currentLocation, currentLocationSet] = useState<{ lat: number; lng: number } | null>(null);
  const [mapCenter, setMapCenter] = useState<{ lat: number; lng: number }>({ lat: 20.5937, lng: 78.9629 });
  const { theme } = useTheme();
  const isDark = theme === 'dark';

  const { isLoaded, loadError } = useJsApiLoader({
    id: 'google-map-script',
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY || '',
  });

  // Detect GPS on open
  useEffect(() => {
    if (!isOpen) return;
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (pos) => {
          const loc = { lat: pos.coords.latitude, lng: pos.coords.longitude };
          currentLocationSet(loc);
          setMapCenter(loc);
        },
        () => currentLocationSet({ lat: 20.5937, lng: 78.9629 }),
        { enableHighAccuracy: true, timeout: 6000 }
      );
    }
  }, [isOpen]);

  // Update map when location changes
  useEffect(() => {
    if (currentLocation) {
      setMapCenter(currentLocation);
    }
  }, [currentLocation]);

  // Parse location and extract latitude/longitude
  useEffect(() => {
    if (!isOpen) return;

    const results = publishers.map((pub) => {
      let latitude = pub.latitude;
      let longitude = pub.longitude;

      if ((latitude == null || longitude == null) && typeof pub.location === 'string') {
        const parts = pub.location.split(',');
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

    setGeocodedPublishers(results);
  }, [isOpen, publishers]);

  const mappablePublishers = useMemo(() => {
    return geocodedPublishers;
  }, [geocodedPublishers]);

  const filtered = useMemo(() => {
    if (filter === 'all') return mappablePublishers;
    return mappablePublishers.filter((p) => getStatus(p) === filter);
  }, [mappablePublishers, filter]);

  const locationGroups = useMemo(() => {
    const groups: Record<string, any> = {};
    filtered.forEach(p => {
      if (p.latitude != null && p.longitude != null) {
        const key = `${p.latitude},${p.longitude}`;
        if (!groups[key]) {
          groups[key] = {
            id: key,
            latitude: p.latitude,
            longitude: p.longitude,
            publishers: [],
            status: getStatus(p)
          };
        } else {
          if (getStatus(p) === 'active') {
            groups[key].status = 'active';
          } else if (groups[key].status !== 'active' && getStatus(p) === 'suspended') {
            groups[key].status = 'suspended';
          }
        }
        groups[key].publishers.push(p);
      }
    });
    return Object.values(groups);
  }, [filtered]);

  const isEmpty = mappablePublishers.length === 0;
  const defaultCenter = mapCenter;

  if (!isOpen) return null;

  return createPortal(
    <div className={`fixed inset-0 z-[9999] flex items-center justify-center p-4 md:p-6 backdrop-blur-sm ${isDark ? 'bg-black/60' : 'bg-black/40'}`}>
      {/* Backdrop */}
      <div className="absolute inset-0 animate-fade-in" onClick={onClose} />

      {/* Modal */}
      <div
        className={`relative rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-fade-in-scale border ${isDark ? 'bg-[#000] border-gray-700 text-white' : 'bg-white border-gray-200 text-gray-900'
          }`}
        style={{ width: '95vw', maxWidth: 1100, height: '90vh', maxHeight: 700 }}
      >
        {/* Header */}
        <div className={`flex items-center justify-between px-5 py-4 border-b flex-shrink-0 ${isDark ? 'border-gray-700 bg-black text-white' : 'border-gray-100 bg-white text-gray-900'
          }`}>
          <div className="flex items-center gap-3">
            <div className={`p-2 rounded-xl ${isDark ? 'bg-gray-800' : 'bg-orange-50'}`}>
              <MapPin className="w-5 h-5 text-orange-500" />
            </div>
            <div>
              <h2 className="text-base font-bold">Publisher Locations Map</h2>
              <p className={`text-xs mt-0.5 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                {isEmpty
                  ? 'No publisher data'
                  : `${filtered.length} of ${mappablePublishers.length} publisher${mappablePublishers.length !== 1 ? 's' : ''} shown`}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className={`p-2 rounded-xl transition-all ${isDark ? 'text-gray-400 hover:text-white hover:bg-gray-800' : 'text-gray-400 hover:text-gray-600 hover:bg-gray-100'
              }`}
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Body */}
        <div className="flex flex-1 min-h-0">
          {/* Map */}
          <div className="flex-1 relative">
            {!isLoaded && (
              <div className="absolute inset-0 flex flex-col items-center justify-center bg-transparent">
                <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Loading Google Maps…</p>
              </div>
            )}
            {loadError && (
              <div className="absolute inset-0 flex flex-col items-center justify-center bg-transparent">
                <p className="text-sm text-red-500 font-semibold">Google Maps failed to load</p>
              </div>
            )}
            {isLoaded && !loadError && (
              <GoogleMap
                mapContainerStyle={{ width: '100%', height: '100%' }}
                center={defaultCenter}
                zoom={5}
                options={{ mapTypeControl: false, streetViewControl: false, fullscreenControl: false }}
              >
                {/* Publisher markers */}
                {locationGroups.map((group) => (
                  <Marker
                    key={group.id}
                    position={{
                      lat: group.latitude,
                      lng: group.longitude,
                    }}
                    onClick={() => setSelectedLocation(group)}
                    icon={{
                      path: window.google?.maps?.SymbolPath?.CIRCLE,
                      fillColor:
                        group.status === 'active'
                          ? '#22c55e'
                          : group.status === 'suspended'
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
                  <InfoWindow
                    position={{
                      lat: selectedLocation.latitude,
                      lng: selectedLocation.longitude,
                    }}
                    onCloseClick={() => setSelectedLocation(null)}
                  >
                    <div className="p-3 max-h-[300px] overflow-y-auto w-64 custom-scrollbar text-black">
                      <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3 border-b border-gray-100 pb-2">
                        {selectedLocation.publishers.length} Publisher{selectedLocation.publishers.length !== 1 ? 's' : ''} Here
                      </p>
                      {selectedLocation.publishers.map((pub: any, idx: number) => (
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
                              <p className="text-[9px] text-gray-400 uppercase font-bold">Location</p>
                              <p className="text-[10px] font-semibold text-gray-700 truncate max-w-[100px]">{pub.location || 'N/A'}</p>
                            </div>
                          </div>

                          <button
                            onClick={() => {
                              setSelectedLocation(null);
                              onPublisherClick?.(pub);
                            }}
                            className="w-full py-1.5 bg-orange-50 hover:bg-orange-500 text-orange-600 hover:text-white rounded-lg text-xs font-bold transition-colors flex items-center justify-center gap-1"
                          >
                            <Eye size={12} />
                            View Details
                          </button>
                        </div>
                      ))}
                    </div>
                  </InfoWindow>
                )}

                {currentLocation && (
                  <Marker
                    position={currentLocation}
                    icon={{
                      path:
                        (window.google && window.google.maps && window.google.maps.SymbolPath && window.google.maps.SymbolPath.FORWARD_CLOSED_ARROW) || undefined,
                      fillColor: '#3b82f6',
                      fillOpacity: 1,
                      strokeColor: '#fff',
                      strokeWeight: 2,
                      scale: 6,
                    }}
                  />
                )}
              </GoogleMap>
            )}
          </div>

          {/* Right Filter Panel */}
          <div className={`w-52 flex-shrink-0 border-l flex flex-col ${isDark ? 'border-gray-700 bg-black text-white' : 'border-gray-100 bg-white text-gray-900'
            }`}>
            <div className="px-4 pt-4 pb-3">
              <p className={`text-[11px] font-semibold uppercase tracking-wider mb-3 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Filter by Status</p>
              <div className="flex flex-col gap-2">
                {filterConfig.map((f) => {
                  const count =
                    f.key === 'all'
                      ? mappablePublishers.length
                      : mappablePublishers.filter((p) => getStatus(p) === f.key).length;
                  const isActive = filter === f.key;

                  const btnClass = isActive
                    ? (isDark ? f.darkColor : f.lightColor)
                    : (isDark
                      ? 'bg-transparent border-transparent text-gray-400 hover:bg-gray-800'
                      : 'bg-transparent border-transparent text-gray-500 hover:bg-gray-50');

                  const badgeClass = isActive
                    ? (isDark ? 'bg-black/50 text-white' : 'bg-white/50 text-gray-700')
                    : (isDark ? 'bg-gray-800 text-gray-300' : 'bg-gray-100 text-gray-400');

                  return (
                    <button
                      key={f.key}
                      onClick={() => { setFilter(f.key); setSelectedLocation(null); }}
                      className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-all text-left ${btnClass}`}
                    >
                      <span className={`w-2 h-2 rounded-full flex-shrink-0 ${f.dot} ${!isActive ? 'opacity-40' : ''}`} />
                      <span className="flex-1 truncate">{f.label}</span>
                      <span className={`text-xs font-semibold px-1.5 py-0.5 rounded-md ${badgeClass}`}>{count}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Legend */}
            <div className={`mt-auto px-4 pb-4 pt-3 border-t ${isDark ? 'border-gray-700 bg-black' : 'border-gray-100 bg-white'}`}>
              <p className={`text-[11px] font-semibold uppercase tracking-wider mb-2.5 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Legend</p>
              <div className="flex flex-col gap-2">
                {[
                  { label: 'Active Publisher', color: 'bg-green-500' },
                  { label: 'Inactive Publisher', color: 'bg-orange-500' },
                  { label: 'Suspended Publisher', color: 'bg-red-500' },
                  { label: 'Your Location', color: 'bg-blue-500' },
                ].map((l) => (
                  <div key={l.label} className="flex items-center gap-2">
                    <div className={`w-3 h-3 rounded-full ${l.color} flex-shrink-0`} />
                    <span className={`text-xs ${isDark ? 'text-gray-300' : 'text-gray-500'}`}>{l.label}</span>
                  </div>
                ))}
              </div>
              <p className={`text-[10px] mt-3 leading-relaxed ${isDark ? 'text-gray-300' : 'text-gray-400'}`}>Click any pin to see publisher details</p>
            </div>
          </div>
        </div>
      </div>
    </div>,
    document.body
  );
}

export default PublisherMapView;
