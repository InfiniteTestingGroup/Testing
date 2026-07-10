import React, { useEffect, useMemo, useState } from 'react';
import { createPortal } from 'react-dom';
import { X, MapPin, Navigation, Loader2 } from 'lucide-react';

import { LoadScript, GoogleMap, Marker, InfoWindow } from '@react-google-maps/api';
import { fetchAdminDetail } from '../../lib/management';




// ── Nominatim geocoding (OpenStreetMap, free, no API key) ─────────────────────
async function geocodeAdmin(admin) {
    const cacheKey = `keliri_geo_admin_v2_${admin.id}`;
    try {
        const cached = sessionStorage.getItem(cacheKey);
        if (cached) {
            const { lat, lng } = JSON.parse(cached);
            return { lat, lng };
        }
    } catch { }

    // Build a meaningful query from available fields
    const parts = [admin.company, admin.name].filter(Boolean);
    const query = parts.join(', ') + ', India';

    try {
        const res = await fetch(
            `https://photon.komoot.io/api/?q=${encodeURIComponent(query)}&limit=1`
        );
        const data = await res.json();
        if (data && data.features && data.features.length > 0) {
            // Photon returns GeoJSON: coordinates are [lon, lat]
            const lon = data.features[0].geometry.coordinates[0];
            const lat = data.features[0].geometry.coordinates[1];
            sessionStorage.setItem(cacheKey, JSON.stringify({ lat, lng: lon }));
            return { lat, lng: lon };
        }
    } catch { }
    return null;
}

// Geocode an admin using their detail (city + state from registration)
async function geocodeAdminDetail(admin) {
    const cacheKey = `keliri_geo_admin_v2_${admin.id}`;
    try {
        const cached = sessionStorage.getItem(cacheKey);
        if (cached) return JSON.parse(cached);
    } catch { }

    try {
        const detail = await fetchAdminDetail(admin.id);
        const reg = detail?.registration;
        if (!reg) return geocodeAdmin(admin);

        const parts = [
            reg.businessAddress,
            reg.city,
            reg.state,
            reg.country || 'India',
        ].filter(Boolean);
        if (parts.length === 0) return geocodeAdmin(admin);

        const query = parts.join(', ');

        const res = await fetch(
            `https://photon.komoot.io/api/?q=${encodeURIComponent(query)}&limit=1`
        );
        const data = await res.json();
        if (data && data.features && data.features.length > 0) {
            // Photon returns GeoJSON: coordinates are [lon, lat]
            const lon = data.features[0].geometry.coordinates[0];
            const lat = data.features[0].geometry.coordinates[1];
            sessionStorage.setItem(cacheKey, JSON.stringify({ lat, lng: lon }));
            return { lat, lng: lon };
        }
    } catch { }
    return geocodeAdmin(admin);
}

// ── Custom SVG marker ─────────────────────────────────────────────────────────

const STATUS_COLORS = {
    Active: '#22c55e',
    Pending: '#eab308',
    Suspended: '#ef4444',
    Rejected: '#6b7280',
};

// ── Auto fit bounds ───────────────────────────────────────────────────────────
// Placeholder for future bounds fitting if needed
function BoundsController({ admins }) { return null; }

// ── Filter config ─────────────────────────────────────────────────────────────
const filterConfig = [
    { key: 'all', label: 'All Admins', colorClass: 'bg-gray-100 text-gray-700 border-gray-200', dot: 'bg-gray-500' },
    { key: 'active', label: 'Active', colorClass: 'bg-green-50 text-green-700 border-green-200', dot: 'bg-green-500' },
    { key: 'pending', label: 'Pending', colorClass: 'bg-yellow-50 text-yellow-700 border-yellow-200', dot: 'bg-yellow-400' },
    { key: 'suspended', label: 'Suspended', colorClass: 'bg-red-50 text-red-700 border-red-200', dot: 'bg-red-500' },
];

