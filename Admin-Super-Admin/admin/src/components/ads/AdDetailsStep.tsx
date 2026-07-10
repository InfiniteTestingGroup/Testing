import * as React from "react"
import { useFormContext } from "react-hook-form"
import { Type, AlignLeft, LayoutTemplate } from "lucide-react"

export function AdDetailsStep() {
  const { register, formState: { errors } } = useFormContext()

  return (
    <div className="space-y-6">
      <h2 className="text-xl font-bold text-gray-900 dark:text-white mb-6">Ad Details</h2>

      {/* Ad Title */}
      <div>
        <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
          <Type className="w-4 h-4 text-brand-500" />
          Ad Title
        </label>
        <input
          {...register("title")}
          placeholder="e.g. Summer Mega Sale 2026"
          className={`w-full px-4 py-3 rounded-xl border bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-colors ${errors.title
              ? "border-red-300 focus:border-red-500 focus:ring-red-500/20 dark:border-red-900/50"
              : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
            }`}
        />
        {errors.title && <p className="mt-1.5 text-sm text-red-500">{errors.title.message as string}</p>}
      </div>

      {/* Ad Type */}
      <div>
        <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
          <LayoutTemplate className="w-4 h-4 text-brand-500" />
          Ad Format Type
        </label>
        <select
          {...register("type")}
          className={`w-full px-4 py-3 rounded-xl border bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-colors cursor-pointer appearance-none ${errors.type
              ? "border-red-300 focus:border-red-500 focus:ring-red-500/20 dark:border-red-900/50"
              : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
            }`}
        >
          <option value="Banner">Banner Ad (Image)</option>
          <option value="Video">Video Ad (MP4)</option>
          <option value="Image Ad">Image Ad (Single Image)</option>
        </select>
        {errors.type && <p className="mt-1.5 text-sm text-red-500">{errors.type.message as string}</p>}
      </div>

      {/* Ad Description */}
      <div>
        <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
          <AlignLeft className="w-4 h-4 text-brand-500" />
          Ad Description
        </label>
        <textarea
          {...register("description")}
          placeholder="Briefly describe what this ad is about. This is for internal tracking."
          rows={4}
          className={`w-full px-4 py-3 rounded-xl border bg-gray-50 dark:bg-[#1C1F26] text-gray-900 dark:text-white focus:outline-none focus:ring-2 transition-colors resize-none ${errors.description
              ? "border-red-300 focus:border-red-500 focus:ring-red-500/20 dark:border-red-900/50"
              : "border-gray-200 dark:border-gray-800 focus:border-brand-500 focus:ring-brand-500/20"
            }`}
        />
        {errors.description && <p className="mt-1.5 text-sm text-red-500">{errors.description.message as string}</p>}
      </div>

    </div>
  )
}
