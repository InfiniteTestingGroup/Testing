import * as React from "react"
import { useFormContext } from "react-hook-form"
import { Crosshair, MapPin, Navigation, Map, Search, Loader2 } from "lucide-react"
import toast from "react-hot-toast"
import { GOOGLE_MAPS_API_KEY, MAPS_ENDPOINTS } from "../../config/constants"
import { GoogleMap, useJsApiLoader, Marker, Circle } from "@react-google-maps/api"

const mapContainerStyle = {
  width: "100%",
  height: "100%",
}

const LIBRARIES: ("maps" | "marker" | "places")[] = ["maps", "marker", "places"]

// ── Google Maps iframe — updates whenever lat/lng are valid ─────────────────
function GeoMapPreview({
  lat,
  lng,
  radiusKm,
  onMapClick,
}: {
  lat: number
  lng: number
  radiusKm: number
  onMapClick?: (lat: number, lng: number) => void
}) {
  // Check if Google Maps API key is available
  if (!GOOGLE_MAPS_API_KEY) {
    return (
      <div className="w-full aspect-video rounded-2xl bg-gray-100 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 flex flex-col items-center justify-center">
        <Map className="w-12 h-12 text-gray-400 mb-2" />
        <p className="text-sm text-gray-500 text-center">
          Google Maps is not configured
        </p>
        <p className="text-xs text-gray-400 text-center mt-1">
          Please set VITE_GOOGLE_MAPS_API_KEY in your environment
        </p>
      </div>
    )
  }

  const { isLoaded, loadError } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: LIBRARIES,
  })

  if (loadError) {
    return (
      <div className="w-full aspect-video rounded-2xl bg-gray-100 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 flex flex-col items-center justify-center">
        <Map className="w-12 h-12 text-red-400 mb-2" />
        <p className="text-sm text-red-500 text-center">
          Google Maps failed to load
        </p>
        <p className="text-xs text-gray-400 text-center mt-1">
          Please check your API key configuration
        </p>
      </div>
    )
  }

  const [currentLocation, setCurrentLocation] = React.useState<{ lat: number; lng: number } | null>(null)

  const isValid = lat !== 0 || lng !== 0
  const center = isValid
    ? { lat, lng }
    : { lat: 19.0760, lng: 72.8777 } // default Mumbai


  if (!isLoaded) {
    return (
      <div className="w-full aspect-video rounded-2xl bg-gray-100 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 flex items-center justify-center">
        <Loader2 className="w-8 h-8 text-brand-500 animate-spin" />
      </div>
    )
  }

  const zoom = radiusKm >= 20 ? 10 : radiusKm >= 10 ? 11 : radiusKm >= 5 ? 12 : radiusKm >= 2 ? 13 : 14

  return (
    <div className="relative w-full aspect-video rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-sm">
      <GoogleMap
        mapContainerStyle={mapContainerStyle}
        center={center}
        zoom={isValid ? zoom : 5}
        onClick={(e) => {
          if (e.latLng && onMapClick) {
            onMapClick(e.latLng.lat(), e.latLng.lng())
          }
        }}
        options={{
          disableDefaultUI: false,
          zoomControl: true,
          streetViewControl: false,
          mapTypeControl: false,
        }}
      >
        {isValid && (
          <>
            <Marker position={center} />
            <Circle
              center={center}
              radius={radiusKm * 1000}
              options={{
                fillColor: "#FF6B00",
                fillOpacity: 0.2,
                strokeColor: "#FF6B00",
                strokeOpacity: 0.8,
                strokeWeight: 2,
              }}
            />
          </>
        )}
      </GoogleMap>

      {/* Info badge */}
      {isValid && (
        <div className="absolute bottom-6 left-3 bg-white/90 dark:bg-[#1A1D24]/90 backdrop-blur-sm px-3 py-1.5 rounded-lg border border-gray-200 dark:border-gray-700 flex items-center gap-2 shadow-sm pointer-events-none">
          <div className="w-2 h-2 rounded-full bg-brand-500 animate-pulse" />
          <span className="text-[11px] font-semibold text-gray-600 dark:text-gray-300">
            {lat.toFixed(5)}, {lng.toFixed(5)} · {radiusKm} km radius
          </span>
        </div>
      )}
    </div>
  )
}

// ── Radius preset chips ─────────────────────────────────────────────────────
const RADIUS_PRESETS = [
  { label: "1.5 km", value: 1.5 },
  { label: "5 km", value: 5 },
  { label: "10 km", value: 10 },
  { label: "15 km", value: 15 },
  { label: "20 km", value: 20 },
]

