import * as React from "react"
import { Check, ChevronDown, Search, X } from "lucide-react"

interface Option {
  id: string
  name: string
}

interface MultiSelectProps {
  label: string
  options: Option[]
  selectedIds: string[]
  onChange: (ids: string[]) => void
  error?: string
}

export function MultiSelect({ label, options, selectedIds, onChange, error }: MultiSelectProps) {
  const [isOpen, setIsOpen] = React.useState(false)
  const [search, setSearch] = React.useState("")
  const containerRef = React.useRef<HTMLDivElement>(null)

  const filteredOptions = options.filter(opt => 
    opt.name.toLowerCase().includes(search.toLowerCase())
  )

  const toggleOption = (id: string) => {
    if (selectedIds.includes(id)) {
      onChange(selectedIds.filter(i => i !== id))
    } else {
      onChange([...selectedIds, id])
    }
  }

  const removeOption = (id: string, e: React.MouseEvent) => {
    e.stopPropagation()
    onChange(selectedIds.filter(i => i !== id))
  }

  // Close when clicking outside
  React.useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener("mousedown", handleClick)
    return () => document.removeEventListener("mousedown", handleClick)
  }, [])

  const selectedObjects = options.filter(opt => selectedIds.includes(opt.id))

  return (
    <div className="w-full relative" ref={containerRef}>
      <label className="flex items-center gap-2 text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
        Assign Publishers
      </label>
      
      <div 
        onClick={() => setIsOpen(!isOpen)}
        className={`relative min-h-[52px] w-full px-4 py-2 rounded-xl border bg-gray-50 dark:bg-[#1C1F26] cursor-pointer flex flex-wrap gap-2 items-center transition-all ${
          error 
            ? "border-red-300 focus:border-red-500 ring-2 ring-red-500/10 dark:border-red-900/50" 
            : "border-gray-200 dark:border-gray-800 hover:border-brand-500/50"
        }`}
      >
        {selectedObjects.length > 0 ? (
          selectedObjects.map(opt => (
            <span 
              key={opt.id} 
              className="flex items-center gap-1.5 px-3 py-1 bg-brand-500 text-white text-xs font-bold rounded-full group hover:bg-brand-600 transition-colors"
            >
              {opt.name}
              <X 
                className="w-3.5 h-3.5 cursor-pointer hover:scale-120" 
                onClick={(e) => removeOption(opt.id, e)} 
              />
            </span>
          ))
        ) : (
          <span className="text-gray-400 text-sm">Select one or more publishers...</span>
        )}
        
        <ChevronDown className={`absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 transition-transform ${isOpen ? "rotate-180" : ""}`} />
      </div>

      {isOpen && (
        <div className="absolute z-50 w-full mt-2 bg-white dark:bg-[#1A1D24] border border-gray-200 dark:border-gray-800 rounded-xl shadow-xl overflow-hidden animate-in fade-in zoom-in duration-200">
          <div className="p-3 border-b border-gray-100 dark:border-gray-800">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input 
                autoFocus
                type="text"
                placeholder="Search publishers..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="w-full pl-9 pr-4 py-2 bg-gray-50 dark:bg-[#1C1F26] text-sm text-gray-900 dark:text-white rounded-lg border-none focus:ring-2 focus:ring-brand-500/20"
              />
            </div>
          </div>
          
          <div className="max-h-[240px] overflow-y-auto p-2">
            {filteredOptions.length > 0 ? (
              filteredOptions.map(opt => {
                const isSelected = selectedIds.includes(opt.id)
                return (
                  <div 
                    key={opt.id}
                    onClick={() => toggleOption(opt.id)}
                    className={`flex items-center justify-between px-3 py-2.5 rounded-lg cursor-pointer transition-colors ${
                      isSelected 
                        ? "bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400" 
                        : "text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800"
                    }`}
                  >
                    <span className="text-sm font-medium">{opt.name}</span>
                    {isSelected && <Check className="w-4 h-4" />}
                  </div>
                )
              })
            ) : (
              <div className="p-4 text-center text-sm text-gray-500">No publishers found</div>
            )}
          </div>
        </div>
      )}

      {error && <p className="mt-1.5 text-sm text-red-500">{error}</p>}
    </div>
  )
}
