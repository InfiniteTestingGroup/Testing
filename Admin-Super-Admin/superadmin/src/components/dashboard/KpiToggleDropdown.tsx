import { useState, useRef, useEffect } from 'react'
import { SlidersHorizontal, Check } from 'lucide-react'

export interface KpiVisibilityItem {
  id: string
  title: string
  visible: boolean
}

interface KpiToggleDropdownProps {
  items: KpiVisibilityItem[]
  onChange: (id: string) => void
}

export default function KpiToggleDropdown({ items, onChange }: KpiToggleDropdownProps) {
  const [open, setOpen] = useState(false)
  const ref = useRef<HTMLDivElement>(null)

  // Close on outside click
  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClick)
    return () => document.removeEventListener('mousedown', handleClick)
  }, [])

  const visibleCount = items.filter((i) => i.visible).length

  return (
    <div className="relative" ref={ref}>
      {/* Trigger button */}
      <button
        onClick={() => setOpen((v) => !v)}
        className={`flex items-center gap-2 px-3.5 py-2 rounded-xl text-sm font-medium border
                    transition-all duration-200 shadow-sm
                    ${open
            ? 'bg-primary-50 border-primary-300 text-primary-700'
            : 'bg-white border-gray-200 text-gray-600 hover:border-primary-300 hover:text-primary-600 hover:bg-primary-50'
          }`}
      >
        <SlidersHorizontal size={15} />
        <span>Customize</span>
        <span className={`text-[11px] font-bold px-1.5 py-0.5 rounded-md
                          ${open ? 'bg-primary-100 text-primary-700' : 'bg-gray-100 text-gray-500'}`}>
          {visibleCount}/{items.length}
        </span>
      </button>

      {/* Dropdown panel */}
      {open && (
        <div
          className="absolute right-0 top-[calc(100%+8px)] w-64 bg-white rounded-2xl shadow-card-hover
                     border border-gray-100 z-50 overflow-hidden animate-fade-in"
        >
          {/* Panel header */}
          <div className="px-4 py-3 border-b border-gray-100 bg-gray-50/60">
            <p className="text-xs font-semibold text-gray-700">Visible KPI Cards</p>
            <p className="text-[11px] text-gray-400 mt-0.5">Toggle cards on or off</p>
          </div>

          {/* Items */}
          <div className="p-2">
            {items.map((item, index) => (
              <button
                key={`${item.id}-${index}`}
                onClick={() => onChange(item.id)}
                className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl
                           hover:bg-gray-50 transition-colors text-left group"
              >
                {/* Custom checkbox */}
                <div
                  className={`w-5 h-5 rounded-md border-2 flex items-center justify-center flex-shrink-0
                               transition-all duration-200
                               ${item.visible
                      ? 'bg-primary-500 border-primary-500'
                      : 'bg-white border-gray-300 group-hover:border-primary-400'
                    }`}
                >
                  {item.visible && <Check size={11} strokeWidth={3} className="text-white" />}
                </div>
                <span className={`text-sm transition-colors duration-150
                                  ${item.visible ? 'text-gray-800 font-medium' : 'text-gray-500'}`}>
                  {item.title}
                </span>
              </button>
            ))}
          </div>

          {/* Footer actions */}
          <div className="px-4 py-3 border-t border-gray-100 flex items-center justify-between">
            <button
              onClick={() => items.filter((i) => !i.visible).forEach((i) => onChange(i.id))}
              className="text-xs font-semibold text-primary-600 hover:text-primary-700 transition-colors"
            >
              Show all
            </button>
            <button
              onClick={() => setOpen(false)}
              className="text-xs font-semibold text-gray-500 hover:text-gray-700 transition-colors"
            >
              Done
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