export function TargetingStep() {
  const { register, watch, setValue, formState: { errors } } = useFormContext()

  const locationMode = watch("locationMode") as string
  const latitude = watch("latitude") as number
  const longitude = watch("longitude") as number
  const radius = watch("radius") as number

  // ── Place search via Google Places Autocomplete API ─────────────────────
  const [searchQuery, setSearchQuery] = React.useState("")
  const [suggestions, setSuggestions] = React.useState<{ placeId: string; description: string }[]>([])
  const [searching, setSearching] = React.useState(false)
  const searchDebounce = React.useRef<ReturnType<typeof setTimeout> | null>(null)

  const fetchPlaces = async (val: string) => {
    if (val.length < 2) {
      setSuggestions([])
      return
    }

    // Check if Google Maps API is available
    if (!GOOGLE_MAPS_API_KEY) {
      setSuggestions([])
      return
    }

    const url = MAPS_ENDPOINTS.placesAutocomplete(val)
    if (!url) {
      setSuggestions([])
      return
    }

    setSearching(true)
    try {
      // Note: direct browser fetch to Places API requires the key to have browser restrictions disabled
      // or use a serverside proxy. For now, this hits the API directly.
      const res = await fetch(url)
      const json = await res.json()
      if (json.predictions) {
        setSuggestions(json.predictions.slice(0, 5).map((p: any) => ({
          placeId: p.place_id,
          description: p.description,
        })))
      }
    } catch (err) {
      console.error("Failed to fetch places:", err)
      // Silently fail - user can still type location manually
      setSuggestions([])
    } finally {
      setSearching(false)
    }
  }

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value
    setSearchQuery(val)
    if (searchDebounce.current) clearTimeout(searchDebounce.current)
    searchDebounce.current = setTimeout(() => fetchPlaces(val), 400)
  }

  const handleSuggestionSelect = async (placeId: string, description: string) => {
    setSuggestions([])
    setSearchQuery(description)
    try {
      const url = MAPS_ENDPOINTS.placeDetails(placeId)
      if (!url) return
      const res = await fetch(url)
      const json = await res.json()
      const loc = json.result?.geometry?.location
      if (loc) {
        setValue("latitude", loc.lat, { shouldValidate: true })
        setValue("longitude", loc.lng, { shouldValidate: true })
        setValue("locationMode", "manual")
        toast.success("Location pinned from search")
      }
    } catch {
      toast.error("Could not fetch place details")
    }
  }

  // ── Auto-detect via browser geolocation ────────────────────────────────
  const handleAutoDetect = () => {
    if (!navigator.geolocation) {
      toast.error("Geolocation is not supported by your browser")
      return
    }
    const toastId = toast.loading("Detecting your location…")
    navigator.geolocation.getCurrentPosition(
      async (position) => {
        const { latitude: lat, longitude: lng } = position.coords
        setValue("latitude", lat, { shouldValidate: true })
        setValue("longitude", lng, { shouldValidate: true })
        setValue("locationMode", "auto")

        // Reverse geocode to get a friendly address
        try {
          const url = MAPS_ENDPOINTS.reverseGeocode(lat, lng)
          if (!url) return
          const res = await fetch(url)
          const json = await res.json()
          const address = json.results?.[0]?.formatted_address
          if (address) setSearchQuery(address)
        } catch { /* ignore */ }

        toast.success("Location pinpointed accurately", { id: toastId })
      },
      () => {
        toast.error("Failed to detect location. Please grant permissions.", { id: toastId })
        setValue("locationMode", "manual")
      },
      { enableHighAccuracy: true, timeout: 8000, maximumAge: 0 }
    )
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div>
        <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-1">Geo-Targeting</h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Set the epicenter and broadcast radius for this advertisement. The ad will be shown to users within this area.
        </p>
      </div>

      {/* ── Place Search ── */}
      <div className="relative">
        <label className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2 block flex items-center gap-2">
          <Search className="w-4 h-4 text-brand-500" /> Search Location
        </label>
        <div className="relative">
          <input
            type="text"
            value={searchQuery}
            onChange={handleSearchChange}
            placeholder="Search city, landmark, address…"
            className="w-full px-4 py-3 pr-10 rounded-xl border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:border-brand-500 focus:ring-brand-500/20 transition-colors"
          />
          {searching && (
            <Loader2 className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 animate-spin text-gray-400" />
          )}
        </div>

        {/* Suggestions dropdown */}
        {suggestions.length > 0 && (
          <div className="absolute top-full left-0 right-0 mt-1 z-50 bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-700 rounded-xl shadow-lg overflow-hidden">
            {suggestions.map((s) => (
              <button
                key={s.placeId}
                type="button"
                onClick={() => handleSuggestionSelect(s.placeId, s.description)}
                className="w-full text-left px-4 py-3 text-sm text-gray-800 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors flex items-center gap-3 border-b border-gray-100 dark:border-gray-800 last:border-b-0"
              >
                <MapPin className="w-3.5 h-3.5 text-brand-500 flex-shrink-0" />
                {s.description}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* ── Location Mode Toggle ── */}
      <div className="flex bg-gray-200 dark:bg-gray-800 p-1 rounded-xl w-fit">
        <label className={`cursor-pointer px-4 py-2 text-sm font-semibold rounded-lg transition-all flex items-center gap-2 ${locationMode === "manual" ? "bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white shadow-sm" : "text-gray-500 hover:text-gray-700 dark:text-gray-400"}`}>
          <input type="radio" value="manual" {...register("locationMode")} className="hidden" />
          <Map className="w-4 h-4" /> Manual Entry
        </label>
        <label className={`cursor-pointer px-4 py-2 text-sm font-semibold rounded-lg transition-all flex items-center gap-2 ${locationMode === "auto" ? "bg-white dark:bg-[#1A1D24] text-brand-600 dark:text-brand-400 shadow-sm" : "text-gray-500 hover:text-gray-700 dark:text-gray-400"}`}>
          <input
            type="radio"
            value="auto"
            {...register("locationMode")}
            className="hidden"
            onClick={() => { if (locationMode !== "auto") handleAutoDetect() }}
          />
          <Navigation className="w-4 h-4" /> Auto-Detect
        </label>
      </div>

      {/* ── Coordinates Row ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-6 rounded-2xl bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800">
        <div>
          <label className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2 block">Latitude</label>
          <div className="relative">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="number"
              step="any"
              disabled={locationMode === "auto"}
              {...register("latitude", { valueAsNumber: true })}
              placeholder="e.g. 19.0760"
              className={`w-full pl-9 pr-4 py-3 rounded-xl border bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-colors disabled:opacity-50 disabled:cursor-not-allowed ${errors.latitude
                ? "border-red-300 focus:border-red-500 focus:ring-red-500/20"
                : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
                }`}
            />
          </div>
          {errors.latitude && <p className="mt-1.5 text-xs text-red-500">{errors.latitude.message as string}</p>}
        </div>

        <div>
          <label className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2 block">Longitude</label>
          <div className="relative">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="number"
              step="any"
              disabled={locationMode === "auto"}
              {...register("longitude", { valueAsNumber: true })}
              placeholder="e.g. 72.8777"
              className={`w-full pl-9 pr-4 py-3 rounded-xl border bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-colors disabled:opacity-50 disabled:cursor-not-allowed ${errors.longitude
                ? "border-red-300 focus:border-red-500 focus:ring-red-500/20"
                : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
                }`}
            />
          </div>
          {errors.longitude && <p className="mt-1.5 text-xs text-red-500">{errors.longitude.message as string}</p>}
        </div>
      </div>

      {/* ── Live Map Preview ── */}
      <GeoMapPreview
        lat={latitude ?? 0}
        lng={longitude ?? 0}
        radiusKm={radius ?? 10}
        onMapClick={(clickedLat, clickedLng) => {
          setValue("latitude", clickedLat, { shouldValidate: true })
          setValue("longitude", clickedLng, { shouldValidate: true })
          setValue("locationMode", "manual")
        }}
      />

      {/* ── Radius ── */}
      <div className="p-6 rounded-2xl bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 space-y-4">
        <div className="flex items-center justify-between">
          <label className="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2">
            <Crosshair className="w-4 h-4 text-brand-500" />
            Broadcast Radius
          </label>
          <span className="text-brand-600 dark:text-brand-400 font-bold text-lg bg-brand-50 dark:bg-brand-500/10 px-3 py-1 rounded-lg">
            {radius ?? 10} km
          </span>
        </div>

        {/* Preset chips */}
        <div className="flex flex-wrap gap-2">
          {RADIUS_PRESETS.map((p) => (
            <button
              key={p.value}
              type="button"
              onClick={() => setValue("radius", p.value, { shouldValidate: true })}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all border ${radius === p.value
                ? "bg-brand-500 text-white border-brand-500 shadow-sm"
                : "bg-white dark:bg-[#1A1D24] text-gray-600 dark:text-gray-400 border-gray-200 dark:border-gray-700 hover:border-brand-400"
                }`}
            >
              {p.label}
            </button>
          ))}
        </div>

        {/* Slider */}
        <div className="pt-1">
          <input
            type="range"
            min="0.5"
            max="50"
            step="0.5"
            {...register("radius", { valueAsNumber: true })}
            className="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-lg appearance-none cursor-pointer accent-brand-500"
          />
          <div className="flex justify-between text-xs text-gray-400 mt-1 px-0.5">
            <span>0.5 km (Hyper-local)</span>
            <span>25 km (District)</span>
            <span>50 km (Region)</span>
          </div>
        </div>

        {errors.radius && <p className="text-xs text-red-500">{errors.radius.message as string}</p>}
      </div>

      {/* Info note */}
      <p className="text-xs text-gray-400 dark:text-gray-500 text-center">
        The radius is sent to the backend in metres: <span className="text-brand-500 font-semibold">{Math.round((radius ?? 10) * 1000)} m</span>.
        Campaign payload field: <code className="bg-gray-100 dark:bg-gray-800 px-1 rounded text-[11px]">location.range</code>
      </p>
    </div>
  )
}
