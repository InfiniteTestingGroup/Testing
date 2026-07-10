import * as React from "react"
import { useFormContext } from "react-hook-form"
import { CTASelector, type CTAType } from "./CTASelector"
import { CustomSectionsBuilder } from "./CustomSectionsBuilder"
import { Tag, Link as LinkIcon, Map as MapIcon, Info, Loader2 } from "lucide-react"
import { GoogleMap, useJsApiLoader, Marker } from "@react-google-maps/api"
import { GOOGLE_MAPS_API_KEY } from "../../config/constants"

const mapContainerStyle = { width: "100%", height: "100%" }
const LIBRARIES: ("maps" | "marker" | "places")[] = ["maps", "marker", "places"]

function parseCoords(raw: string): { lat: number; lng: number } | null {
  if (!raw?.trim()) return null
  const parts = raw.split(",").map((s) => s.trim())
  if (parts.length !== 2) return null
  const lat = parseFloat(parts[0])
  const lng = parseFloat(parts[1])
  if (isNaN(lat) || isNaN(lng)) return null
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null
  return { lat, lng }
}

function MapPreview({
  coordinatesRaw,
  onMapClick,
  isLoaded,
  loadError,
}: {
  coordinatesRaw: string
  onMapClick: (lat: number, lng: number) => void
  isLoaded: boolean
  loadError: Error | undefined
}) {
  const coords = parseCoords(coordinatesRaw)
  const [currentLocation, setCurrentLocation] = React.useState<{ lat: number; lng: number } | null>(null)

  React.useEffect(() => {
    if (!coords && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setCurrentLocation({ lat: position.coords.latitude, lng: position.coords.longitude })
        },
        (error) => console.error("Geolocation error", error),
        { enableHighAccuracy: true, timeout: 5000 }
      )
    }
  }, [])

  if (loadError) {
    return (
      <div className="relative border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden bg-gray-100 dark:bg-[#1C1F26] aspect-video flex flex-col items-center justify-center">
        <MapIcon className="w-12 h-12 text-red-400 mb-2" />
        <p className="text-sm text-red-500 text-center">Google Maps failed to load</p>
        <p className="text-xs text-gray-400 text-center mt-1">Please check your API key configuration</p>
      </div>
    )
  }

  if (!isLoaded) {
    return (
      <div className="relative border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden bg-gray-100 dark:bg-[#1C1F26] aspect-video flex items-center justify-center">
        <Loader2 className="w-8 h-8 text-brand-500 animate-spin" />
      </div>
    )
  }

  const center = coords || currentLocation || { lat: 19.076, lng: 72.8777 }

  return (
    <div className="relative border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden aspect-video shadow-sm">
      <GoogleMap
        mapContainerStyle={mapContainerStyle}
        center={center}
        zoom={coords ? 15 : 5}
        onClick={(e) => {
          if (e.latLng) onMapClick(e.latLng.lat(), e.latLng.lng())
        }}
        options={{ disableDefaultUI: false, zoomControl: true, streetViewControl: false, mapTypeControl: false }}
      >
        {coords && <Marker position={coords} />}
      </GoogleMap>

      {!coords && (
        <div className="absolute inset-0 pointer-events-none flex items-center justify-center z-10">
          <div className="bg-white/90 dark:bg-[#1A1D24]/90 backdrop-blur-sm px-5 py-3 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 text-center">
            <MapIcon className="w-6 h-6 text-brand-500 mx-auto mb-1.5" />
            <p className="text-sm font-bold text-gray-900 dark:text-white">Select Location</p>
            <p className="text-xs text-gray-500 mt-0.5">Click anywhere on the map to drop a pin</p>
          </div>
        </div>
      )}

      {coords && (
        <div className="absolute bottom-6 left-3 bg-white/90 dark:bg-[#1A1D24]/90 backdrop-blur-sm px-3 py-1.5 rounded-lg border border-gray-200 dark:border-gray-700 flex items-center gap-2 shadow-sm pointer-events-none z-10">
          <div className="w-2 h-2 rounded-full bg-brand-500 animate-pulse" />
          <span className="text-[11px] font-semibold text-gray-600 dark:text-gray-300">
            {coords.lat.toFixed(5)}, {coords.lng.toFixed(5)}
          </span>
        </div>
      )}
    </div>
  )
}

