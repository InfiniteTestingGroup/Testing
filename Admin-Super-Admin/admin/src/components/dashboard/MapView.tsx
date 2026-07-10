import * as React from "react"
import { motion, AnimatePresence } from "framer-motion"
import { GoogleMap, useJsApiLoader, InfoWindow } from "@react-google-maps/api"
import { X, MapPin, Loader2, Map as MapIcon, Eye } from "lucide-react"
import { GOOGLE_MAPS_API_KEY, AD_TYPE_UIDS } from "../../config/constants"
import { adMobileApi } from "../../services/api"

type AdFilter = "all" | "image" | "video" | "banner"

interface AdLocation {
    uid: string
    title: string
    adType: "Image Ad" | "Video" | "Banner"
    lat: number
    lng: number
    locationName?: string
    publishDate?: string
    thumbnail?: string
    status: string
}

interface MapViewProps {
    isOpen: boolean
    onClose: () => void
    companyUID?: string
    embedded?: boolean
}

const AD_TYPE_UID_TO_NAME: Record<string, AdLocation["adType"]> = {
    [AD_TYPE_UIDS["Image Ad"]]: "Image Ad",
    [AD_TYPE_UIDS["Video"]]: "Video",
    [AD_TYPE_UIDS["Banner"]]: "Banner",
}

function getAdTypeName(adTypeUid: string): AdLocation["adType"] {
    return AD_TYPE_UID_TO_NAME[adTypeUid] ?? "Image Ad"
}

const filterConfig: { key: AdFilter; label: string; color: string; dot: string }[] = [
    { key: "all", label: "All", color: "bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-200 border-gray-200 dark:border-gray-700", dot: "bg-gray-500" },
    { key: "image", label: "Image", color: "bg-blue-50 dark:bg-blue-500/10 text-blue-700 dark:text-blue-300 border-blue-200 dark:border-blue-800", dot: "bg-blue-500" },
    { key: "video", label: "Video", color: "bg-orange-50 dark:bg-orange-500/10 text-orange-700 dark:text-orange-300 border-orange-200 dark:border-orange-800", dot: "bg-orange-500" },
    { key: "banner", label: "Banner", color: "bg-purple-50 dark:bg-purple-500/10 text-purple-700 dark:text-purple-300 border-purple-200 dark:border-purple-800", dot: "bg-purple-500" },
]

const mapContainerStyle = { width: "100%", height: "100%" }
const mapOptions: google.maps.MapOptions = {
    disableDefaultUI: false,
    zoomControl: true,
    streetViewControl: false,
    mapTypeControl: false,
    fullscreenControl: false,
    mapId: "DEMO_MAP_ID",
    styles: [
        { featureType: "poi", elementType: "labels", stylers: [{ visibility: "off" }] },
        { featureType: "transit", elementType: "labels", stylers: [{ visibility: "off" }] },
    ],
}
const mapLibraries: ("maps" | "marker" | "places")[] = ["maps", "marker", "places"]

// India center with zoom that shows entire country
const INDIA_CENTER = { lat: 20.5937, lng: 78.9629 }
const INDIA_ZOOM = 4

function AdvancedMarker({ map, position, title, onClick, children }: {
    map: google.maps.Map | null
    position: google.maps.LatLngLiteral
    title?: string
    onClick?: () => void
    children?: React.ReactNode
}) {
    const containerRef = React.useRef<HTMLDivElement | null>(null)

    React.useEffect(() => {
        if (!map || !window.google?.maps?.marker?.AdvancedMarkerElement) return
        const contentEl = containerRef.current || undefined
        const marker = new google.maps.marker.AdvancedMarkerElement({ map, position, title, content: contentEl })
        let listener: google.maps.MapsEventListener | null = null
        if (onClick) listener = marker.addListener("click", onClick)
        return () => { if (listener) listener.remove(); marker.map = null }
    }, [map, position, title, onClick])

    if (children) return <div ref={containerRef} style={{ display: "contents" }}>{children}</div>
    return null
}