// ── Main AdminMapView ─────────────────────────────────────────────────────────
export function AdminMapView({ isOpen, onClose, admins = [], onAdminClick }) {
    console.log("Admins Data:", admins);


    const [filter, setFilter] = useState('all');
    const [selectedId, setSelectedId] = useState(null);
    const [currentLocation, setCurrentLocation] = useState(null);
    const [mapCenter, setMapCenter] = useState({ lat: 20.5937, lng: 78.9629 });
    const [geocodedAdmins, setGeocodedAdmins] = useState([]);
    const [isGeocoding, setIsGeocoding] = useState(false);
    const [geocodeProgress, setGeocodeProgress] = useState(0);
    const [zoomLevel, setZoomLevel] = useState(5);
    const [mapRef, setMapRef] = useState(null);


    // GPS fallback
    useEffect(() => {
        if (!isOpen) return;
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (pos) => {
                    const loc = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                    setCurrentLocation(loc);
                    setMapCenter(loc);
                },
                () => setMapCenter({ lat: 20.5937, lng: 78.9629 }),
                { enableHighAccuracy: true, timeout: 6000 }
            );
        }
    }, [isOpen]);

    // Reset on close
    useEffect(() => {
        if (!isOpen) {
            setFilter('all');
            setSelectedId(null);
        }
    }, [isOpen]);

    // Geocode all admins when map opens
    useEffect(() => {
        if (!isOpen || admins.length === 0) return;

        const runGeocoding = async () => {
            setIsGeocoding(true);
            setGeocodeProgress(0);
            const results = [];

            for (let i = 0; i < admins.length; i++) {
                const admin = admins[i];

                // Already has lat/lng
                if (admin.latitude && admin.longitude) {
                    results.push({ ...admin, lat: parseFloat(admin.latitude), lng: parseFloat(admin.longitude) });
                    setGeocodeProgress(Math.round(((i + 1) / admins.length) * 100));
                    continue;
                }

                // Geocode
                try {
                    const coords = await geocodeAdminDetail(admin);
                    if (coords) {
                        results.push({ ...admin, lat: coords.lat, lng: coords.lng });
                    } else {
                        // Fallback for admins with dummy/invalid addresses
                        const hash = admin.id ? admin.id.split('').reduce((a, b) => { a = ((a << 5) - a) + b.charCodeAt(0); return a & a }, 0) : Math.random();
                        const jitterLat = (Math.abs(hash) % 100) / 1000 - 0.05;
                        const jitterLng = (Math.abs(hash >> 8) % 100) / 1000 - 0.05;
                        results.push({ ...admin, lat: 20.5937 + jitterLat, lng: 78.9629 + jitterLng, _isFallback: true });
                    }
                } catch {
                    const hash = admin.id ? admin.id.split('').reduce((a, b) => { a = ((a << 5) - a) + b.charCodeAt(0); return a & a }, 0) : Math.random();
                    const jitterLat = (Math.abs(hash) % 100) / 1000 - 0.05;
                    const jitterLng = (Math.abs(hash >> 8) % 100) / 1000 - 0.05;
                    results.push({ ...admin, lat: 20.5937 + jitterLat, lng: 78.9629 + jitterLng, _isFallback: true });
                }

                setGeocodeProgress(Math.round(((i + 1) / admins.length) * 100));
                setGeocodedAdmins([...results]);

                // Photon has no strict rate limit, but we'll add a tiny delay to be polite
                if (i < admins.length - 1) {
                    await new Promise((r) => setTimeout(r, 200));
                }
            }

            setIsGeocoding(false);
            console.log('Final geocodedAdmins:', geocodedAdmins);
        };

        runGeocoding();
    }, [isOpen, admins]);

    const validAdmins = useMemo(
        () => geocodedAdmins.filter((a) => a.lat && a.lng && !isNaN(a.lat) && !isNaN(a.lng)),
        [geocodedAdmins]
    );

    const filtered = useMemo(() => {
        if (filter === 'all') return validAdmins;
        return validAdmins.filter((a) => a.status?.toLowerCase() === filter);
    }, [validAdmins, filter]);

    const displayAdmins = useMemo(() => {
        const groups = {};
        filtered.forEach(a => {
            const key = `${a.lat},${a.lng}`;
            if (!groups[key]) groups[key] = [];
            groups[key].push(a);
        });

        const result = [];
        Object.values(groups).forEach(group => {
            if (group.length === 1) {
                result.push({ ...group[0], originalLat: group[0].lat, originalLng: group[0].lng, isGroup: false });
            } else if (zoomLevel < 12) {
                const representative = group.find(a => a.status === 'Active') || group[0];
                result.push({
                    ...representative,
                    id: `group-${group[0].lat}-${group[0].lng}`,
                    originalLat: group[0].lat,
                    originalLng: group[0].lng,
                    isGroup: true,
                    groupedAdmins: group,
                    lat: group[0].lat,
                    lng: group[0].lng
                });
            } else {
                const radius = 0.0003;
                group.forEach((a, index) => {
                    const angle = (2 * Math.PI * index) / group.length;
                    result.push({
                        ...a,
                        originalLat: a.lat,
                        originalLng: a.lng,
                        lat: a.lat + radius * Math.cos(angle),
                        lng: a.lng + radius * Math.sin(angle),
                        isGroup: false
                    });
                });
            }
        });
        return result;
    }, [filtered, zoomLevel]);

    const isEmpty = validAdmins.length === 0;
    const defaultCenter = mapCenter;

    if (!isOpen) return null;

    return createPortal(
        <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 md:p-6">
            {/* Backdrop */}
            <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} />

            {/* Modal */}
            <div
                className="relative bg-white rounded-2xl shadow-2xl flex flex-col overflow-hidden border border-gray-200"
                style={{ width: '95vw', maxWidth: 1100, height: '90vh', maxHeight: 700 }}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 bg-white flex-shrink-0">
                    <div className="flex items-center gap-3">
                        <div className="p-2 bg-orange-50 rounded-xl">
                            <MapPin className="w-5 h-5 text-orange-500" />
                        </div>
                        <div>
                            <h2 className="text-base font-bold text-gray-900">Admin Locations Map</h2>
                            <p className="text-xs text-gray-400 mt-0.5">
                                {isGeocoding
                                    ? `Locating admins… ${geocodeProgress}%`
                                    : isEmpty
                                        ? 'No location data found'
                                        : `${filtered.length} of ${validAdmins.length} admin${validAdmins.length !== 1 ? 's' : ''} shown`}
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
                    {/* Map area */}
                    <div className="flex-1 relative">
                        {/* Geocoding overlay */}
                        {isGeocoding && (
                            <div className="absolute top-4 left-1/2 -translate-x-1/2 z-[1000]">
                                <div className="flex items-center gap-2.5 bg-white/95 backdrop-blur-sm px-4 py-2.5 rounded-xl shadow-lg border border-gray-200">
                                    <Loader2 className="w-4 h-4 text-orange-500 animate-spin flex-shrink-0" />
                                    <p className="text-xs font-medium text-gray-700 whitespace-nowrap">
                                        Locating admins on map… {geocodeProgress}%
                                    </p>
                                </div>
                            </div>
                        )}

                        {/* Empty state after geocoding */}
                        {!isGeocoding && isEmpty && (
                            <div className="absolute top-4 left-1/2 -translate-x-1/2 z-[1000] pointer-events-none">
                                <div className="flex items-center gap-2.5 bg-white/95 backdrop-blur-sm px-4 py-2.5 rounded-xl shadow-lg border border-gray-200">
                                    <Navigation className="w-4 h-4 text-blue-500 flex-shrink-0" />
                                    <p className="text-xs font-medium text-gray-700 whitespace-nowrap">
                                        No geocodable locations — showing your current position
                                    </p>
                                </div>
                            </div>
                        )}

                        <LoadScript googleMapsApiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY || ""}>
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
                                                setSelectedId(null);
                                            }
                                            return newZoom;
                                        });
                                    }
                                }}
                            >
                                {displayAdmins.map((admin) => (
                                    <Marker
                                        key={admin.id}
                                        position={{ lat: admin.lat, lng: admin.lng }}
                                        onClick={() => setSelectedId(admin.id)}
                                        icon={{
                                            path: 0, // window.google.maps.SymbolPath.CIRCLE
                                            fillColor: STATUS_COLORS[admin.status] || '#6b7280',
                                            fillOpacity: 1,
                                            strokeColor: '#fff',
                                            strokeWeight: 2,
                                            scale: 8,
                                        }}
                                    />
                                ))}
                                {selectedId && (
                                    <InfoWindow
                                        position={{
                                            lat: displayAdmins.find(a => a.id === selectedId)?.lat || 0,
                                            lng: displayAdmins.find(a => a.id === selectedId)?.lng || 0
                                        }}
                                        onCloseClick={() => setSelectedId(null)}
                                    >
                                        {(() => {
                                            const selectedAdmin = displayAdmins.find(a => a.id === selectedId);
                                            if (!selectedAdmin) return null;

                                            const adminsAtLocation = selectedAdmin.isGroup ? selectedAdmin.groupedAdmins : [selectedAdmin];

                                            return (
                                                <div className="w-64 p-1 max-h-[60vh] overflow-y-auto pr-1">
                                                    {adminsAtLocation.length > 1 && (
                                                        <div className="bg-orange-50 text-orange-700 text-xs font-semibold px-2 py-1.5 rounded-lg mb-3 border border-orange-100">
                                                            {adminsAtLocation.length} Admins at this location
                                                        </div>
                                                    )}
                                                    <div className="flex flex-col gap-4">
                                                        {adminsAtLocation.map((admin, idx) => (
                                                            <div key={admin.id} className={idx < adminsAtLocation.length - 1 ? "border-b border-gray-200 pb-4" : ""}>
                                                                <div className="border-b pb-3 mb-3">
                                                                    <h3 className="text-base font-semibold text-gray-900">
                                                                        {admin?.name}
                                                                    </h3>

                                                                    <p className="text-sm text-gray-500">
                                                                        {admin?.company}
                                                                    </p>
                                                                </div>

                                                                <div className="space-y-2 text-sm">
                                                                    <div className="flex justify-between items-center">
                                                                        <span className="text-gray-500">Status</span>
                                                                        <span
                                                                            className={`px-2 py-1 rounded-full text-xs font-medium ${admin?.status === "Active"
                                                                                ? "bg-green-100 text-green-700"
                                                                                : admin?.status === "Pending"
                                                                                    ? "bg-yellow-100 text-yellow-700"
                                                                                    : "bg-red-100 text-red-700"
                                                                                }`}
                                                                        >
                                                                            {admin?.status}
                                                                        </span>
                                                                    </div>

                                                                    <div>
                                                                        <p className="text-gray-500 text-xs">Email</p>
                                                                        <p className="font-medium break-all">
                                                                            {admin?.email || "N/A"}
                                                                        </p>
                                                                    </div>

                                                                    <div>
                                                                        <p className="text-gray-500 text-xs">Registered</p>
                                                                        <p className="font-medium">
                                                                            {admin?.registeredDate || "N/A"}
                                                                        </p>
                                                                    </div>
                                                                </div>

                                                                <button
                                                                    className="w-full mt-4 bg-orange-500 hover:bg-orange-600 text-white text-sm font-medium py-2 rounded-lg transition"
                                                                    onClick={() => {
                                                                        if (onAdminClick) {
                                                                            fetchAdminDetail(admin.id)
                                                                                .then((detail) => onAdminClick(detail))
                                                                                .catch((err) => {
                                                                                    console.error('Failed to fetch admin detail for modal', err);
                                                                                    // Fallback to summary admin data
                                                                                    onAdminClick(admin);
                                                                                });
                                                                        }
                                                                    }}
                                                                >
                                                                    View Admin Details
                                                                </button>
                                                            </div>
                                                        ))}
                                                    </div>
                                                </div>
                                            );
                                        })()}
                                    </InfoWindow>
                                )}
                                {currentLocation && (
                                    <>
                                        {/* Green circle – shown only if an active admin is at the same location */}
                                        {currentLocation && (
                                            <Marker
                                                position={currentLocation}
                                                zIndex={20}
                                                icon={{
                                                    url:
                                                        "data:image/svg+xml;charset=UTF-8," +
                                                        encodeURIComponent(`
        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40">
          <path
            d="M20 2 L33 32 L20 24 L7 32 Z"
            fill="#4285F4"
            stroke="white"
            stroke-width="2"
          />
        </svg>
      `),
                                                    scaledSize: new window.google.maps.Size(40, 40),
                                                    anchor: new window.google.maps.Point(20, 20),
                                                }}
                                            />
                                        )}
                                    </>
                                )}</GoogleMap>
                        </LoadScript>
                    </div>

                    {/* Right Panel */}
                    <div className="w-52 flex-shrink-0 border-l border-gray-100 bg-white flex flex-col">
                        <div className="px-4 pt-4 pb-3">
                            <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider mb-3">
                                Filter by Status
                            </p>
                            <div className="flex flex-col gap-2">
                                {filterConfig.map((f) => {
                                    const count =
                                        f.key === 'all'
                                            ? validAdmins.length
                                            : validAdmins.filter((a) => a.status?.toLowerCase() === f.key).length;
                                    const isActive = filter === f.key;
                                    return (
                                        <button
                                            key={f.key}
                                            onClick={() => { setFilter(f.key); setSelectedId(null); }}
                                            className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-all text-left ${isActive ? f.colorClass + ' shadow-sm' : 'bg-transparent border-transparent text-gray-500 hover:bg-gray-50'
                                                }`}
                                        >
                                            <span className={`w-2 h-2 rounded-full flex-shrink-0 ${f.dot} ${!isActive ? 'opacity-40' : ''}`} />
                                            <span className="flex-1 truncate">{f.label}</span>
                                            <span className={`text-xs font-semibold px-1.5 py-0.5 rounded-md ${isActive ? 'bg-white/50' : 'bg-gray-100 text-gray-400'
                                                }`}>
                                                {isGeocoding ? '…' : count}
                                            </span>
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
                                    { label: 'Active Admin', color: 'bg-green-500' },
                                    { label: 'Pending Admin', color: 'bg-yellow-400' },
                                    { label: 'Suspended Admin', color: 'bg-red-500' },
                                    { label: 'Your Location', color: 'bg-blue-500' },
                                ].map((l) => (
                                    <div key={l.label} className="flex items-center gap-2">
                                        <div className={`w-3 h-3 rounded-full ${l.color} flex-shrink-0`} />
                                        <span className="text-xs text-gray-500">{l.label}</span>
                                    </div>
                                ))}
                            </div>
                            <p className="text-[10px] text-gray-400 mt-3 leading-relaxed">
                                Locations resolved via OpenStreetMap geocoding
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>,
        document.body
    );
}

export default AdminMapView;