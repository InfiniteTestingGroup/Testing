import { lazy, Suspense, useEffect, useState, useCallback, useMemo, useRef } from 'react'
import { createPortal } from 'react-dom'
import { Download, DollarSign, Activity, CreditCard, MapPin, X, Loader2, Map } from 'lucide-react'
import KpiCard from '../components/dashboard/KpiCard'
import { fetchRevenueAnalytics } from '../lib/analytics'
import { fetchAllTransactions } from '../lib/transactions'
import { fetchAdmins, fetchAdminDetail } from '../lib/management'
import {
  GoogleMap,
  useJsApiLoader,
  Marker,
  InfoWindow,
} from '@react-google-maps/api'

const GOOGLE_MAPS_API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY || ''
const GMAPS_LIBRARIES: any = ['geocoding']

async function geocodeAdmin(admin: any) {
  const cacheKey = `keliri_geo_admin_v2_${admin.id}`;
  try {
    const cached = sessionStorage.getItem(cacheKey);
    if (cached) {
      const { lat, lng } = JSON.parse(cached);
      return { lat, lng };
    }
  } catch { }

  const parts = [admin.company, admin.name].filter(Boolean);
  const query = parts.join(', ') + ', India';

  try {
    const res = await fetch(
      `https://photon.komoot.io/api/?q=${encodeURIComponent(query)}&limit=1`
    );
    const data = await res.json();
    if (data && data.features && data.features.length > 0) {
      const lon = data.features[0].geometry.coordinates[0];
      const lat = data.features[0].geometry.coordinates[1];
      sessionStorage.setItem(cacheKey, JSON.stringify({ lat, lng: lon }));
      return { lat, lng: lon };
    }
  } catch { }
  return null;
}

async function geocodeAdminDetail(admin: any) {
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
      const lon = data.features[0].geometry.coordinates[0];
      const lat = data.features[0].geometry.coordinates[1];
      sessionStorage.setItem(cacheKey, JSON.stringify({ lat, lng: lon }));
      return { lat, lng: lon };
    }
  } catch { }
  return null;
}

const MAP_STYLES = [
  { featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }] },
  { featureType: 'transit', stylers: [{ visibility: 'off' }] },
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#f5f5f5' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#c9e8f9' }] },
  { featureType: 'landscape', elementType: 'geometry', stylers: [{ color: '#f9f9f9' }] },
]

const COLORS = ['#FF6B00', '#3B82F6', '#8B5CF6', '#10B981', '#F59E0B', '#EF4444']

// ── Lazy-load the heavy chart component ──────────────────────────────────────
const RevenueDistributionChart = lazy(
  () => import('../components/revenue/RevenueDistributionChart')
)

// ── Static color map — avoids runtime string manipulation on every render ────
const COLOR_MAP: Record<string, string> = {
  'blue-500': '#3B82F6',
  'green-500': '#10B981',
  'purple-500': '#8B5CF6',
  'orange-500': '#FF6B00',
  'red-500': '#EF4444',
  'yellow-500': '#F59E0B',
  'pink-500': '#EC4899',
  'indigo-500': '#6366F1',
}

function resolveColor(bgClass: string): string {
  const key = bgClass.replace('bg-', '')
  return COLOR_MAP[key] ?? '#6B7280'
}

function makeDotIcon(color: string, label: string, isSelected = false) {
  const size = isSelected ? 38 : 30
  const fontSize = isSelected ? 12 : 10
  const hasLabel = label !== undefined && label !== null && label !== ''

  const svg = hasLabel
    ? `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size + 8}" viewBox="0 0 24 32">
        <circle cx="12" cy="12" r="10" fill="${color}" stroke="white" stroke-width="${isSelected ? 3 : 2}"/>
        <text x="12" y="16" text-anchor="middle" font-family="Inter, Arial, sans-serif" font-size="${fontSize}" font-weight="900" fill="white">${label}</text>
        <polygon points="12,32 8,22 16,22" fill="${color}"/>
      </svg>`
    : `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
        <circle cx="${size / 2}" cy="${size / 2}" r="${size / 2 - 2}" fill="${color}" stroke="#FFFFFF" stroke-width="2"/>
      </svg>`

  return {
    url: `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`,
    scaledSize: { width: size, height: hasLabel ? size + 8 : size },
    anchor: { x: size / 2, y: hasLabel ? size + 8 : size / 2 },
  }
}

