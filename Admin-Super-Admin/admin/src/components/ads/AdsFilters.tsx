import * as React from "react"
import { Search, Filter, RefreshCw, Calendar } from "lucide-react"

interface AdsFiltersProps {
  searchTerm: string
  setSearchTerm: (v: string) => void
  statusFilter: string
  setStatusFilter: (v: string) => void
  publisherFilter: string
  setPublisherFilter: (v: string) => void
  dateFilterMode: string
  setDateFilterMode: (v: string) => void
  customDateRange: { start: string; end: string }
  setCustomDateRange: (v: { start: string; end: string }) => void
  publishersList: string[]
  paymentFilter: string
  setPaymentFilter: (v: string) => void
}

const STATUS_OPTIONS = ["All", "Draft", "Pending", "Active", "Expired", "Suspended"]
const DATE_OPTIONS = ["All Time", "Today", "Last 7 days", "Last 30 days", "Custom Range"]

export function AdsFilters({
  searchTerm, setSearchTerm,
  statusFilter, setStatusFilter,
  publisherFilter, setPublisherFilter,
  dateFilterMode, setDateFilterMode,
  customDateRange, setCustomDateRange,
  publishersList,
  paymentFilter, setPaymentFilter
}: AdsFiltersProps) {
  
  const [localSearch, setLocalSearch] = React.useState(searchTerm)

  // Debounced Search Setup
  React.useEffect(() => {
    const timer = setTimeout(() => {
      setSearchTerm(localSearch)
    }, 400)
    return () => clearTimeout(timer)
  }, [localSearch, setSearchTerm])

  const handleReset = () => {
    setLocalSearch("")
    setSearchTerm("")
    setStatusFilter("All")
    setPublisherFilter("All")
    setDateFilterMode("All Time")
    setCustomDateRange({ start: "", end: "" })
    setPaymentFilter("All")
  }

  return (
    <div className="bg-white dark:bg-[#1A1D24] p-4 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 mb-6 flex flex-col xl:flex-row xl:items-center gap-4 transition-colors">
      
      {/* Search Input */}
      <div className="relative flex-1 min-w-[200px]">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input 
          type="text"
          placeholder="Search ad titles or publishers..."
          value={localSearch}
          onChange={(e) => setLocalSearch(e.target.value)}
          className="w-full pl-9 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-500/50 dark:text-white transition-all"
        />
      </div>

      <div className="flex flex-wrap items-center gap-3">
        {/* Status Dropdown */}
        <div className="relative min-w-[140px]">
          <select 
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="w-full appearance-none pl-10 pr-8 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-brand-500/50 cursor-pointer"
          >
            {STATUS_OPTIONS.map(opt => <option key={opt} value={opt}>{opt} Status</option>)}
          </select>
          <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
        </div>

        {/* Payment Status Dropdown */}
        <div className="relative min-w-[150px]">
          <select 
            value={paymentFilter}
            onChange={(e) => setPaymentFilter(e.target.value)}
            className="w-full appearance-none pl-10 pr-8 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-brand-500/50 cursor-pointer"
          >
            <option value="All">All Payments</option>
            <option value="Paid">Paid Only</option>
            <option value="Pending">Pending Only</option>
          </select>
          <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
        </div>

        {/* Publisher Dropdown */}
        <div className="relative min-w-[160px]">
          <select 
            value={publisherFilter}
            onChange={(e) => setPublisherFilter(e.target.value)}
            className="w-full appearance-none pl-3 pr-8 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-brand-500/50 cursor-pointer"
          >
            <option value="All">All Publishers</option>
            {publishersList.map(pub => <option key={pub} value={pub}>{pub}</option>)}
          </select>
        </div>

        {/* Date Filter Dropdown */}
        <div className="relative min-w-[160px]">
          <select 
            value={dateFilterMode}
            onChange={(e) => setDateFilterMode(e.target.value)}
            className="w-full appearance-none pl-10 pr-8 py-2 bg-gray-50 dark:bg-[#1C1F26] border border-gray-200 dark:border-gray-800 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-brand-500/50 cursor-pointer"
          >
            {DATE_OPTIONS.map(opt => <option key={opt} value={opt}>{opt}</option>)}
          </select>
          <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
        </div>

        {/* Custom Date Inputs (Appears only if Custom Range is selected) */}
        {dateFilterMode === "Custom Range" && (
          <div className="flex items-center gap-2 bg-gray-50 dark:bg-[#1C1F26] p-1 rounded-xl border border-gray-200 dark:border-gray-800">
            <input 
              type="date"
              value={customDateRange.start}
              onChange={(e) => setCustomDateRange({ ...customDateRange, start: e.target.value })}
              className="bg-transparent text-sm w-full outline-none px-2 dark:text-white dark:[color-scheme:dark]"
            />
            <span className="text-gray-400 text-xs">to</span>
            <input 
              type="date"
              value={customDateRange.end}
              onChange={(e) => setCustomDateRange({ ...customDateRange, end: e.target.value })}
              className="bg-transparent text-sm w-full outline-none px-2 dark:text-white dark:[color-scheme:dark]"
            />
          </div>
        )}

        <div className="h-8 w-px bg-gray-200 dark:bg-gray-800 hidden sm:block mx-1"></div>

        {/* Reset Button */}
        <button 
          onClick={handleReset}
          className="flex items-center gap-2 p-2 text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-xl transition-colors text-sm font-medium focus:outline-none"
          title="Reset Filters"
        >
          <RefreshCw className="w-4 h-4" />
          <span className="hidden md:inline">Reset</span>
        </button>
      </div>
    </div>
  )
}
