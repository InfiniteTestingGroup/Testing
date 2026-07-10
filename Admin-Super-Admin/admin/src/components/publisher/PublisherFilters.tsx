import * as React from "react"
import { Search, RotateCcw } from "lucide-react"
import { Input } from "../ui/Input"

interface PublisherFiltersProps {
  searchTerm: string
  setSearchTerm: (value: string) => void
  statusFilter: string
  setStatusFilter: (value: string) => void
}

export function PublisherFilters({
  searchTerm,
  setSearchTerm,
  statusFilter,
  setStatusFilter,
}: PublisherFiltersProps) {
  
  const [localSearch, setLocalSearch] = React.useState(searchTerm)

  // Debounce search
  React.useEffect(() => {
    const timer = setTimeout(() => {
      setSearchTerm(localSearch)
    }, 300)
    return () => clearTimeout(timer)
  }, [localSearch, setSearchTerm])

  const handleReset = () => {
    setLocalSearch("")
    setStatusFilter("All")
  }

  return (
    <div className="flex flex-col sm:flex-row gap-4 mb-6">
      <div className="flex-1 w-full max-w-sm">
        <Input
          placeholder="Search name, location, contact..."
          icon={<Search className="w-4 h-4" />}
          value={localSearch}
          onChange={(e) => setLocalSearch(e.target.value)}
        />
      </div>
      <div className="flex items-center gap-4">
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="h-10 rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-500 disabled:cursor-not-allowed disabled:opacity-50 dark:border-gray-800 dark:bg-[#1A1D24] focus-visible:dark:ring-brand-500 transition-colors dark:text-white"
        >
          <option value="All">All Status</option>
          <option value="Active">Active</option>
          <option value="Inactive">Inactive</option>
        </select>
        
        <button
          onClick={handleReset}
          className="h-10 px-4 flex items-center justify-center gap-2 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 hover:text-gray-900 transition-colors shadow-sm dark:bg-[#1A1D24] dark:border-gray-800 dark:text-gray-300 dark:hover:bg-gray-800 dark:hover:text-white"
        >
          <RotateCcw className="w-4 h-4" />
          <span className="hidden sm:inline">Reset</span>
        </button>
      </div>
    </div>
  )
}
