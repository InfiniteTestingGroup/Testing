import * as React from "react"
import { Calendar, Filter, Download, RotateCcw } from "lucide-react"
import type { AnalyticsFilters } from "../../services/analytics"

interface AnalyticsFiltersProps {
  filters: AnalyticsFilters
  setFilters: React.Dispatch<React.SetStateAction<AnalyticsFilters>>
  onExport: () => void
  onReset: () => void
}

export function AnalyticsFilters({ filters, setFilters, onExport, onReset }: AnalyticsFiltersProps) {
  return (
    <div className="sticky top-0 z-40 bg-white/80 dark:bg-[#0E1117]/80 backdrop-blur-md border-b border-gray-200 dark:border-gray-800 -mx-8 px-8 py-4 mb-8">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex flex-wrap items-center gap-3">
          {/* Date Range */}
          <div className="relative">
            <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={filters.dateRange}
              onChange={(e) => setFilters({ ...filters, dateRange: e.target.value })}
              className="pl-10 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-xs font-bold text-gray-700 dark:text-gray-300 focus:ring-2 focus:ring-brand-500/20 transition-all appearance-none cursor-pointer"
            >
              <option>Today</option>
              <option>Last 7 Days</option>
              <option>Last 30 Days</option>
              <option>Custom Range</option>
            </select>
          </div>

          {/* Ad Type */}
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={filters.adType}
              onChange={(e) => setFilters({ ...filters, adType: e.target.value })}
              className="pl-10 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-xs font-bold text-gray-700 dark:text-gray-300 focus:ring-2 focus:ring-brand-500/20 transition-all appearance-none cursor-pointer"
            >
              <option value="All">All Types</option>
              <option value="Banner">Banner</option>
              <option value="Video">Video</option>
              <option value="Thumbnail">Thumbnail</option>
            </select>
          </div>

          {/* Status */}
          <select
            value={filters.status}
            onChange={(e) => setFilters({ ...filters, status: e.target.value })}
            className="px-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-xs font-bold text-gray-700 dark:text-gray-300 focus:ring-2 focus:ring-brand-500/20 transition-all appearance-none cursor-pointer"
          >
            <option value="All">All Status</option>
            <option value="Active">Active</option>
            <option value="Expired">Expired</option>
          </select>

          <button
            onClick={onReset}
            className="p-2 text-gray-400 hover:text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-xl transition-colors"
            title="Reset Filters"
          >
            <RotateCcw className="w-4 h-4" />
          </button>
        </div>

        <button
          onClick={onExport}
          className="flex items-center gap-2 px-5 py-2.5 bg-gray-900 dark:bg-brand-500 text-white rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-gray-800 dark:hover:bg-brand-600 transition-all active:scale-95 shadow-xl shadow-gray-900/10 dark:shadow-brand-500/20"
        >
          <Download className="w-4 h-4" />
          Export Data
        </button>
      </div>
    </div>
  )
}
