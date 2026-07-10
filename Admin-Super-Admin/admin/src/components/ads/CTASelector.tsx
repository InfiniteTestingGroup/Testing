import * as React from "react"
import { ExternalLink, Phone, MessageCircle, Mail, MapPin } from "lucide-react"

export type CTAType = "Redirect" | "Dial" | "WhatsApp" | "Email" | "Map"

interface CTASelectorProps {
  value: CTAType
  onChange: (value: CTAType) => void
}

const CTA_OPTIONS: { type: CTAType; label: string; icon: React.ElementType }[] = [
  { type: "Redirect", label: "Redirect", icon: ExternalLink },
  { type: "Dial", label: "Dial", icon: Phone },
  { type: "WhatsApp", label: "WhatsApp", icon: MessageCircle },
  { type: "Email", label: "Email", icon: Mail },
  { type: "Map", label: "Take Me To", icon: MapPin },
]

export function CTASelector({ value, onChange }: CTASelectorProps) {
  return (
    <div className="space-y-3">
      <label className="text-sm font-semibold text-gray-700 dark:text-gray-300">
        Action Type
      </label>
      <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
        {CTA_OPTIONS.map((opt) => {
          const Icon = opt.icon
          const isActive = value === opt.type

          return (
            <button
              key={opt.type}
              type="button"
              onClick={() => onChange(opt.type)}
              className={`flex flex-col items-center justify-center p-4 rounded-xl border-2 transition-all gap-2 ${isActive
                  ? "border-brand-500 bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400"
                  : "border-gray-200 dark:border-gray-800 bg-white dark:bg-[#1A1D24] text-gray-500 hover:border-gray-300 dark:hover:border-gray-700"
                }`}
            >
              <Icon className="w-5 h-5" />
              <span className="text-xs font-bold whitespace-nowrap">{opt.label}</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}
