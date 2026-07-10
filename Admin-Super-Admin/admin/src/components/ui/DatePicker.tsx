import * as React from "react"
import { Calendar } from "lucide-react"

interface DatePickerProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string
}

export const DatePicker = React.forwardRef<HTMLInputElement, DatePickerProps>(
  ({ label, error, ...props }, ref) => {
    return (
      <div className="w-full">
        <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
          <Calendar className="w-4 h-4 text-brand-500" />
          {label}
        </label>
        <div className="relative">
          <input
            {...props}
            ref={ref}
            type="date"
            className={`w-full px-4 py-3 rounded-xl border bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-all dark:[color-scheme:dark] ${
              error 
                ? "border-red-300 focus:border-red-500 focus:ring-red-500/20 dark:border-red-900/50" 
                : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
            }`}
          />
        </div>
        {error && <p className="mt-1.5 text-sm text-red-500">{error}</p>}
      </div>
    )
  }
)
