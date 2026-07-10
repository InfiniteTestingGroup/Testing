import React, { useEffect, useMemo, useState, useRef } from 'react'
import {
  BarChart, Bar, LineChart, Line, PieChart, Pie, Cell, Legend,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer
} from 'recharts'
import {
  GoogleMap,
  useJsApiLoader,
  Marker,
  InfoWindow,
  Circle,
} from '@react-google-maps/api'
import { Download, Calendar, Globe, BarChart2 as BarChart3, Radio, ChevronDown, Users, MapPin, SlidersHorizontal, Target, Activity, Megaphone, CheckCircle2, Loader2, Tv, Coins } from 'lucide-react'
import PageHeader from '../components/shared/PageHeader'
import StatusBadge from '../components/shared/StatusBadge'
import { AuthError } from '../lib/auth'
import { fetchSuperAdminAnalytics, fetchSuperAdminAnalyticsSummary } from '../lib/analytics'
import { fetchAdmins, fetchPublishers, fetchAdminDetail } from '../lib/management'
import { fetchAllTransactions } from '../lib/transactions'

const GOOGLE_MAPS_API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY || ''
const GMAPS_LIBRARIES = ['geocoding']

const MAP_STYLES = [
  { featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }] },
  { featureType: 'transit', stylers: [{ visibility: 'off' }] },
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#f5f5f5' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#c9e8f9' }] },
  { featureType: 'landscape', elementType: 'geometry', stylers: [{ color: '#f9f9f9' }] },
]

const MAP_CONTAINER_STYLE = { width: '100%', height: '100%' }
const DEFAULT_CENTER = { lat: 20.5937, lng: 78.9629 } // India fallback

const TABS = [
  { id: 'ad-performance', label: 'Campaign Performance', icon: BarChart3 },
  { id: 'geo-based', label: 'Geo-Based Analytics', icon: Globe },
  { id: 'graphical', label: 'Graphical Representation', icon: Activity }
]

const COLORS = ['#FF6B00', '#3B82F6', '#8B5CF6', '#10B981', '#F59E0B', '#EF4444']

const TIME_RANGES = [
  { value: 'TODAY', label: 'Today' },
  { value: 'LAST_7_DAYS', label: 'Last 7 Days' },
  { value: 'LAST_30_DAYS', label: 'Last 30 Days' },
  { value: 'LAST_90_DAYS', label: 'Last 90 Days' },
  { value: 'ALL_TIME', label: 'All Time' }
]

const AD_TYPE_MAP = {
  '64887c11cce361dafc86c23b': 'Banner',
  '64887c11cce361dafc86c23c': 'Video',
  '64887c11cce361dafc86c23d': 'Image',
}

const resolveAdType = (raw) => {
  if (!raw) return 'Unknown'
  return AD_TYPE_MAP[raw] ?? raw
}

const formatNumber = (value) => {
  if (typeof value === 'number') return value.toLocaleString()
  return value
}

const parseNumericValue = (value) => {
  if (typeof value === 'number') return value
  if (typeof value === 'string') {
    const parsed = Number(value.replace(/[^0-9.-]/g, ''))
    return Number.isFinite(parsed) ? parsed : 0
  }
  return 0
}

const sumBy = (items = [], key) => items.reduce((total, item) => total + parseNumericValue(item?.[key]), 0)

const formatCurrency = (value, options = {}) => {
  const decimals = options.decimals ?? 0
  return `₹${parseNumericValue(value).toLocaleString('en-IN', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  })}`
}

const normalizeChartData = (items = []) => items.map((item) => ({
  name: item.name || item.label,
  value: parseNumericValue(item.value),
}))

const isValidCoordinate = (value) => Number.isFinite(Number(value))

function geocodeAnalyticsLocation(locationName) {
  if (!locationName || locationName === 'Unknown') return Promise.resolve(null)
  const cacheKey = `keliri_geo_analytics_gmaps_${locationName}`
  try {
    const cached = sessionStorage.getItem(cacheKey)
    if (cached) return Promise.resolve(JSON.parse(cached))
  } catch { }

  return new Promise((resolve) => {
    try {
      const geocoder = new window.google.maps.Geocoder()
      geocoder.geocode({ address: locationName }, (results, status) => {
        if (status === 'OK' && results && results.length > 0) {
          const loc = results[0].geometry.location
          const result = { lat: loc.lat(), lng: loc.lng() }
          try { sessionStorage.setItem(cacheKey, JSON.stringify(result)) } catch { }
          resolve(result)
        } else {
          resolve(null)
        }
      })
    } catch {
      resolve(null)
    }
  })
}

async function geocodeAdmin(admin) {
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
      const lon = data.features[0].geometry.coordinates[0];
      const lat = data.features[0].geometry.coordinates[1];
      sessionStorage.setItem(cacheKey, JSON.stringify({ lat, lng: lon }));
      return { lat, lng: lon };
    }
  } catch { }
  return geocodeAdmin(admin);
}

const getGeoMetricValue = (row, metric, summary = []) => {
  if (metric === 'activeCampaigns') return parseNumericValue(row.activeCampaigns)
  if (metric === 'campaigns') return parseNumericValue(row.campaigns)
  if (metric === 'admins') return parseNumericValue(row.admins)
  if (metric === 'publishers') return parseNumericValue(row.publishers)
  if (metric === 'users') return parseNumericValue(row.users)
  if (metric === 'transactions') return parseNumericValue(row.transactions)
  if (metric === 'adTypes') return parseNumericValue(row.adTypes)
  return parseNumericValue(summary.find((item) => item.id === metric)?.value)
}

const getGeoMetricLabel = (metric, summary = []) => summary.find((item) => item.id === metric)?.label || 'Campaigns'