// ── Skeleton shown while data loads — better perceived performance ────────────
function RevenueSkeleton() {
  return (
    <div className="space-y-6 pb-6 max-w-[1400px] mx-auto animate-pulse">
      {/* Header skeleton */}
      <div className="flex items-center justify-between pt-1">
        <div className="space-y-2">
          <div className="h-7 w-52 bg-gray-200 rounded-lg" />
          <div className="h-4 w-72 bg-gray-100 rounded" />
        </div>
        <div className="h-8 w-28 bg-gray-100 rounded-xl" />
      </div>

      {/* KPI cards skeleton */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
        {[1, 2, 3].map((i) => (
          <div key={i} className="h-28 bg-gray-100 rounded-2xl" />
        ))}
      </div>

      {/* Chart skeleton */}
      <div className="h-80 bg-gray-100 rounded-2xl" />
    </div>
  )
}

// ── Chart fallback while the lazy chunk loads ────────────────────────────────
function ChartSkeleton() {
  return (
    <div className="h-80 bg-gray-50 rounded-2xl animate-pulse flex items-center justify-center">
      <span className="text-xs text-gray-400 font-medium">Loading chart…</span>
    </div>
  )
}

// ── Transaction Map Modal ─────────────────────────────────────────────────────
function getMarkerColor(txList: any[]) {
  if (txList.some(tx => tx.status === 'Pending' || tx.status === 'PENDING')) return '#f59e0b'; // Amber
  if (txList.some(tx => tx.status === 'Completed' || tx.status === 'SUCCESS')) return '#10b981'; // Green
  return '#ef4444'; // Red
}

const filterConfig = [
  { key: 'all', label: 'All Transactions', colorClass: 'bg-gray-100 text-gray-700 border-gray-200', dot: 'bg-gray-500' },
  { key: 'Completed', label: 'Completed', colorClass: 'bg-green-50 text-green-700 border-green-200', dot: 'bg-green-500' },
  { key: 'Pending', label: 'Pending', colorClass: 'bg-amber-50 text-amber-700 border-amber-200', dot: 'bg-amber-500' },
  { key: 'Failed', label: 'Failed', colorClass: 'bg-red-50 text-red-700 border-red-200', dot: 'bg-red-500' },
];

function TransactionMapModal({
  open,
  onClose,
  allTransactions,
  geocodedAdmins,
}: {
  open: boolean
  onClose: () => void
  allTransactions: any[]
  geocodedAdmins: any[]
}) {
  const { isLoaded, loadError } = useJsApiLoader({
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: GMAPS_LIBRARIES,
  })

  const mapRef = useRef<any>(null)
  const [openInfoKey, setOpenInfoKey] = useState<string | null>(null)
  const [filter, setFilter] = useState<'all' | 'Completed' | 'Pending' | 'Failed'>('all')

  // Reset selected key and filter on close/open
  useEffect(() => {
    if (!open) {
      setOpenInfoKey(null)
      setFilter('all')
    }
  }, [open])

  // Phase 1: Filter all transactions to keep only plottable ones (valid lat/lng)
  const plottableTransactions = useMemo(() => {
    return allTransactions.filter((t: any) => {
      let lat = t.latitude ? Number(t.latitude) : null
      let lng = t.longitude ? Number(t.longitude) : null

      if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
        const adminObj = geocodedAdmins.find((a: any) => a.id === t.adminId || a.name === t.admin)
        if (adminObj && adminObj.lat && adminObj.lng) {
          lat = Number(adminObj.lat)
          lng = Number(adminObj.lng)
        }
      }
      return lat && lng && lat !== 0 && lng !== 0;
    });
  }, [allTransactions, geocodedAdmins]);

  // Phase 2: Apply status filter to plottable transactions
  const filteredTransactions = useMemo(() => {
    if (filter === 'all') return plottableTransactions;
    return plottableTransactions.filter((t: any) => t.status === filter);
  }, [plottableTransactions, filter]);

  // Phase 3: Group filtered transactions by admin/location for mapping
  const transactionLocations = useMemo(() => {
    const grouped: Record<string, any> = {}
    filteredTransactions.forEach((t: any) => {
      let lat = t.latitude ? Number(t.latitude) : null
      let lng = t.longitude ? Number(t.longitude) : null

      if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
        const adminObj = geocodedAdmins.find((a: any) => a.id === t.adminId || a.name === t.admin)
        if (adminObj && adminObj.lat && adminObj.lng) {
          lat = Number(adminObj.lat)
          lng = Number(adminObj.lng)
        }
      }

      if (lat && lng && lat !== 0 && lng !== 0) {
        const key = t.adminId || `${lat.toFixed(4)},${lng.toFixed(4)}`
        if (!grouped[key]) {
          grouped[key] = {
            city: t.admin,
            adminId: t.adminId,
            latitude: lat,
            longitude: lng,
            transactions: 0,
            txList: [],
          }
        }
        grouped[key].transactions += 1
        grouped[key].txList.push({
          id: t.id,
          status: t.status,
          amount: t.amount,
          date: t.date,
          reference: t.type,
        })
      }
    })
    return Object.values(grouped)
  }, [filteredTransactions, geocodedAdmins])

  if (!open) return null

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
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 bg-white flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-indigo-50 rounded-xl">
              <MapPin className="w-5 h-5 text-indigo-500" />
            </div>
            <div>
              <h2 className="text-base font-bold text-gray-900">Transaction Locations Map</h2>
              <p className="text-xs text-gray-400 mt-0.5">
                Showing {filteredTransactions.length} of {plottableTransactions.length} plottable transaction(s) across {transactionLocations.length} locations
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
          {/* Center — Map */}
          <div className="flex-1 relative flex flex-col animate-fade-in">
            <div className="flex-1 relative">
              {loadError && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-50">
                  <p className="text-sm text-red-500 font-medium">Failed to load Google Maps.</p>
                </div>
              )}

              {isLoaded && !loadError && (
                <GoogleMap
                  mapContainerStyle={{ width: '100%', height: '100%' }}
                  center={{ lat: 20.5937, lng: 78.9629 }}
                  zoom={5}
                  options={{
                    styles: MAP_STYLES,
                    disableDefaultUI: false,
                    mapTypeControl: false,
                    streetViewControl: false,
                    fullscreenControl: false,
                  }}
                  onLoad={(map) => { mapRef.current = map }}
                >
                  {transactionLocations.map((row: any) => {
                    const color = getMarkerColor(row.txList)
                    const key = `${row.city}-${row.latitude}-${row.longitude}`
                    const isSelected = openInfoKey === key
                    const label = row.transactions > 999 ? '999+' : String(row.transactions)

                    return (
                      <div key={key}>
                        <Marker
                          position={{ lat: row.latitude, lng: row.longitude }}
                          icon={makeDotIcon(color, label, isSelected)}
                          onClick={() => setOpenInfoKey(isSelected ? null : key)}
                        />
                        {isSelected && (
                          <InfoWindow
                            position={{ lat: row.latitude, lng: row.longitude }}
                            onCloseClick={() => setOpenInfoKey(null)}
                          >
                            <div style={{ fontFamily: 'Inter, system-ui, sans-serif', minWidth: 200, maxWidth: 280 }}>
                              <p style={{ margin: 0, fontWeight: 800, color: '#111827', fontSize: '13px' }}>
                                {row.city}
                              </p>
                              <div style={{ marginTop: '6px', maxHeight: '150px', overflowY: 'auto', paddingRight: '4px' }}>
                                <p style={{ margin: '0 0 4px 0', fontSize: '11px', fontWeight: 'bold', color: '#374151' }}>
                                  Transactions ({row.txList ? row.txList.length : 0}):
                                </p>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                                  {row.txList && row.txList.map((tx: any, idx: number) => (
                                    <div key={`${tx.id}-${idx}`} style={{ borderBottom: '1px solid #f3f4f6', paddingBottom: '4px', marginBottom: '2px' }}>
                                      <p style={{ margin: 0, fontSize: '10px', fontWeight: 'bold', color: '#111827' }}>
                                        {tx.id} - <span style={{ color: tx.status === 'Completed' || tx.status === 'SUCCESS' ? '#10B981' : tx.status === 'Pending' || tx.status === 'PENDING' ? '#F59E0B' : '#EF4444' }}>{tx.status}</span>
                                      </p>
                                      <p style={{ margin: '1px 0 0 0', fontSize: '9px', color: '#6b7280' }}>
                                        ₹{tx.amount} | {tx.date}
                                      </p>
                                    </div>
                                  ))}
                                </div>
                              </div>
                              <p style={{ margin: '4px 0 0', fontSize: '9px', color: '#9ca3af', fontFamily: 'monospace' }}>
                                {row.latitude.toFixed(4)}, {row.longitude.toFixed(4)}
                              </p>
                            </div>
                          </InfoWindow>
                        )}
                      </div>
                    )
                  })}
                </GoogleMap>
              )}

              {!isLoaded && !loadError && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-50">
                  <Loader2 className="w-6 h-6 text-primary-400 animate-spin" />
                </div>
              )}

              {transactionLocations.length === 0 && (
                <div className="absolute inset-0 flex items-center justify-center p-6 text-center">
                  <div className="bg-white border border-orange-100 rounded-2xl shadow-card px-6 py-5 max-w-md">
                    <p className="text-sm font-bold text-gray-900">No transaction locations available.</p>
                    <p className="text-xs text-gray-500 mt-2">Transactions need lat/lng data to appear on the map.</p>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Right Filter Panel */}
          <div className="w-52 flex-shrink-0 border-l border-gray-100 bg-white flex flex-col">
            <div className="px-4 pt-4 pb-3">
              <p className="text-[11px] font-semibold text-gray-400 uppercase tracking-wider mb-3">Filter by Status</p>
              <div className="flex flex-col gap-2">
                {filterConfig.map((f) => {
                  const count = f.key === 'all'
                    ? plottableTransactions.length
                    : plottableTransactions.filter((t: any) => t.status === f.key).length;
                  const isActive = filter === f.key;
                  return (
                    <button
                      key={f.key}
                      onClick={() => { setFilter(f.key as any); setOpenInfoKey(null); }}
                      className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-all text-left ${isActive ? f.colorClass + ' shadow-sm font-bold' : 'bg-transparent border-transparent text-gray-500 hover:bg-gray-50'
                        }`}
                    >
                      <span className={`w-2 h-2 rounded-full flex-shrink-0 ${f.dot} ${!isActive ? 'opacity-40' : ''}`} />
                      <span className="flex-1 truncate">{f.label}</span>
                      <span className={`text-xs font-semibold px-1.5 py-0.5 rounded-md ${isActive ? 'bg-white/50' : 'bg-gray-100 text-gray-400'}`}>
                        {count}
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
                  { label: 'Completed', color: 'bg-green-500' },
                  { label: 'Pending', color: 'bg-amber-500' },
                  { label: 'Failed', color: 'bg-red-500' },
                ].map((l) => (
                  <div key={l.label} className="flex items-center gap-2">
                    <div className={`w-3 h-3 rounded-full ${l.color} flex-shrink-0`} />
                    <span className="text-xs text-gray-500">{l.label}</span>
                  </div>
                ))}
              </div>
              <p className="text-[10px] text-gray-400 mt-3 leading-relaxed">Click any pin to see transaction details</p>
            </div>
          </div>
        </div>
      </div>
    </div>,
    document.body
  )
}


// ── Main page ─────────────────────────────────────────────────────────────────
export default function Revenue() {
  const [loading, setLoading] = useState(true)
  const [data, setData] = useState<any>(null)
  const [error, setError] = useState<string | null>(null)
  const [showMap, setShowMap] = useState(false)
  const [allTransactions, setAllTransactions] = useState<any[]>([])
  const [admins, setAdmins] = useState<any[]>([])
  const [geocodedAdmins, setGeocodedAdmins] = useState<any[]>([])

  useEffect(() => {
    let cancelled = false

    async function load() {
      try {
        const [result, txns, adminsList] = await Promise.all([
          fetchRevenueAnalytics(),
          fetchAllTransactions().catch(() => []),
          fetchAdmins().catch(() => []),
        ])
        if (!cancelled) {
          setData(result)
          setAllTransactions(txns)
          setAdmins(adminsList)
        }
      } catch (err) {
        console.error('Failed to load revenue analytics', err)
        if (!cancelled) setError('Failed to load revenue data. Please try again.')
      } finally {
        if (!cancelled) setLoading(false)
      }
    }

    load()
    return () => { cancelled = true } // cleanup if component unmounts early
  }, [])

  useEffect(() => {
    if (admins.length === 0) return;

    let cancelled = false;

    const runGeocoding = async () => {
      const results: any[] = [];

      for (let i = 0; i < admins.length; i++) {
        if (cancelled) return;
        const admin = admins[i];

        // Already has lat/lng
        if (admin.latitude && admin.longitude && Number(admin.latitude) !== 0 && Number(admin.longitude) !== 0) {
          results.push({ ...admin, lat: parseFloat(admin.latitude), lng: parseFloat(admin.longitude) });
          setGeocodedAdmins([...results]);
          continue;
        }

        // Geocode
        try {
          const coords = await geocodeAdminDetail(admin);
          if (coords) {
            results.push({ ...admin, lat: coords.lat, lng: coords.lng });
          } else {
            const hash = admin.id ? admin.id.split('').reduce((a: number, b: string) => { a = ((a << 5) - a) + b.charCodeAt(0); return a & a }, 0) : Math.random();
            const jitterLat = (Math.abs(hash) % 100) / 1000 - 0.05;
            const jitterLng = (Math.abs(hash >> 8) % 100) / 1000 - 0.05;
            results.push({ ...admin, lat: 20.5937 + jitterLat, lng: 78.9629 + jitterLng, _isFallback: true });
          }
        } catch {
          const hash = admin.id ? admin.id.split('').reduce((a: number, b: string) => { a = ((a << 5) - a) + b.charCodeAt(0); return a & a }, 0) : Math.random();
          const jitterLat = (Math.abs(hash) % 100) / 1000 - 0.05;
          const jitterLng = (Math.abs(hash >> 8) % 100) / 1000 - 0.05;
          results.push({ ...admin, lat: 20.5937 + jitterLat, lng: 78.9629 + jitterLng, _isFallback: true });
        }

        if (!cancelled) {
          setGeocodedAdmins([...results]);
        }

        if (i < admins.length - 1) {
          await new Promise((r) => setTimeout(r, 200));
        }
      }
    };

    runGeocoding();

    return () => {
      cancelled = true;
    };
  }, [admins]);



  // ── Memoised date string so it doesn't recalculate on every render ──────────
  const today = new Date().toLocaleDateString('en-IN', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })

  // ── CSV export ───────────────────────────────────────────────────────────────
  const exportRevenueCSV = useCallback(() => {
    if (!data) return

    const rows: (string | number)[][] = [
      ['Metric', 'Value'],
      ['Total Revenue', data.totalRevenue ?? 0],
      ['Avg Revenue Per Ad', data.avgRevenuePerAd ?? 0],
      ['Total Transactions', data.totalTransactions ?? 0],
      [],
      ['Ad Type', 'Revenue'],
      ...(data.breakdown?.map((item: any) => [item.category, item.amount]) ?? []),
    ]

    const csvContent = rows.map((row) => row.join(',')).join('\n')
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `revenue-report-${new Date().toISOString().split('T')[0]}.csv`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    URL.revokeObjectURL(url) // free memory immediately after download
  }, [data])

  // ── Derive chart data once, not inside JSX ──────────────────────────────────
  const chartData = data?.breakdown?.map((b: any) => ({
    name: b.category,
    value: b.amount,
    color: resolveColor(b.color),
  })) ?? []

  // ── States ───────────────────────────────────────────────────────────────────
  if (error) {
    return (
      <div className="space-y-6 pb-6 max-w-[1400px] mx-auto">
        <div className="flex items-center justify-between pt-1">
          <div>
            <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
              Revenue Management
            </h1>
            <p className="text-sm text-gray-500 mt-0.5">
              Financial analytics and payouts · {today}
            </p>
          </div>
          <button
            disabled
            className="flex items-center gap-2 bg-primary-50 border border-primary-100 text-primary-600 px-3 py-1.5 rounded-xl text-xs font-semibold shadow-sm opacity-50 cursor-not-allowed"
          >
            <Download size={14} />
            Export CSV
          </button>
        </div>
        <div className="flex flex-col items-center justify-center min-h-[400px] gap-3">
          <p className="text-sm text-red-500 font-medium">{error}</p>
          <button
            onClick={() => { setError(null); setLoading(true) }}
            className="text-xs text-primary-600 underline"
          >
            Retry
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6 pb-6 max-w-[1400px] mx-auto">

      {/* ── Page Header ──────────────────────────────────────────────────────── */}
      <div className="flex items-center justify-between pt-1">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
            Revenue Management
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">
            Financial analytics and payouts · {today}
          </p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowMap(true)}
            className="px-5 py-2.5 bg-white hover:bg-gray-50 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold shadow-sm active:scale-95 transition-all flex items-center gap-2 disabled:opacity-50"
          >
            <Map size={16} />
            Map View
          </button>

          <button
            onClick={exportRevenueCSV}
            disabled={!data}
            className="flex items-center gap-2 bg-primary-50 border border-primary-100 text-primary-600
                       px-3 py-1.5 rounded-xl text-xs font-semibold shadow-sm
                       hover:bg-primary-100 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Download size={14} />
            Export CSV
          </button>
        </div>
      </div>

      {loading ? (
        <>
          {/* KPI cards skeleton */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 animate-pulse">
            {[1, 2, 3].map((i) => (
              <div key={i} className="h-28 bg-gray-100 rounded-2xl" />
            ))}
          </div>

          {/* Chart skeleton */}
          <div className="h-80 bg-gray-100 rounded-2xl animate-pulse" />
        </>
      ) : (
        <>
          {/* ── KPI Grid ─────────────────────────────────────────────────────────── */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 scroll-animate delay-75">
            <KpiCard
              title="Total Revenue"
              value={data?.totalRevenue?.toLocaleString() ?? '0'}
              change={data?.revenueChange ?? 0}
              icon={DollarSign}
              iconBg="bg-green-100"
              iconColor="text-green-600"
              prefix="₹"
            />
            <KpiCard
              title="Avg Revenue / Ad"
              value={data?.avgRevenuePerAd?.toLocaleString() ?? '0'}
              icon={Activity}
              iconBg="bg-primary-50"
              iconColor="text-primary-500"
              prefix="₹"
            />
            <KpiCard
              title="Total Transactions"
              value={data?.totalTransactions?.toLocaleString() ?? '0'}
              icon={CreditCard}
              iconBg="bg-blue-100"
              iconColor="text-blue-600"
            />
          </div>

          {/* ── Charts Row ───────────────────────────────────────────────────────── */}
          <div className="grid grid-cols-1 gap-4 lg:gap-6 scroll-animate delay-150">
            <Suspense fallback={<ChartSkeleton />}>
              <RevenueDistributionChart data={chartData} />
            </Suspense>
          </div>
        </>
      )}

      {/* ── Map View Modal ──────────────────────────────────────────────────── */}
      <TransactionMapModal
        open={showMap}
        onClose={() => setShowMap(false)}
        allTransactions={allTransactions}
        geocodedAdmins={geocodedAdmins}
      />

    </div>
  )
}