// ── Validation helpers ──────────────────────────────────────────────────────
function isValidPhone(value: string): boolean {
  return /^\d{10}$/.test(value)
}

function isValidEmail(value: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim())
}

function getInlineError(ctaType: CTAType, value: string): string | null {
  if (!value.trim()) return null // let RHF required handle empty
  switch (ctaType) {
    case "Dial":
    case "WhatsApp":
      return isValidPhone(value) ? null : "Enter a valid 10-digit phone number"
    case "Email":
      return isValidEmail(value) ? null : "Enter a valid email address"
    case "Redirect":
      try { new URL(value); return null } catch { return "Enter a valid URL (include https://)" }
    default:
      return null
  }
}

// ── Main component ──────────────────────────────────────────────────────────
export function AdFinalDetailsStep() {
  const { register, watch, setValue, formState: { errors } } = useFormContext()

  const ctaType = watch("ctaType") as CTAType
  const ctaActionValue = watch("ctaActionValue") as string

  // Track blur for inline validation
  const [actionTouched, setActionTouched] = React.useState(false)
  const inlineError = actionTouched ? getInlineError(ctaType, ctaActionValue) : null

  // Keep a ref so stale geolocation callbacks don't overwrite a newer type's value
  const expectedCtaType = React.useRef<CTAType>(ctaType)

  // Reset touched + stale-ref when CTA type changes
  React.useEffect(() => {
    setActionTouched(false)
    expectedCtaType.current = ctaType
  }, [ctaType])

  const { isLoaded, loadError } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: GOOGLE_MAPS_API_KEY || "",
    libraries: LIBRARIES,
  })

  const getActionLabel = () => {
    switch (ctaType) {
      case "Redirect": return "Website URL"
      case "Dial": return "Phone Number"
      case "WhatsApp": return "WhatsApp Number"
      case "Email": return "Email Address"
      case "Map": return "Map Location Coordinates (lat, lng)"
      default: return "Action Value"
    }
  }

  const getPlaceholder = () => {
    switch (ctaType) {
      case "Redirect": return "https://example.com"
      case "Dial":
      case "WhatsApp": return "e.g. 9876543210"
      case "Email": return "e.g. contact@business.com"
      case "Map": return "e.g. 19.0760, 72.8777"
      default: return ""
    }
  }

  const getInputMode = (): React.HTMLAttributes<HTMLInputElement>["inputMode"] => {
    if (ctaType === "Dial" || ctaType === "WhatsApp") return "numeric"
    if (ctaType === "Email") return "email"
    if (ctaType === "Redirect") return "url"
    return "text"
  }

  // Phone: allow digits only, max 10
  const handlePhoneKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    const allowed = ["Backspace", "Delete", "ArrowLeft", "ArrowRight", "Tab", "Home", "End"]
    if (allowed.includes(e.key)) return
    if (!/^\d$/.test(e.key)) e.preventDefault()
  }

  const handlePhoneChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const digits = e.target.value.replace(/\D/g, "").slice(0, 10)
    setValue("ctaActionValue", digits, { shouldValidate: true })
  }

  const rhfError = errors.ctaActionValue?.message as string | undefined
  const showError = inlineError || rhfError
  const hasError = !!showError

  return (
    <div className="space-y-10">
      <div className="space-y-4">
        <div>
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">Ad Details</h2>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Configure the Call-to-Action for this advertisement
          </p>
        </div>
      </div>

      <div className="h-px bg-gray-100 dark:bg-gray-800 w-full" />

      <div className="space-y-6">
        <div>
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">Call to Action (CTA)</h2>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Configure the main action button for your advertisement
          </p>
        </div>

        <CTASelector
          value={ctaType}
          onChange={(val) => {
            expectedCtaType.current = val
            setValue("ctaType", val, { shouldValidate: true })
            // Always clear the action value when switching type
            setValue("ctaActionValue", "", { shouldValidate: false })
            setActionTouched(false)

            if (val === "Map" && navigator.geolocation) {
              navigator.geolocation.getCurrentPosition(
                (position) => {
                  // Only apply if the user hasn't switched away again
                  if (expectedCtaType.current !== "Map") return
                  const lat = position.coords.latitude
                  const lng = position.coords.longitude
                  setValue("ctaActionValue", `${lat.toFixed(5)}, ${lng.toFixed(5)}`, { shouldValidate: true })
                },
                () => {
                  // geolocation denied — value already cleared above, nothing to do
                }
              )
            }
          }}
        />

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-6 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-2xl">
          {/* Button Label */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
              <Tag className="w-4 h-4 text-brand-500" />
              Button Label
            </label>
            <input
              {...register("ctaLabel")}
              placeholder="e.g. Shop Now, Contact Us..."
              className={`w-full px-4 py-3 rounded-xl border bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-all ${errors.ctaLabel
                  ? "border-red-300 focus:border-red-500 focus:ring-red-500/20"
                  : "border-gray-200 dark:border-gray-700 focus:border-brand-500 focus:ring-brand-500/20"
                }`}
            />
            {errors.ctaLabel && (
              <p className="mt-1.5 text-xs text-red-500 font-medium">{errors.ctaLabel.message as string}</p>
            )}
          </div>

          {/* Action Value — phone/email/url aware */}
          <div>
            <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
              <LinkIcon className="w-4 h-4 text-brand-500" />
              {getActionLabel()}
            </label>

            {ctaType === "Dial" || ctaType === "WhatsApp" ? (
              // Phone: fully controlled — digits only, max 10
              <input
                type="text"
                inputMode="numeric"
                value={ctaActionValue}
                placeholder={getPlaceholder()}
                maxLength={10}
                onKeyDown={handlePhoneKeyDown}
                onChange={handlePhoneChange}
                onBlur={() => setActionTouched(true)}
                className={`w-full px-4 py-3 rounded-xl border bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-all ${hasError
                    ? "border-red-300 focus:border-red-500 focus:ring-red-500/20"
                    : "border-gray-200 dark:border-gray-700 focus:border-brand-500 focus:ring-brand-500/20"
                  }`}
              />
            ) : (
              // Email / URL / Map: register-based with onBlur validation
              <input
                {...register("ctaActionValue")}
                type={ctaType === "Email" ? "email" : "text"}
                inputMode={getInputMode()}
                placeholder={getPlaceholder()}
                onBlur={() => setActionTouched(true)}
                className={`w-full px-4 py-3 rounded-xl border bg-white dark:bg-[#1A1D24] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-all ${hasError
                    ? "border-red-300 focus:border-red-500 focus:ring-red-500/20"
                    : "border-gray-200 dark:border-gray-700 focus:border-brand-500 focus:ring-brand-500/20"
                  }`}
              />
            )}

            {showError && (
              <p className="mt-1.5 text-xs text-red-500 font-medium">{showError}</p>
            )}
          </div>
        </div>

        {ctaType === "Map" && GOOGLE_MAPS_API_KEY && (
          <MapPreview
            coordinatesRaw={ctaActionValue}
            isLoaded={isLoaded}
            loadError={loadError}
            onMapClick={(lat, lng) => {
              setValue("ctaActionValue", `${lat.toFixed(5)}, ${lng.toFixed(5)}`, { shouldValidate: true })
            }}
          />
        )}

        {ctaType === "Map" && !GOOGLE_MAPS_API_KEY && (
          <div className="relative border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden bg-gray-100 dark:bg-[#1C1F26] aspect-video flex flex-col items-center justify-center">
            <MapIcon className="w-12 h-12 text-gray-400 mb-2" />
            <p className="text-sm text-gray-500 text-center">Google Maps is not configured</p>
            <p className="text-xs text-gray-400 text-center mt-1">Please set VITE_GOOGLE_MAPS_API_KEY in your environment</p>
          </div>
        )}
      </div>

      <div className="h-px bg-gray-100 dark:bg-gray-800 w-full" />

      <CustomSectionsBuilder />

      <div className="flex items-start gap-4 p-5 bg-blue-50 dark:bg-blue-500/5 border border-blue-100 dark:border-blue-900/30 rounded-2xl">
        <Info className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
        <div className="space-y-1">
          <p className="text-sm font-bold text-blue-900 dark:text-blue-100 leading-tight">Advanced Customization</p>
          <p className="text-xs text-blue-700/70 dark:text-blue-400/70 leading-relaxed">
            Unlike standard ads, Keliri allows you to add multiple descriptive blocks.
            Use these to highlight key product features or unique selling points.
          </p>
        </div>
      </div>
    </div>
  )
}