function makeDotIcon(color, label, isSelected = false) {
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

const AnalyticsGoogleMap = ({ locations, metric, summary, isResolvingAdmins, geocodeProgress }) => {
  const metricLabel = getGeoMetricLabel(metric, summary)
  const [resolvedLocations, setResolvedLocations] = useState([])
  const [isResolving, setIsResolving] = useState(false)
  const [openInfoWindowKey, setOpenInfoWindowKey] = useState(null)

  const { isLoaded, loadError } = useJsApiLoader({
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: GMAPS_LIBRARIES,
  })

  const mapRef = useRef(null)

  useEffect(() => {
    let cancelled = false

    async function resolveLocations() {
      setIsResolving(true)

      const promises = locations.map(async (row) => {
        let latitude = isValidCoordinate(row.latitude) ? Number(row.latitude) : null
        let longitude = isValidCoordinate(row.longitude) ? Number(row.longitude) : null

        if ((latitude === null || longitude === null) && row.city) {
          const geocoded = await geocodeAnalyticsLocation(row.city)
          if (geocoded) {
            latitude = geocoded.lat
            longitude = geocoded.lng
          }
        }

        if (latitude !== null && longitude !== null) {
          return { ...row, latitude, longitude }
        }
        return null
      })

      const resolved = await Promise.all(promises)
      const results = resolved.filter((item) => item !== null)

      if (!cancelled) {
        setResolvedLocations(results)
        setIsResolving(false)
      }
    }

    if (isLoaded) {
      resolveLocations()
    }
    return () => {
      cancelled = true
    }
  }, [locations, isLoaded])

  // Auto-fit bounds when locations resolve
  // useEffect(() => {
  //   if (!mapRef.current || resolvedLocations.length === 0) return
  //   const bounds = new window.google.maps.LatLngBounds()
  //   resolvedLocations.forEach((loc) => bounds.extend({ lat: loc.latitude, lng: loc.longitude }))
  //   mapRef.current.fitBounds(bounds, 60)
  // }, [resolvedLocations])

  const mappedLocations = resolvedLocations
  const mapCenter = DEFAULT_CENTER

  return (
    <div className="relative h-[560px] bg-slate-50">
      {loadError && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-50">
          <p className="text-sm text-red-500 font-medium">Failed to load Google Maps. Check your API key.</p>
        </div>
      )}

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
          }}
          onLoad={(map) => { mapRef.current = map }}
        >
          {mappedLocations.filter(row => getGeoMetricValue(row, metric, summary) > 0).map((row, index) => {
            const value = getGeoMetricValue(row, metric, summary)
            const color = COLORS[index % COLORS.length]
            const radius = Math.max(500, Math.min(9000, (Number(row.averageRadiusKm || 1) * 1000) + (parseNumericValue(row.campaigns) * 18)))
            const key = `${row.city}-${row.latitude}-${row.longitude}`
            const isSelected = openInfoWindowKey === key
            const markerLabel = value > 999 ? '999+' : String(value)

            return (
              <React.Fragment key={key}>
                <Marker
                  position={{ lat: row.latitude, lng: row.longitude }}
                  icon={makeDotIcon(color, markerLabel, isSelected)}
                  onClick={() => setOpenInfoWindowKey(isSelected ? null : key)}
                />

                {isSelected && (
                  <InfoWindow
                    position={{ lat: row.latitude, lng: row.longitude }}
                    onCloseClick={() => setOpenInfoWindowKey(null)}
                  >
                    <div style={{ fontFamily: 'Inter, system-ui, sans-serif', minWidth: 160 }}>
                      <p style={{ margin: 0, fontWeight: 800, color: '#111827', fontSize: '13px' }}>{row.city}</p>
                      {metric === 'admins' ? (
                        <>
                          <p style={{ margin: '6px 0 0', fontSize: '11px', color: '#4b5563' }}>Status: {row.status}</p>
                          <p style={{ margin: '2px 0 0', fontSize: '11px', color: '#4b5563' }}>Role: Admin</p>
                        </>
                      ) : metric === 'publishers' ? (
                        <>
                          <p style={{ margin: '6px 0 0', fontSize: '11px', color: '#4b5563' }}>Status: {row.status}</p>
                          <p style={{ margin: '2px 0 0', fontSize: '11px', color: '#4b5563' }}>Role: Publisher</p>
                        </>
                      ) : metric === 'transactions' ? (
                        <div style={{ marginTop: '6px', maxHeight: '150px', overflowY: 'auto', paddingRight: '4px' }}>
                          <p style={{ margin: '0 0 4px 0', fontSize: '11px', fontWeight: 'bold', color: '#374151' }}>
                            Transactions ({row.txList ? row.txList.length : 0}):
                          </p>
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                            {row.txList && row.txList.map((tx, idx) => (
                              <div key={`${tx.id}-${idx}`} style={{ borderBottom: '1px solid #f3f4f6', paddingBottom: '4px', marginBottom: '2px' }}>
                                <p style={{ margin: 0, fontSize: '10px', fontWeight: 'bold', color: '#111827' }}>
                                  {tx.id} - <span style={{ color: tx.status === 'Completed' ? '#10B981' : tx.status === 'Pending' ? '#F59E0B' : '#EF4444' }}>{tx.status}</span>
                                </p>
                                <p style={{ margin: '1px 0 0 0', fontSize: '9px', color: '#6b7280' }}>
                                  {tx.amount} | {tx.date}
                                </p>
                              </div>
                            ))}
                          </div>
                        </div>
                      ) : (
                        <>
                          <p style={{ margin: '6px 0 0', fontSize: '11px', color: '#4b5563' }}>Campaigns: {row.campaigns}</p>
                          <p style={{ margin: '2px 0 0', fontSize: '11px', color: '#4b5563' }}>Active: {row.activeCampaigns}</p>
                          <p style={{ margin: '2px 0 0', fontSize: '11px', color: '#4b5563' }}>{metricLabel}: {formatNumber(value)}</p>
                        </>
                      )}
                      <p style={{ margin: '4px 0 0', fontSize: '9px', color: '#9ca3af', fontFamily: 'monospace' }}>
                        {row.latitude.toFixed(4)}, {row.longitude.toFixed(4)}
                      </p>
                    </div>
                  </InfoWindow>
                )}

                {metric !== 'admins' && metric !== 'publishers' && metric !== 'transactions' && (
                  <Circle
                    center={{ lat: row.latitude, lng: row.longitude }}
                    radius={radius}
                    options={{
                      strokeColor: color,
                      strokeOpacity: 0.8,
                      strokeWeight: 2,
                      fillColor: color,
                      fillOpacity: 0.12,
                    }}
                  />
                )}
              </React.Fragment>
            )
          })}
        </GoogleMap>
      )}

      {!isLoaded && !loadError && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-50">
          <Loader2 className="w-6 h-6 text-primary-400 animate-spin" />
        </div>
      )}
      <div className="absolute left-4 top-4 grid grid-cols-2 md:grid-cols-5 gap-2 max-w-[calc(100%-2rem)]">
        {summary.map((item) => (
          <div key={item.id} className="bg-white/95 backdrop-blur border border-gray-100 rounded-xl px-3 py-2 shadow-sm">
            <p className="text-[10px] font-black text-gray-400 uppercase tracking-wide">{item.label}</p>
            <p className="text-lg font-black text-gray-900">{formatNumber(item.value)}</p>
          </div>
        ))}
      </div>
      {!mappedLocations.length && (
        <div className="absolute inset-0 flex items-center justify-center p-6 text-center">
          <div className="bg-white border border-orange-100 rounded-2xl shadow-card px-6 py-5 max-w-md">
            <p className="text-sm font-bold text-gray-900">No coordinates available for current analytics data.</p>
            <p className="text-xs text-gray-500 mt-2">Make sure campaign rows have location.lat and location.lng in MongoDB.</p>
          </div>
        </div>
      )}
      {isResolving && (
        <div className="absolute top-4 left-1/2 -translate-x-1/2 bg-white/95 backdrop-blur border border-gray-100 rounded-xl px-4 py-2 shadow-sm">
          <p className="text-xs font-bold text-gray-700">Locating campaign areas...</p>
        </div>
      )}
      {isResolvingAdmins && metric === 'admins' && (
        <div className="absolute top-4 left-1/2 -translate-x-1/2 bg-white/95 backdrop-blur border border-gray-100 rounded-xl px-4 py-2 shadow-sm">
          <p className="text-xs font-bold text-gray-700">Locating admins... {geocodeProgress}%</p>
        </div>
      )}
      {!!mappedLocations.length && (
        <div className="absolute bottom-4 left-4 bg-white/95 backdrop-blur border border-gray-100 rounded-xl px-3 py-2 shadow-sm">
          <p className="text-[10px] font-black text-gray-400 uppercase tracking-wide">Map Showing</p>
          <p className="text-sm font-black text-gray-900">{metricLabel}</p>
        </div>
      )}
    </div>
  )
}


