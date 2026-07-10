import * as React from "react"
import { Search, RotateCcw, Download, Filter } from "lucide-react"

interface PaymentFiltersProps {
  search: string
  onSearchChange: (val: string) => void
  status: string
  onStatusChange: (val: string) => void
  onReset: () => void
  onExport: () => void
}

export function PaymentFilters({ 
  search, 
  onSearchChange, 
  status, 
  onStatusChange, 
  onReset, 
  onExport 
}: PaymentFiltersProps) {
  return (
    <div className="bg-white dark:bg-[#1A1D24] p-4 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm flex flex-col md:flex-row gap-4 items-center justify-between transition-colors">
      <div className="flex flex-col md:flex-row gap-4 flex-1 w-full md:w-auto">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by Ad Name or Transaction ID..."
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition-all"
          />
        </div>

        {/* Status Filter */}
        <div className="relative w-full md:w-48">
          <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <select
            value={status}
            onChange={(e) => onStatusChange(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition-all appearance-none cursor-pointer"
          >
            <option value="All">All Statuses</option>
            <option value="Success">Success</option>
            <option value="Failed">Failed</option>
            <option value="Pending">Pending</option>
          </select>
        </div>
      </div>

      <div className="flex items-center gap-2 w-full md:w-auto">
        <button
          onClick={onReset}
          className="flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-2 text-sm font-medium text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-xl transition-colors border border-transparent hover:border-gray-200 dark:hover:border-gray-700"
        >
          <RotateCcw className="w-4 h-4" />
          Reset
        </button>
        <button
          onClick={onExport}
          className="flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-2 bg-gray-900 dark:bg-brand-500 text-white text-sm font-bold rounded-xl hover:bg-gray-800 dark:hover:bg-brand-600 transition-all active:scale-95 shadow-lg shadow-gray-900/10 dark:shadow-brand-500/20"
        >
          <Download className="w-4 h-4" />
          Export CSV
        </button>
      </div>
    </div>
  )
}
