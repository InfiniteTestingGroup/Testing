import * as React from "react"
import { Search, RotateCcw } from "lucide-react"

interface TicketFiltersProps {
  onFilterChange: (filters: any) => void
  ticketTab: 'active' | 'closed'
}

export function TicketFilters({ onFilterChange, ticketTab }: TicketFiltersProps) {
  const [query, setQuery] = React.useState("")
  const [status, setStatus] = React.useState("All")
  const [category, setCategory] = React.useState("All")
  const [priority, setPriority] = React.useState("All")

  React.useEffect(() => {
    setStatus("All")
  }, [ticketTab])

  React.useEffect(() => {
    onFilterChange({ query, status, category, priority })
  }, [query, status, category, priority])

  const statusOptions = React.useMemo(() => {
    return ticketTab === 'active' 
      ? ["All", "Open", "In Progress"]
      : ["All", "Resolved", "Closed"]
  }, [ticketTab])

  const handleReset = () => {
    setQuery("")
    setStatus("All")
    setCategory("All")
    setPriority("All")
  }

  return (
    <div className="bg-white dark:bg-[#1A1D24] p-6 rounded-[2rem] border border-gray-100 dark:border-gray-800 shadow-sm mb-8 flex flex-wrap items-center justify-between gap-6 transition-colors">
      <div className="flex flex-wrap items-center gap-4 flex-1">
        {/* Search */}
        <div className="relative flex-1 min-w-[300px]">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by ID or Subject..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="w-full pl-12 pr-4 py-3 bg-gray-50 dark:bg-[#0E1117] border border-gray-100 dark:border-gray-800 rounded-2xl text-sm focus:ring-4 focus:ring-brand-500/10 focus:border-brand-500 outline-none transition-all placeholder:text-gray-400 dark:text-gray-200"
          />
        </div>

         <div className="flex bg-gray-50 dark:bg-[#0E1117] p-1 rounded-xl border border-gray-100 dark:border-gray-800">
            {statusOptions.map((s) => (
              <button
                key={s}
                onClick={() => setStatus(s)}
                className={`px-4 py-2 text-xs font-black uppercase tracking-widest rounded-lg transition-all ${
                  status === s 
                    ? "bg-white dark:bg-[#1C1F26] text-brand-600 dark:text-brand-400 shadow-sm" 
                    : "text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
                }`}
              >
                {s}
              </button>
            ))}
         </div>

        {/* Category Filter */}
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value)}
          className="px-4 py-2.5 bg-gray-50 dark:bg-[#0E1117] border border-gray-100 dark:border-gray-800 rounded-xl text-xs font-bold text-gray-700 dark:text-gray-300 focus:ring-4 focus:ring-brand-500/10 outline-none transition-all cursor-pointer appearance-none min-w-[160px]"
        >
          <option value="All">All Categories</option>
          <option value="Technical Issue">Technical Issue</option>
          <option value="Payment Issue">Payment Issue</option>
          <option value="Ad Issue">Ad Issue</option>
          <option value="Other">Other Category</option>
        </select>

        {/* Priority Filter */}
        <select
          value={priority}
          onChange={(e) => setPriority(e.target.value)}
          className="px-4 py-2.5 bg-gray-50 dark:bg-[#0E1117] border border-gray-100 dark:border-gray-800 rounded-xl text-xs font-bold text-gray-700 dark:text-gray-300 focus:ring-4 focus:ring-brand-500/10 outline-none transition-all cursor-pointer appearance-none min-w-[160px]"
        >
          <option value="All">All Priorities</option>
          <option value="Urgent">Urgent Priority</option>
          <option value="High">High Priority</option>
          <option value="Medium">Medium Priority</option>
          <option value="Low">Low Priority</option>
        </select>
      </div>

      <button
        onClick={handleReset}
        className="flex items-center gap-2 px-5 py-2.5 text-gray-400 hover:text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-xl transition-all group"
        title="Reset Filters"
      >
        <RotateCcw className="w-4 h-4 transition-transform group-hover:-rotate-90" />
        <span className="text-[10px] font-black uppercase tracking-widest">Reset</span>
      </button>
    </div>
  )
}