const Analytics = () => {
  const [activeTab, setActiveTab] = useState('ad-performance')
  const [timeRange, setTimeRange] = useState('ALL_TIME')
  const [selectedAdType, setSelectedAdType] = useState('ALL')
  const [geoMetric, setGeoMetric] = useState('campaigns')
  const [analytics, setAnalytics] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [admins, setAdmins] = useState([])
  const [publishers, setPublishers] = useState([])
  const [allTransactions, setAllTransactions] = useState([])
  const [geocodedAdmins, setGeocodedAdmins] = useState([])
  const [isGeocodingAdmins, setIsGeocodingAdmins] = useState(false)
  const [geocodeProgress, setGeocodeProgress] = useState(0)
  const [selectedYear, setSelectedYear] = useState(() => new Date().getFullYear().toString())
  const [isYearDropdownOpen, setIsYearDropdownOpen] = useState(false)

  useEffect(() => {
    async function loadTransactions() {
      try {
        const data = await fetchAllTransactions()
        setAllTransactions(data)
      } catch (err) {
        console.error("Failed to load transactions in analytics", err)
      }
    }
    loadTransactions()
  }, [])

  useEffect(() => {
    async function loadAdmins() {
      try {
        const data = await fetchAdmins()
        setAdmins(data)
      } catch (err) {
        console.error("Failed to load admins in analytics", err)
      }
    }
    loadAdmins()
  }, [])

  useEffect(() => {
    async function loadPublishers() {
      try {
        const data = await fetchPublishers()
        setPublishers(data)
      } catch (err) {
        console.error("Failed to load publishers in analytics", err)
      }
    }
    loadPublishers()
  }, [])

  useEffect(() => {
    if (admins.length === 0) return;

    let cancelled = false;

    const runGeocoding = async () => {
      setIsGeocodingAdmins(true);
      setGeocodeProgress(0);
      const results = [];

      for (let i = 0; i < admins.length; i++) {
        if (cancelled) return;
        const admin = admins[i];

        // Already has lat/lng
        if (admin.latitude && admin.longitude && Number(admin.latitude) !== 0 && Number(admin.longitude) !== 0) {
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

        if (!cancelled) {
          setGeocodeProgress(Math.round(((i + 1) / admins.length) * 100));
          setGeocodedAdmins([...results]);
        }

        if (i < admins.length - 1) {
          await new Promise((r) => setTimeout(r, 200));
        }
      }

      if (!cancelled) {
        setIsGeocodingAdmins(false);
      }
    };

    runGeocoding();

    return () => {
      cancelled = true;
    };
  }, [admins]);

  useEffect(() => {
    let cancelled = false

    async function loadAnalytics() {
      setLoading(true)
      setError('')

      try {
        const summaryPayload = await fetchSuperAdminAnalyticsSummary()
        if (cancelled) return
        setAnalytics(summaryPayload)
        setLoading(false)

        const payload = await fetchSuperAdminAnalytics(timeRange, selectedAdType)
        if (cancelled) return
        setAnalytics(payload)
      } catch (err) {
        if (cancelled) return
        if (err instanceof AuthError) {
          setError(err.message)
        } else {
          setError('Unable to load live analytics right now.')
        }
      } finally {
        if (!cancelled) {
          setLoading(false)
        }
      }
    }

    loadAnalytics()
    return () => {
      cancelled = true
    }
  }, [timeRange, selectedAdType])

  const handleExport = () => {
    window.print()
  }

  const handleExportCSV = () => {
    let csvContent = '--- KEY PERFORMANCE INDICATORS ---\nMetric,Value\n';
    if (visibleData.kpis && visibleData.kpis.length) {
      visibleData.kpis.forEach(kpi => {
        csvContent += `"${(kpi.title || '').replace(/"/g, '""')}","${(kpi.value || '').replace(/"/g, '""')}"\n`;
      });
    }

    csvContent += '\n--- CAMPAIGNS BY AD TYPE ---\nAd Type,Count\n';
    if (visibleData.adTypeBreakdown && visibleData.adTypeBreakdown.length) {
      visibleData.adTypeBreakdown.forEach(item => {
        csvContent += `"${(item.name || '').replace(/"/g, '""')}","${item.count || 0}"\n`;
      });
    }

    csvContent += '\n--- LOCATION ACTIVITY ---\nCity,Campaigns,Active Campaigns,Avg Radius Km,Status,Latitude,Longitude,Admins,Users,Ad Types\n';
    if (visibleData.locationRows && visibleData.locationRows.length) {
      visibleData.locationRows.forEach(row => {
        csvContent += `"${(row.city || '').replace(/"/g, '""')}","${row.campaigns || 0}","${row.activeCampaigns || 0}","${row.averageRadiusKm || 0}","${(row.status || '').replace(/"/g, '""')}","${row.latitude || ''}","${row.longitude || ''}","${row.admins || 0}","${row.users || 0}","${row.adTypes || 0}"\n`;
      });
    }

    csvContent += '\n--- CREATOR LEADERBOARD ---\nRank,Creator Name,Campaigns,Active,Locations\n';
    if (visibleData.creatorRows && visibleData.creatorRows.length) {
      visibleData.creatorRows.forEach(row => {
        csvContent += `"${row.rank || ''}","${(row.name || '').replace(/"/g, '""')}","${row.campaigns || 0}","${row.activeCampaigns || 0}","${row.targetedLocations || 0}"\n`;
      });
    }

    csvContent += '\n--- PUBLISHERS ---\nName,Admin,Location,Status,Ads Posted,Impressions,Clicks,Engagement,Join Date\n';
    if (publishers && publishers.length) {
      publishers.forEach(pub => {
        csvContent += `"${(pub.name || '').replace(/"/g, '""')}","${(pub.adminName || '').replace(/"/g, '""')}","${(pub.location || '').replace(/"/g, '""')}","${(pub.status || '').replace(/"/g, '""')}","${pub.adsPosted || 0}","${pub.impressions || 0}","${pub.clicks || 0}","${pub.engagement || 0}","${pub.joinDate || ''}"\n`;
      });
    }

    csvContent += '\n--- MONTHLY PUBLISHER REGISTRATIONS ---\nMonth,Publishers Registered\n';
    if (monthlyPublishers && monthlyPublishers.length) {
      monthlyPublishers.forEach(item => {
        csvContent += `"${item.name}","${item.value}"\n`;
      });
    }

    csvContent += '\n--- MONTHLY TRANSACTIONS ---\nMonth,Transactions\n';
    const monthlyTxns = normalizeChartData(visibleData.monthlyTransactionsTrend);
    if (monthlyTxns && monthlyTxns.length) {
      monthlyTxns.forEach(item => {
        csvContent += `"${item.name}","${item.value}"\n`;
      });
    }


    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `superadmin_analytics_${timeRange.toLowerCase()}_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  const adminLocations = useMemo(() => {
    const coordCounts = {};
    return geocodedAdmins.map(a => {
      let lat = Number(a.lat);
      let lng = Number(a.lng);

      // Round to 3 decimal places to detect coordinates that are extremely close
      const key = `${lat.toFixed(3)},${lng.toFixed(3)}`;
      if (coordCounts[key] === undefined) {
        coordCounts[key] = 0;
      } else {
        coordCounts[key] += 1;
        // Offset subsequent markers slightly in a circle pattern
        const angle = (coordCounts[key] * 2 * Math.PI) / 8;
        const distance = 0.015; // Jitter offset
        lat += Math.sin(angle) * distance;
        lng += Math.cos(angle) * distance;
      }

      return {
        city: `${a.name} (${a.company})`,
        latitude: lat,
        longitude: lng,
        campaigns: 0,
        activeCampaigns: 0,
        averageRadiusKm: 0,
        admins: 1,
        users: 0,
        adTypes: 0,
        status: a.status
      };
    });
  }, [geocodedAdmins]);

  const transactionLocations = useMemo(() => {
    const grouped = {};
    allTransactions.forEach(t => {
      let lat = t.latitude ? Number(t.latitude) : null;
      let lng = t.longitude ? Number(t.longitude) : null;

      if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
        const adminObj = geocodedAdmins.find(a => a.id === t.adminId || a.name === t.admin);
        if (adminObj && adminObj.lat && adminObj.lng) {
          lat = Number(adminObj.lat);
          lng = Number(adminObj.lng);
        }
      }

      if (lat && lng && lat !== 0 && lng !== 0) {
        const key = t.adminId || `${lat.toFixed(4)},${lng.toFixed(4)}`;
        if (!grouped[key]) {
          grouped[key] = {
            city: t.admin,
            adminId: t.adminId,
            latitude: lat,
            longitude: lng,
            campaigns: 0,
            activeCampaigns: 0,
            averageRadiusKm: 0,
            admins: 0,
            publishers: 0,
            users: 0,
            transactions: 0,
            txList: []
          };
        }
        grouped[key].transactions += 1;
        grouped[key].txList.push({
          id: t.id,
          status: t.status,
          amount: t.amount,
          date: t.date,
          reference: t.type
        });
      }
    });

    return Object.values(grouped);
  }, [allTransactions, geocodedAdmins]);

  const publisherLocations = useMemo(() => {
    const coordCounts = {};
    return publishers
      .filter(p => {
        let lat = p.latitude;
        let lng = p.longitude;
        if ((lat == null || lng == null) && typeof p.location === "string") {
          const parts = p.location.split(",");
          if (parts.length >= 2) {
            const parsedLat = parseFloat(parts[0].trim());
            const parsedLng = parseFloat(parts[1].trim());
            if (!isNaN(parsedLat) && !isNaN(parsedLng)) {
              lat = parsedLat;
              lng = parsedLng;
            }
          }
        }
        return lat && lng && lat !== 0 && lng !== 0;
      })
      .map(p => {
        let lat = p.latitude;
        let lng = p.longitude;
        if ((lat == null || lng == null) && typeof p.location === "string") {
          const parts = p.location.split(",");
          const parsedLat = parseFloat(parts[0].trim());
          const parsedLng = parseFloat(parts[1].trim());
          lat = parsedLat;
          lng = parsedLng;
        }

        lat = Number(lat);
        lng = Number(lng);

        const key = `${lat.toFixed(3)},${lng.toFixed(3)}`;
        if (coordCounts[key] === undefined) {
          coordCounts[key] = 0;
        } else {
          coordCounts[key] += 1;
          const angle = (coordCounts[key] * 2 * Math.PI) / 8;
          const distance = 0.015;
          lat += Math.sin(angle) * distance;
          lng += Math.cos(angle) * distance;
        }

        return {
          city: `${p.name} (${p.adminName || 'Publisher'})`,
          latitude: lat,
          longitude: lng,
          campaigns: 0,
          activeCampaigns: 0,
          averageRadiusKm: 0,
          admins: 0,
          publishers: 1,
          users: 0,
          adTypes: 0,
          status: p.status
        };
      });
  }, [publishers]);

  const visibleData = useMemo(() => {
    const rawData = analytics ?? {
      kpis: [],
      topCampaigns: [],
      adTypeBreakdown: [],
      locationRows: [],
      radiusBreakdown: [],
      topLocation: 'No targeted location',
      creatorRows: [],
      campaignsPerCreator: [],
      publisherRows: [],
      monthlyTrend: [],
      weeklyTrend: [],
      durationBreakdown: [],
      monthlyTransactionsTrend: [],
    }

    const mappedAdTypeBreakdown = (rawData.adTypeBreakdown || []).map(item => ({
      ...item,
      name: resolveAdType(item.name)
    }))

    return {
      ...rawData,
      adTypeBreakdown: mappedAdTypeBreakdown
    }
  }, [analytics])

  const monthlyPublishers = useMemo(() => {
    const counts = {}
    publishers.forEach(pub => {
      const rawDate = pub.joinDate || pub.createdAt || pub.lastActive
      if (!rawDate) return
      const date = new Date(rawDate)
      if (isNaN(date.getTime())) return
      const month = date.toLocaleString('default', { month: 'short' })
      const year = date.getFullYear()
      const label = `${month} ${year}`
      counts[label] = (counts[label] || 0) + 1
    })
    return Object.entries(counts)
      .map(([name, value]) => ({ name, value }))
      .sort((a, b) => new Date('01 ' + a.name).getTime() - new Date('01 ' + b.name).getTime())
  }, [publishers])

  const availableYears = useMemo(() => {
    const years = new Set()
    const extractYear = (name) => {
      if (!name) return null
      const parts = name.split(' ')
      if (parts.length >= 2) {
        const yr = parts[parts.length - 1]
        if (/^\d{4}$/.test(yr)) return yr
      }
      return null
    }

    const trends = [
      ...(visibleData.monthlyTrend || []),
      ...(visibleData.monthlyAdminsTrend || []),
      ...(visibleData.monthlyUsersTrend || []),
      ...(visibleData.monthlyTransactionsTrend || []),
      ...monthlyPublishers
    ]

    trends.forEach(item => {
      const yr = extractYear(item.name || item.label)
      if (yr) years.add(yr)
    })

    return Array.from(years).sort((a, b) => b - a)
  }, [visibleData.monthlyTrend, visibleData.monthlyAdminsTrend, visibleData.monthlyUsersTrend, monthlyPublishers])

  useEffect(() => {
    if (availableYears.length > 0 && !availableYears.includes(selectedYear)) {
      setSelectedYear(availableYears[0])
    }
  }, [availableYears, selectedYear])

  const renderKPIs = (data = []) => (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      {data.map((kpi, idx) => (
        <div key={`${kpi.title}-${idx}`} className="card-floating tilt-card animate-fade-in-scale group hover:-translate-y-2 transition-all duration-500 overflow-hidden relative">
          <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity">
            <BarChart3 size={80} />
          </div>
          <div className="relative z-10">
            <p className="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4">{kpi.title}</p>
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-4xl font-black text-slate-900 tracking-tighter">{kpi.value}</h3>
              <div className={`flex items-center gap-1 px-3 py-1.5 rounded-full text-[10px] font-black shadow-sm ${kpi.change >= 0 ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'}`}>
                {kpi.change >= 0 ? '↑' : '↓'} {Math.abs(kpi.change)}%
              </div>
            </div>
            <div className="h-12 w-full mt-2 opacity-50 group-hover:opacity-100 transition-opacity">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={[...Array(8)].map((_, i) => ({ v: (i + 1) * (idx + 2) * 10 }))}>
                  <Line type="monotone" dataKey="v" stroke={kpi.change >= 0 ? '#10b981' : '#f43f5e'} strokeWidth={2} dot={false} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      ))}
    </div>
  )

  const renderAdPerformanceOld = () => (
    <div className="space-y-6">
      {renderKPIs(visibleData.kpis)}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Most Reused Campaign Creatives</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={visibleData.topCampaigns}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip />
                <Bar dataKey="count" fill="#FF6B00" radius={[4, 4, 0, 0]} name="Campaign count" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Campaigns by Ad Type</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={visibleData.adTypeBreakdown}
                  cx="50%"
                  cy="50%"
                  innerRadius={80}
                  outerRadius={120}
                  paddingAngle={5}
                  dataKey="count"
                  nameKey="name"
                >
                  {visibleData.adTypeBreakdown.map((entry, index) => (
                    <Cell key={`${entry.name}-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  )

  const renderGeoBasedOld = () => (
    <div className="space-y-6">
      <div className="bg-white p-6 rounded-2xl shadow-card animate-fade-in flex items-center justify-between border-l-4 border-primary-500">
        <div>
          <p className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Top Targeted Location</p>
          <h3 className="text-2xl font-bold text-gray-900">{visibleData.topLocation}</h3>
        </div>
        <div className="text-right">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Impact</p>
          <p className="text-xl font-bold text-primary-600">{visibleData.locationRows[0]?.campaigns ?? 0} campaigns</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-2xl shadow-card overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100">
            <h3 className="text-lg font-bold text-gray-900">Location-wise Campaign Activity</h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Location</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Campaigns</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Active</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Avg Radius</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {visibleData.locationRows.map((row, idx) => (
                  <tr key={`${row.city}-${idx}`} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-4 text-sm font-semibold text-gray-900">{row.city}</td>
                    <td className="px-6 py-4 text-sm text-gray-600">{formatNumber(row.campaigns)}</td>
                    <td className="px-6 py-4 text-sm text-gray-600">{formatNumber(row.activeCampaigns)}</td>
                    <td className="px-6 py-4 text-sm font-bold text-primary-600">{row.averageRadiusKm} km</td>
                    <td className="px-6 py-4"><StatusBadge status={row.status} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Campaigns by Radius Bucket</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={visibleData.radiusBreakdown}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip />
                <Bar dataKey="value" fill="#FF6B00" radius={[4, 4, 0, 0]} name="Campaign count" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  )

  const kpiByTitle = useMemo(() => {
    const map = new Map()
    visibleData.kpis.forEach((kpi) => map.set(kpi.title, kpi))
    return map
  }, [visibleData.kpis])

  const performanceMetrics = useMemo(() => {
    const totalAds = parseNumericValue(kpiByTitle.get('Total Ads')?.value)
    const totalCampaigns = parseNumericValue(kpiByTitle.get('Total Campaigns')?.value)
    const activeAds = parseNumericValue(kpiByTitle.get('Active Ads')?.value)
    const activeCampaigns = parseNumericValue(kpiByTitle.get('Active Campaigns')?.value)
    const publishers = parseNumericValue(kpiByTitle.get('Publishers')?.value)
    const totalUsers = parseNumericValue(kpiByTitle.get('Total Users')?.value)
    const totalAdmins = parseNumericValue(kpiByTitle.get('Total Admins')?.value)
    const totalTransactions = parseNumericValue(kpiByTitle.get('Total Transactions')?.value)
    const totalAmount = kpiByTitle.get('Total Amount')?.value || '₹0'

    return [
      { title: 'Total Ads', value: totalAds, icon: Megaphone, iconBg: 'bg-primary-50', iconColor: 'text-primary-500' },
      { title: 'Total Campaigns', value: totalCampaigns, icon: Target, iconBg: 'bg-orange-100', iconColor: 'text-orange-600' },
      { title: 'Active Campaigns', value: activeCampaigns, icon: Activity, iconBg: 'bg-emerald-100', iconColor: 'text-emerald-600' },
      { title: 'Active Ads', value: activeAds, icon: CheckCircle2, iconBg: 'bg-blue-100', iconColor: 'text-blue-600' },
      { title: 'Publishers', value: publishers, icon: Radio, iconBg: 'bg-purple-100', iconColor: 'text-purple-600' },
      { title: 'Total Users', value: totalUsers, icon: Radio, iconBg: 'bg-green-100', iconColor: 'text-green-600' },
      { title: 'Total Admins', value: totalAdmins, icon: Users, iconBg: 'bg-rose-100', iconColor: 'text-rose-600' },
      { title: 'Total Transactions', value: totalTransactions, icon: Activity, iconBg: 'bg-indigo-100', iconColor: 'text-indigo-600' },
      { title: 'Total Amount', value: totalAmount, icon: Coins, iconBg: 'bg-yellow-100', iconColor: 'text-yellow-600' },
    ]
  }, [kpiByTitle])

  const geoSummary = useMemo(() => {
    const kpiCampaigns = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Total Campaigns')?.value)
    const totalCampaigns = kpiCampaigns || sumBy(visibleData.locationRows, 'campaigns')
    const kpiActive = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Active Ads' || k.title === 'Active Campaigns')?.value)
    const activeCampaigns = kpiActive || sumBy(visibleData.locationRows, 'activeCampaigns')
    const kpiAdmins = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Total Admins')?.value)
    const totalAdmins = kpiAdmins || sumBy(visibleData.locationRows, 'admins')
    const kpiUsers = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Total Users')?.value)
    const totalUsers = kpiUsers || sumBy(visibleData.locationRows, 'users')
    const kpiPublishers = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Publishers')?.value)
    const totalPublishers = kpiPublishers || publishers.length
    const kpiTransactions = parseNumericValue(visibleData.kpis?.find(k => k.title === 'Total Transactions')?.value)
    const totalTransactions = kpiTransactions || allTransactions.length

    return [
      { id: 'campaigns', label: 'Campaigns', value: totalCampaigns, icon: Target },
      { id: 'activeCampaigns', label: 'Active Campaigns', value: activeCampaigns, icon: Activity },
      { id: 'admins', label: 'Total Admins', value: totalAdmins, icon: Users },
      { id: 'publishers', label: 'Total Publishers', value: totalPublishers, icon: Tv },
      { id: 'users', label: 'Total Users', value: totalUsers, icon: Radio },
      { id: 'transactions', label: 'Total Transactions', value: totalTransactions, icon: Coins },
    ]
  }, [visibleData.locationRows, visibleData.kpis, publishers, allTransactions])

  const renderNumberCards = (items = []) => (
    <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4 sm:gap-6">
      {items.map((item, idx) => (
        <div key={`${item.title}-${idx}`} className="glass-card-hover p-5 group animate-fade-in flex flex-col justify-between h-full min-h-[140px]">
          <div className="flex items-center justify-between mb-4">
            <div className={`w-10 h-10 ${item.iconBg} rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300 flex-shrink-0`}>
              <item.icon size={18} className={item.iconColor} />
            </div>
          </div>
          <p className="text-[24px] font-bold text-gray-900 tracking-tight leading-none">{formatNumber(item.value)}</p>
          <p className="text-[13px] font-medium text-gray-600 mt-1.5">{item.title}</p>
        </div>
      ))}
    </div>
  )


  const renderAdPerformance = () => (
    <div className="space-y-6">
      {renderNumberCards(performanceMetrics)}
    </div>
  )

  const renderGraphicalRepresentation = () => {
    const monthlyAds = normalizeChartData(visibleData.monthlyTrend)
    const monthlyAdmins = normalizeChartData(visibleData.monthlyAdminsTrend)
    const monthlyUsers = normalizeChartData(visibleData.monthlyUsersTrend)
    const monthlyTransactions = normalizeChartData(visibleData.monthlyTransactionsTrend)

    const filterByYear = (data) => {
      if (selectedYear === 'ALL') return data
      return data.filter(item => {
        const name = item.name || ''
        return name.endsWith(selectedYear)
      })
    }

    const filteredAds = filterByYear(monthlyAds)
    const filteredAdmins = filterByYear(monthlyAdmins)
    const filteredUsers = filterByYear(monthlyUsers)
    const filteredTransactions = filterByYear(monthlyTransactions)

    return (
      <div className="space-y-6">

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Ads Published</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={filteredAds} margin={{ top: 10, right: 20, left: 18, bottom: 28 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis
                  dataKey="name"
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  label={{ value: 'Months', position: 'insideBottom', offset: -4, fontSize: 12, fontWeight: 700 }}
                />
                <YAxis
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  allowDecimals={false}
                  label={{ value: 'Ads Published', angle: -90, position: 'insideLeft', fontSize: 12, fontWeight: 700 }}
                />
                <Tooltip />
                <Bar dataKey="value" fill="#FF6B00" radius={[4, 4, 0, 0]} name="Total ads" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Admins Registered</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={filteredAdmins} margin={{ top: 10, right: 20, left: 18, bottom: 28 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis
                  dataKey="name"
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  label={{ value: 'Months', position: 'insideBottom', offset: -4, fontSize: 12, fontWeight: 700 }}
                />
                <YAxis
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  allowDecimals={false}
                  label={{ value: 'Admins Registered', angle: -90, position: 'insideLeft', fontSize: 12, fontWeight: 700 }}
                />
                <Tooltip />
                <Bar dataKey="value" fill="#EF4444" radius={[4, 4, 0, 0]} name="Admins" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Users Joined</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={filteredUsers} margin={{ top: 10, right: 20, left: 18, bottom: 28 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis
                  dataKey="name"
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  label={{ value: 'Months', position: 'insideBottom', offset: -4, fontSize: 12, fontWeight: 700 }}
                />
                <YAxis
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  allowDecimals={false}
                  label={{ value: 'Users Joined', angle: -90, position: 'insideLeft', fontSize: 12, fontWeight: 700 }}
                />
                <Tooltip />
                <Bar dataKey="value" fill="#10B981" radius={[4, 4, 0, 0]} name="Users" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Publishers Created</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={filterByYear(monthlyPublishers)} margin={{ top: 10, right: 20, left: 18, bottom: 28 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis
                  dataKey="name"
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  label={{ value: 'Months', position: 'insideBottom', offset: -4, fontSize: 12, fontWeight: 700 }}
                />
                <YAxis
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  allowDecimals={false}
                  label={{ value: 'Publishers Registered', angle: -90, position: 'insideLeft', fontSize: 12, fontWeight: 700 }}
                />
                <Tooltip />
                <Bar dataKey="value" fill="#8B5CF6" radius={[4, 4, 0, 0]} name="Publishers" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Transactions</h3>
          <div className="h-[350px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={filteredTransactions} margin={{ top: 10, right: 20, left: 18, bottom: 28 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis
                  dataKey="name"
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  label={{ value: 'Months', position: 'insideBottom', offset: -4, fontSize: 12, fontWeight: 700 }}
                />
                <YAxis
                  fontSize={12}
                  tickLine={false}
                  axisLine={false}
                  allowDecimals={false}
                  label={{ value: 'Transactions', angle: -90, position: 'insideLeft', fontSize: 12, fontWeight: 700 }}
                />
                <Tooltip formatter={(value) => [value, 'Transactions']} />
                <Bar dataKey="value" fill="#6366F1" radius={[4, 4, 0, 0]} name="Transactions" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    )
  }

  const renderGeoBased = () => (
    <div className="grid grid-cols-1 lg:grid-cols-[1fr_320px] gap-6 items-start">
      <div className="bg-white rounded-2xl shadow-card overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-100 flex flex-wrap items-center justify-between gap-3">
          <div>
            <h3 className="text-lg font-bold text-gray-900">Geo Analytics Map</h3>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mt-1">Showing {geoSummary.find(item => item.id === geoMetric)?.label}</p>
          </div>
          <div className="flex items-center gap-2 text-xs font-bold text-primary-600 bg-primary-50 px-3 py-2 rounded-xl">
            <MapPin size={14} />
            {visibleData.topLocation}
          </div>
        </div>

        <AnalyticsGoogleMap
          locations={
            geoMetric === 'admins'
              ? adminLocations
              : geoMetric === 'publishers'
                ? publisherLocations
                : geoMetric === 'transactions'
                  ? transactionLocations
                  : visibleData.locationRows
          }
          metric={geoMetric}
          summary={geoSummary}
          isResolvingAdmins={isGeocodingAdmins}
          geocodeProgress={geocodeProgress}
        />
      </div>

      <div className="space-y-6">
        <div className="bg-white p-5 rounded-2xl shadow-card">
          <div className="flex items-center gap-2 mb-4">
            <SlidersHorizontal size={18} className="text-primary-500" />
            <h3 className="text-sm font-black text-gray-900 uppercase tracking-wider">Customize Map</h3>
          </div>
          <div className="space-y-2">
            {geoSummary.map((item) => {
              const Icon = item.icon
              const selected = geoMetric === item.id
              return (
                <button
                  key={item.id}
                  onClick={() => setGeoMetric(item.id)}
                  className={`w-full flex items-center justify-between p-3 rounded-xl border transition-all ${selected ? 'border-primary-200 bg-primary-50 text-primary-700' : 'border-gray-100 bg-white text-gray-600 hover:bg-gray-50'
                    }`}
                >
                  <span className="flex items-center gap-2 text-xs font-black uppercase tracking-wide">
                    <Icon size={15} />
                    {item.label}
                  </span>
                  <span className="text-lg font-black">{formatNumber(item.value)}</span>
                </button>
              )
            })}
          </div>
        </div>

        <div className="bg-white p-5 rounded-2xl shadow-card">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-black text-gray-900 uppercase tracking-wider">Ad Types</h3>
          </div>
          <div className="space-y-2">
            {visibleData.adTypeBreakdown.map((item, index) => {
              const count = item.count || 0;
              return (
                <div
                  key={`${item.name}-${index}`}
                  className="w-full flex items-center justify-between p-3 rounded-xl border border-gray-100 bg-white text-gray-600"
                >
                  <span className="flex items-center gap-2 text-xs font-bold text-gray-700">
                    <span className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: COLORS[index % COLORS.length] }} />
                    {item.name}
                  </span>
                  <span className="text-sm font-black text-gray-900">{formatNumber(count)}</span>
                </div>
              )
            })}
          </div>
        </div>

        <div className="bg-white p-5 rounded-2xl shadow-card">
          <h3 className="text-sm font-black text-gray-900 uppercase tracking-wider mb-4">{getGeoMetricLabel(geoMetric, geoSummary)} by Location</h3>
          <div className="space-y-3 max-h-56 overflow-y-auto pr-1">
            {geoMetric === 'admins' ? (
              adminLocations.map((row, index) => (
                <div key={`${row.city}-total-${index}`} className="flex items-center justify-between border-b border-gray-100 pb-2 last:border-0">
                  <span className="text-xs font-bold text-gray-600">{row.city}</span>
                  <span className="text-xs font-black text-gray-400 capitalize">{row.status}</span>
                </div>
              ))
            ) : geoMetric === 'publishers' ? (
              publisherLocations.map((row, index) => (
                <div key={`${row.city}-total-${index}`} className="flex items-center justify-between border-b border-gray-100 pb-2 last:border-0">
                  <span className="text-xs font-bold text-gray-600">{row.city}</span>
                  <span className="text-xs font-black text-gray-400 capitalize">{row.status}</span>
                </div>
              ))
            ) : geoMetric === 'transactions' ? (
              transactionLocations.map((row, index) => (
                <div key={`${row.city}-total-${index}`} className="flex items-center justify-between border-b border-gray-100 pb-2 last:border-0">
                  <span className="text-xs font-bold text-gray-600">{row.city}</span>
                  <span className="text-xs font-black text-gray-900">{row.transactions} TXN(s)</span>
                </div>
              ))
            ) : (
              visibleData.locationRows.filter(row => getGeoMetricValue(row, geoMetric, geoSummary) > 0).map((row, index) => (
                <div key={`${row.city}-total-${index}`} className="flex items-center justify-between border-b border-gray-100 pb-2 last:border-0">
                  <span className="text-xs font-bold text-gray-600">{row.city}</span>
                  <span className="text-sm font-black text-gray-900">{formatNumber(getGeoMetricValue(row, geoMetric, geoSummary))}</span>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  )

  const renderAdminLevel = () => (
    <div className="space-y-6">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white rounded-2xl shadow-card overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100">
            <h3 className="text-lg font-bold text-gray-900">Creator Leaderboard</h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Rank</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Creator Name</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Campaigns</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Active</th>
                  <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Locations</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {visibleData.creatorRows.map((row, idx) => (
                  <tr key={`${row.name}-${idx}`} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-4">
                      <span className={`w-6 h-6 flex items-center justify-center rounded-full text-xs font-bold ${idx === 0 ? 'bg-yellow-100 text-yellow-700'
                        : idx === 1 ? 'bg-gray-100 text-gray-600'
                          : idx === 2 ? 'bg-orange-100 text-orange-700' : 'bg-transparent text-gray-400'
                        }`}>
                        {row.rank}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-sm font-semibold text-gray-900">{row.name}</td>
                    <td className="px-6 py-4 text-sm text-gray-600">{row.campaigns}</td>
                    <td className="px-6 py-4 text-sm font-bold text-indigo-600">{row.activeCampaigns}</td>
                    <td className="px-6 py-4 text-sm font-bold text-gray-900">{row.targetedLocations}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Campaigns per Creator</h3>
          <div className="h-[400px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={visibleData.campaignsPerCreator}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis dataKey="name" fontSize={10} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip />
                <Bar dataKey="value" fill="#10B981" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  )

  const renderPublisherLevel = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-2xl shadow-card overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-100">
          <h3 className="text-lg font-bold text-gray-900">Publisher Reach Against Targeted Campaigns</h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Publisher</th>
                <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Last Known Location</th>
                <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Nearby Campaigns</th>
                <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Active Nearby</th>
                <th className="px-6 py-3 text-xs font-bold text-gray-400 uppercase">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {visibleData.publisherRows.map((row, idx) => (
                <tr key={`${row.name}-${idx}`} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4 text-sm font-semibold text-gray-900">{row.name}</td>
                  <td className="px-6 py-4 text-sm text-gray-600">{row.location}</td>
                  <td className="px-6 py-4 text-sm text-gray-600">{row.campaignsNearby}</td>
                  <td className="px-6 py-4 text-sm font-bold text-gray-900">{row.activeCampaignsNearby}</td>
                  <td className="px-6 py-4"><StatusBadge status={row.status} /></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )

  const renderTimeBased = () => (
    <div className="space-y-6">
      <div className="bg-white p-6 rounded-2xl shadow-card">
        <h3 className="text-lg font-bold text-gray-900 mb-6">Monthly Publishing Trend</h3>
        <div className="h-[300px]">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={visibleData.monthlyTrend}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
              <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
              <YAxis fontSize={12} tickLine={false} axisLine={false} />
              <Tooltip />
              <Line type="monotone" dataKey="value" stroke="#FF6B00" strokeWidth={3} dot={false} activeDot={{ r: 6, fill: '#FF6B00', stroke: '#fff' }} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-2xl shadow-card">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-bold text-gray-900">Weekly Campaign Creation</h3>
            <div className="flex bg-gray-100 p-1 rounded-xl">
              <button className="px-3 py-1.5 text-xs font-bold rounded-lg bg-white shadow-sm transition-all">Weekly</button>
            </div>
          </div>
          <div className="h-[300px]">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={visibleData.weeklyTrend}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip />
                <Line type="monotone" dataKey="value" stroke="#3B82F6" strokeWidth={2} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-card">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Duration vs Average Radius</h3>
          <div className="h-[300px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={visibleData.durationBreakdown}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
                <XAxis dataKey="name" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip />
                <Bar dataKey="value" fill="#8B5CF6" radius={[4, 4, 0, 0]} name="Avg radius (km)" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  )

  return (
    <div className="pb-10">
      <PageHeader
        title="Analytics & Reporting"
        subtitle="Live campaign publishing analytics from Keliri data"
        actions={(
          <div className="relative group">
            <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-all">
              <Download size={16} className="text-primary-500" />
              Export
              <ChevronDown size={14} className="text-gray-400" />
            </button>
            <div className="absolute right-0 mt-2 w-48 bg-white border border-gray-100 rounded-2xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all z-50 overflow-hidden">
              <button onClick={handleExportCSV} className="w-full text-left px-4 py-3 text-sm hover:bg-gray-50 transition-colors font-medium border-b border-gray-50">Export to CSV</button>
              <button onClick={handleExport} className="w-full text-left px-4 py-3 text-sm hover:bg-gray-50 transition-colors font-medium">Print / Save PDF</button>
            </div>
          </div>
        )}
      />

      {(loading || error) && (
        <div className="bg-white border-b border-gray-100 -mx-6 px-6 py-4 mb-8 flex flex-wrap items-center gap-4 shadow-sm overflow-x-auto no-scrollbar">
          {loading && (
            <div className="text-xs font-bold text-gray-500 uppercase tracking-wider">
              Loading analytics...
            </div>
          )}

          {error && (
            <div className="text-xs font-bold text-red-500 uppercase tracking-wider">{error}</div>
          )}
        </div>
      )}

      <div className="flex items-center justify-between mb-8 flex-wrap gap-4">
        <div className="flex items-center gap-1 bg-gray-100/50 p-1 rounded-2xl w-fit">
          {TABS.map((tab) => {
            const Icon = tab.icon
            const isActive = activeTab === tab.id
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-bold transition-all ${isActive ? 'bg-white text-primary-600 shadow-sm' : 'text-gray-500 hover:text-gray-900'
                  }`}
              >
                <Icon size={16} />
                {tab.label}
              </button>
            )
          })}
        </div>

        {activeTab === 'graphical' && (
          <div className="relative">
            <button
              onClick={() => setIsYearDropdownOpen(!isYearDropdownOpen)}
              className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-semibold text-gray-700 hover:bg-gray-50 hover:border-gray-300 transition-all shadow-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20"
            >
              <Calendar size={15} className="text-primary-500" />
              <span>Year: {selectedYear}</span>
              <ChevronDown size={14} className={`text-gray-400 transition-transform ${isYearDropdownOpen ? 'rotate-180' : ''}`} />
            </button>

            {isYearDropdownOpen && (
              <>
                <div
                  className="fixed inset-0 z-40"
                  onClick={() => setIsYearDropdownOpen(false)}
                />
                <div className="absolute right-0 mt-2 w-32 bg-white border border-gray-100 rounded-2xl shadow-xl z-50 overflow-hidden py-1 animate-fade-in">
                  {availableYears.map((yr) => (
                    <button
                      key={yr}
                      onClick={() => {
                        setSelectedYear(yr)
                        setIsYearDropdownOpen(false)
                      }}
                      className={`w-full text-left px-4 py-2.5 text-xs font-bold transition-colors ${selectedYear === yr
                        ? 'bg-primary-50 text-primary-600'
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                        }`}
                    >
                      {yr}
                    </button>
                  ))}
                </div>
              </>
            )}
          </div>
        )}
      </div>


      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {Array.from({ length: 6 }).map((_, index) => (
            <div key={index} className="bg-white rounded-2xl shadow-card h-40 animate-pulse" />
          ))}
        </div>
      ) : (
        <div className="animate-fade-in">
          {activeTab === 'ad-performance' && renderAdPerformance()}
          {activeTab === 'geo-based' && renderGeoBased()}
          {activeTab === 'graphical' && renderGraphicalRepresentation()}
        </div>
      )}
    </div>
  )
}

export default Analytics