function MapContent({ ads, filter, selectedAd, onMarkerClick, onInfoClose }: {
    ads: AdLocation[]
    filter: AdFilter
    selectedAd: AdLocation | null
    onMarkerClick: (ad: AdLocation) => void
    onInfoClose: () => void
}) {
    const filtered = filter === "all" ? ads : ads.filter((a) => {
        if (filter === "image") return a.adType === "Image Ad"
        if (filter === "video") return a.adType === "Video"
        if (filter === "banner") return a.adType === "Banner"
        return true
    })

    const [map, setMap] = React.useState<google.maps.Map | null>(null)
    const [userInteracted, setUserInteracted] = React.useState(false)

    // Track all user interactions (click, drag, zoom)
    React.useEffect(() => {
        if (!map || userInteracted) return

        const handleInteraction = () => setUserInteracted(true)

        const clickListener = map.addListener('click', handleInteraction)
        const dragListener = map.addListener('dragstart', handleInteraction)
        const zoomListener = map.addListener('zoom_changed', handleInteraction)

        return () => {
            clickListener.remove()
            dragListener.remove()
            zoomListener.remove()
        }
    }, [map, userInteracted])

    // After user interacts, center/zoom to ads if there are any
    React.useEffect(() => {
        if (!map || !userInteracted) return
        if (filtered.length === 0) return

        if (filtered.length === 1) {
            map.setCenter({ lat: filtered[0].lat, lng: filtered[0].lng })
            map.setZoom(13)
            return
        }

        const bounds = new google.maps.LatLngBounds()
        filtered.forEach((a) => bounds.extend({ lat: a.lat, lng: a.lng }))
        map.fitBounds(bounds, { top: 60, right: 320, bottom: 60, left: 60 })
    }, [map, filtered, userInteracted])

    return (
        <GoogleMap
            mapContainerStyle={mapContainerStyle}
            center={INDIA_CENTER}
            zoom={INDIA_ZOOM}
            options={mapOptions}
            onLoad={setMap}
        >
            {filtered.map((ad) => {
                const isSelected = selectedAd?.uid === ad.uid
                const colors: Record<AdLocation["adType"], { fill: string; stroke: string }> = {
                    "Image Ad": { fill: "#3b82f6", stroke: "#1d4ed8" },
                    Video: { fill: "#f97316", stroke: "#c2410c" },
                    Banner: { fill: "#8b5cf6", stroke: "#6d28d9" },
                }
                const c = colors[ad.adType]
                return (
                    <AdvancedMarker key={ad.uid} map={map} position={{ lat: ad.lat, lng: ad.lng }} title={ad.title} onClick={() => onMarkerClick(ad)}>
                        <div style={{
                            width: isSelected ? "28px" : "20px", height: isSelected ? "28px" : "20px",
                            borderRadius: "50%", backgroundColor: c.fill, border: `2.5px solid ${isSelected ? "#ffffff" : c.stroke}`,
                            boxShadow: isSelected ? "0 4px 6px -1px rgba(0,0,0,0.1), 0 0 0 3px rgba(59, 130, 246, 0.5)" : "0 1px 3px 0 rgba(0,0,0,0.1)",
                            cursor: "pointer", transition: "all 0.2s cubic-bezier(0.4, 0, 0.2, 1)",
                        }} />
                    </AdvancedMarker>
                )
            })}
            {selectedAd && (
                <InfoWindow position={{ lat: selectedAd.lat, lng: selectedAd.lng }} onCloseClick={onInfoClose} options={{ pixelOffset: new google.maps.Size(0, -12) }}>
                    <InfoCard ad={selectedAd} />
                </InfoWindow>
            )}
        </GoogleMap>
    )
}

function InfoCard({ ad }: { ad: AdLocation }) {
    const typeColors: Record<AdLocation["adType"], string> = { "Image Ad": "#3b82f6", Video: "#f97316", Banner: "#8b5cf6" }
    const hasValidThumbnail = ad.thumbnail && typeof ad.thumbnail === 'string' && ad.thumbnail.startsWith('http');
    return (
        <div style={{ fontFamily: "system-ui, sans-serif", width: 220, padding: 4 }}>
            {hasValidThumbnail ? (
                <div style={{ width: "100%", height: 110, borderRadius: 8, overflow: "hidden", marginBottom: 10, boxShadow: "0 1px 3px rgba(0,0,0,0.1)" }}>
                    <img src={ad.thumbnail} alt={ad.title} style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                </div>
            ) : (
                <div style={{ width: "100%", height: 60, borderRadius: 8, marginBottom: 10, background: "linear-gradient(135deg, #f3f4f6, #e5e7eb)", display: "flex", alignItems: "center", justifyContent: "center" }}>
                    <Eye size={20} color="#9ca3af" />
                </div>
            )}
            <p style={{ margin: "0 0 6px", fontWeight: 700, fontSize: 14, color: "#111827", lineHeight: 1.3 }}>{ad.title}</p>
            <span style={{ display: "inline-block", padding: "2px 8px", borderRadius: 9999, fontSize: 10, fontWeight: 700, color: "#fff", backgroundColor: typeColors[ad.adType], marginBottom: 8, textTransform: "uppercase", letterSpacing: "0.5px" }}>
                {ad.adType}
            </span>
            {ad.locationName && <p style={{ margin: "0 0 4px", fontSize: 11, color: "#4b5563", display: "flex", alignItems: "center", gap: "4px" }}><span>📍</span> {ad.locationName}</p>}
            {ad.publishDate && <p style={{ margin: 0, fontSize: 10, color: "#9ca3af", display: "flex", alignItems: "center", gap: "4px" }}><span>📅</span> {new Date(ad.publishDate).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}</p>}
        </div>
    )
}

export function MapView({ isOpen, onClose, companyUID, embedded = false }: MapViewProps) {
    const [ads, setAds] = React.useState<AdLocation[]>([])
    const [loading, setLoading] = React.useState(false)
    const [filter, setFilter] = React.useState<AdFilter>("all")
    const [selectedAd, setSelectedAd] = React.useState<AdLocation | null>(null)

    const { isLoaded, loadError } = useJsApiLoader({ id: "google-map-script", googleMapsApiKey: GOOGLE_MAPS_API_KEY, libraries: mapLibraries })

    React.useEffect(() => {
        if (!isOpen && !embedded) return

        const fetchAds = async () => {
            setLoading(true)
            try {
                const params: any = { page: 1, limit: 500 }
                if (companyUID) params.companyUID = companyUID
                const res = await adMobileApi.get("/v1/advertisements", { params })
                const rawAds: any[] = res.data?.data || []
                console.log("🔍 [MapView] rawAds count:", rawAds.length, "companyUID:", companyUID);
                const filtered = companyUID ? rawAds.filter((ad) => String(ad.company?._id || ad.company || ad.companyId) === String(companyUID)) : rawAds
                console.log("🔍 [MapView] filtered ads count:", filtered.length);

                let campaignMap: Record<string, { lat: number; lng: number; locationName?: string }> = {}
                try {
                    const campRes = await adMobileApi.get("/v1/ad-campaigns", { params: { page: 1, limit: 500, ...(companyUID ? { companyUID } : {}) } })
                    const rawCampaigns: any[] = campRes.data?.data || []
                    console.log("🔍 [MapView] rawCampaigns count:", rawCampaigns.length);
                    rawCampaigns.forEach((c: any) => {
                        const rawAdId = c.advertisementId;
                        const status = (c.compaignsStatus || '').toUpperCase();
                        if (status !== 'ACTIVE') return;

                        if (rawAdId && typeof rawAdId === 'object') {
                            if (rawAdId.uid && c.location?.lat && c.location?.lng) {
                                campaignMap[String(rawAdId.uid)] = { lat: parseFloat(c.location.lat), lng: parseFloat(c.location.lng), locationName: c.location.locationName }
                            }
                            if (rawAdId._id && c.location?.lat && c.location?.lng) {
                                campaignMap[String(rawAdId._id)] = { lat: parseFloat(c.location.lat), lng: parseFloat(c.location.lng), locationName: c.location.locationName }
                            }
                        } else if (rawAdId && c.location?.lat && c.location?.lng) {
                            campaignMap[String(rawAdId)] = { lat: parseFloat(c.location.lat), lng: parseFloat(c.location.lng), locationName: c.location.locationName }
                        }
                    })
                    console.log("🔍 [MapView] campaignMap size:", Object.keys(campaignMap).length);
                } catch (e: any) {
                    console.error("🔍 [MapView] error fetching campaigns:", e.message);
                }

                // Resolve thumbnails in batch
                const resolvedMediaMap = new Map<string, string>();
                const uidsToResolve = filtered
                    .map((ad: any) => {
                        const thumb = ad.thumbnail;
                        if (!thumb) return null;
                        if (typeof thumb === 'string' && !thumb.startsWith('http')) return thumb;
                        if (typeof thumb === 'object' && thumb.uid && !thumb.url) return thumb.uid;
                        return null;
                    })
                    .filter((uid): uid is string => !!uid);

                if (uidsToResolve.length > 0) {
                    try {
                        const mediaUrlsRes = await adMobileApi.post('/v1/media/uids', { medias: uidsToResolve });
                        const resolvedUrls = mediaUrlsRes.data?.data || mediaUrlsRes.data;
                        if (Array.isArray(resolvedUrls)) {
                            resolvedUrls.forEach((m: any) => {
                                if (m && (m.uid || m._id)) {
                                    resolvedMediaMap.set(String(m.uid || m._id), m.url || m.s3Location || m);
                                }
                            });
                        }
                    } catch (err) {
                        console.warn("Failed to resolve thumbnail UIDs in MapView:", err);
                    }
                }

                const locations: AdLocation[] = []
                filtered.forEach((ad: any) => {
                    let lat = ad.latitude ?? ad.lat ?? ad.location?.lat
                    let lng = ad.longitude ?? ad.lng ?? ad.location?.lng
                    let locationName = ad.locationName ?? ad.location?.locationName
                    
                    const c = campaignMap[String(ad.uid)] || (ad._id ? campaignMap[String(ad._id)] : null) || (ad.id ? campaignMap[String(ad.id)] : null);
                    if ((!lat || !lng) && c) { 
                        lat = c.lat; 
                        lng = c.lng; 
                        locationName = locationName || c.locationName 
                    }
                    
                    let thumbnailUrl = undefined;
                    if (ad.thumbnail) {
                        if (typeof ad.thumbnail === 'string') {
                            thumbnailUrl = ad.thumbnail.startsWith('http') ? ad.thumbnail : (resolvedMediaMap.get(ad.thumbnail) || undefined);
                        } else if (typeof ad.thumbnail === 'object') {
                            thumbnailUrl = ad.thumbnail.url || ad.thumbnail.s3Location || (ad.thumbnail.uid ? resolvedMediaMap.get(String(ad.thumbnail.uid)) : undefined);
                        }
                    }

                    console.log(`🔍 [MapView] Ad: "${ad.title}", uid: "${ad.uid}", _id: "${ad._id}", lat: ${lat}, lng: ${lng}, campaignFound: ${!!c}`);
                    if (!lat || !lng) return
                    locations.push({ uid: ad.uid, title: ad.title || "Untitled Ad", adType: getAdTypeName(ad.adType), lat: parseFloat(String(lat)), lng: parseFloat(String(lng)), locationName, publishDate: ad.startDate || ad.createdAt, thumbnail: thumbnailUrl, status: ad.status || "DRAFT" })
                })
                console.log("🔍 [MapView] final locations to render count:", locations.length);
                setAds(locations)
            } catch (err: any) {
                console.error("MapView: failed to fetch ads", err)
                setAds([])
            } finally {
                setLoading(false)
            }
        }
        fetchAds()
    }, [isOpen, companyUID, embedded])

    React.useEffect(() => { if (!isOpen && !embedded) { setAds([]); setFilter("all"); setSelectedAd(null) } }, [isOpen, embedded])

    const filteredCount = filter === "all" ? ads.length : ads.filter((a) => { if (filter === "image") return a.adType === "Image Ad"; if (filter === "video") return a.adType === "Video"; if (filter === "banner") return a.adType === "Banner"; return false }).length

    // ── Embedded Mode ──────────────────────────────────────────────────────────
    if (embedded) {
        return (
            <div className="w-full h-full flex flex-col bg-white dark:bg-[#0E1117] rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-700">
                {/* Header - Compact */}
                <div className="flex items-center justify-between px-4 py-2.5 border-b border-gray-100 dark:border-gray-800 flex-shrink-0 bg-gray-50/50 dark:bg-[#1C1F26]">
                    <div className="flex items-center gap-2">
                        <div className="p-1.5 bg-brand-50 dark:bg-brand-500/10 rounded-lg">
                            <MapPin className="w-4 h-4 text-brand-600 dark:text-brand-400" />
                        </div>
                        <div>
                            <h3 className="text-sm font-semibold text-gray-900 dark:text-white">Ad Locations</h3>
                        </div>
                    </div>
                    <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-500 dark:text-gray-400 font-medium">{filteredCount} locations</span>
                        {/* Quick filter pills */}
                        <div className="flex items-center gap-1 bg-white dark:bg-[#0E1117] rounded-lg p-0.5 border border-gray-200 dark:border-gray-700">
                            {filterConfig.map((f) => {
                                const count = f.key === "all" ? ads.length : ads.filter((a) => { if (f.key === "image") return a.adType === "Image Ad"; if (f.key === "video") return a.adType === "Video"; if (f.key === "banner") return a.adType === "Banner"; return false }).length
                                const isActive = filter === f.key
                                return (
                                    <button key={f.key} onClick={() => { setFilter(f.key); setSelectedAd(null) }} className={`px-2 py-1 text-[10px] font-medium rounded-md transition-all ${isActive ? 'bg-brand-100 text-brand-700 dark:bg-brand-500/20 dark:text-brand-400' : 'text-gray-500 hover:text-gray-700 dark:text-gray-400'}`}>
                                        {f.label} {count}
                                    </button>
                                )
                            })}
                        </div>
                    </div>
                </div>

                {/* Map Area */}
                <div className="flex-1 relative">
                    {(loading || !isLoaded) && !loadError && (
                        <div className="absolute inset-0 z-10 flex items-center justify-center bg-gray-50 dark:bg-[#1C1F26]">
                            <Loader2 className="w-6 h-6 text-brand-500 animate-spin" />
                        </div>
                    )}
                    {isLoaded && !loadError && !loading && (
                        <MapContent ads={ads} filter={filter} selectedAd={selectedAd} onMarkerClick={setSelectedAd} onInfoClose={() => setSelectedAd(null)} />
                    )}
                    {loadError && (
                        <div className="absolute inset-0 z-10 flex flex-col items-center justify-center bg-gray-50 dark:bg-[#1C1F26]">
                            <MapIcon className="w-8 h-8 text-red-400 mb-2" />
                            <p className="text-xs font-semibold text-red-500">Maps failed to load</p>
                        </div>
                    )}
                </div>

                {/* Footer Legend - Subtle */}
                <div className="flex items-center gap-4 px-4 py-2 border-t border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-[#1C1F26] flex-shrink-0">
                    <div className="flex items-center gap-1.5">
                        <div className="w-2.5 h-2.5 rounded-full bg-blue-500" />
                        <span className="text-[10px] text-gray-500 dark:text-gray-400">Image</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                        <div className="w-2.5 h-2.5 rounded-full bg-orange-500" />
                        <span className="text-[10px] text-gray-500 dark:text-gray-400">Video</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                        <div className="w-2.5 h-2.5 rounded-full bg-purple-500" />
                        <span className="text-[10px] text-gray-500 dark:text-gray-400">Banner</span>
                    </div>
                </div>
            </div>
        )
    }

    // ── Modal Mode ─────────────────────────────────────────────────────────────
    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} transition={{ duration: 0.2 }} className="fixed inset-0 bg-black/60 backdrop-blur-sm z-40" onClick={onClose} />
                    <motion.div initial={{ opacity: 0, scale: 0.96, y: 16 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.96, y: 16 }} transition={{ duration: 0.25, ease: [0.16, 1, 0.3, 1] }} className="fixed inset-4 md:inset-6 lg:inset-8 z-50 flex flex-col rounded-2xl overflow-hidden shadow-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-[#0E1117]">
                        {/* Header */}
                        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 dark:border-gray-800 bg-white dark:bg-[#0E1117] flex-shrink-0">
                            <div className="flex items-center gap-3">
                                <div className="p-2 bg-brand-50 dark:bg-brand-500/10 rounded-xl">
                                    <MapPin className="w-5 h-5 text-brand-600 dark:text-brand-400" />
                                </div>
                                <div>
                                    <h2 className="text-base font-bold text-gray-900 dark:text-white">Ad Locations Map</h2>
                                    <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{loading ? "Loading…" : `${filteredCount} location${filteredCount !== 1 ? "s" : ""} shown`}</p>
                                </div>
                            </div>
                            <button onClick={onClose} className="p-2 rounded-xl text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        {/* Body */}
                        <div className="flex flex-1 min-h-0 relative">
                            <div className="flex-1 relative">
                                {(loading || !isLoaded) && !loadError && (
                                    <div className="absolute inset-0 z-10 flex flex-col items-center justify-center bg-gray-50 dark:bg-[#1C1F26]">
                                        <Loader2 className="w-8 h-8 text-brand-500 animate-spin mb-3" />
                                        <p className="text-sm font-medium text-gray-600 dark:text-gray-300">{!isLoaded ? "Loading Google Maps…" : "Fetching ad locations…"}</p>
                                    </div>
                                )}
                                {isLoaded && !loadError && !loading && (
                                    <MapContent ads={ads} filter={filter} selectedAd={selectedAd} onMarkerClick={setSelectedAd} onInfoClose={() => setSelectedAd(null)} />
                                )}
                                {loadError && (
                                    <div className="absolute inset-0 z-10 flex flex-col items-center justify-center bg-gray-50 dark:bg-[#1C1F26]">
                                        <MapIcon className="w-10 h-10 text-red-400 mb-3" />
                                        <p className="text-sm font-semibold text-red-500">Google Maps failed to load</p>
                                        <p className="text-xs text-gray-400 mt-1">Check your API key configuration</p>
                                    </div>
                                )}
                            </div>

                            {/* Right Filter Panel */}
                            <div className="w-52 flex-shrink-0 border-l border-gray-100 dark:border-gray-800 bg-white dark:bg-[#0E1117] flex flex-col">
                                <div className="px-4 pt-4 pb-3">
                                    <p className="text-[11px] font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3">Filter by Type</p>
                                    <div className="flex flex-col gap-2">
                                        {filterConfig.map((f) => {
                                            const count = f.key === "all" ? ads.length : ads.filter((a) => { if (f.key === "image") return a.adType === "Image Ad"; if (f.key === "video") return a.adType === "Video"; if (f.key === "banner") return a.adType === "Banner"; return false }).length
                                            const isActive = filter === f.key
                                            return (
                                                <button key={f.key} onClick={() => { setFilter(f.key); setSelectedAd(null) }} className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-all text-left ${isActive ? f.color + " shadow-sm" : "bg-transparent border-transparent text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800/50"}`}>
                                                    <span className={`w-2 h-2 rounded-full flex-shrink-0 ${f.dot} ${!isActive ? "opacity-50" : ""}`} />
                                                    <span className="flex-1 truncate">{f.label}</span>
                                                    <span className={`text-xs font-semibold px-1.5 py-0.5 rounded-md ${isActive ? "bg-white/40 dark:bg-black/20" : "bg-gray-100 dark:bg-gray-800 text-gray-400"}`}>{count}</span>
                                                </button>
                                            )
                                        })}
                                    </div>
                                </div>

                                <div className="mt-auto px-4 pb-4 pt-3 border-t border-gray-100 dark:border-gray-800">
                                    <p className="text-[11px] font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-2.5">Legend</p>
                                    <div className="flex flex-col gap-1.5">
                                        {[{ label: "Image Ad", color: "bg-blue-500" }, { label: "Video Ad", color: "bg-orange-500" }, { label: "Banner Ad", color: "bg-purple-500" }].map((l) => (
                                            <div key={l.label} className="flex items-center gap-2">
                                                <div className={`w-3 h-3 rounded-full ${l.color} flex-shrink-0`} />
                                                <span className="text-xs text-gray-500 dark:text-gray-400">{l.label}</span>
                                            </div>
                                        ))}
                                    </div>
                                    <p className="text-[10px] text-gray-400 dark:text-gray-600 mt-3 leading-relaxed">Click any pin to see ad details</p>
                                </div>
                            </div>
                        </div>
                    </motion.div>
                </>
            )}
        </AnimatePresence>
    )
}