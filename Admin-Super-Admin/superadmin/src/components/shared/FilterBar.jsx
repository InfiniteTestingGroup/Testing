import React, { useState, useRef, useEffect } from 'react';
import { Filter, X, ChevronDown, Search, Calendar } from 'lucide-react';

/**
 * @param {object} props
 * @param {any[]} [props.filters]
 * @param {Function} props.onFilterChange
 * @param {Function} props.onReset
 * @param {number} [props.activeFiltersCount]
 */
const FilterBar = ({ filters = [], onFilterChange, onReset, activeFiltersCount = 0 }) => {
  const [isOpen, setIsOpen] = useState(false);

  /** Format an applied filter value into a human-readable pill label */
  const formatAppliedValue = (filter) => {
    const v = filter.appliedValue;
    if (!v) return null;

    if (filter.type === 'date') {
      const d = new Date(v);
      return isNaN(d.getTime()) ? v : d.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
    }
    if (filter.type === 'dateRange' && typeof v === 'object') {
      const fmt = (d) => {
        if (!d) return '…';
        const dt = new Date(d + 'T00:00:00');
        return dt.toLocaleDateString('en-IN', { day: '2-digit', month: 'short' });
      };
      if (!v.from && !v.to) return null;
      return `${fmt(v.from)} – ${fmt(v.to)}`;
    }

    if (filter.type === 'numberRange' && typeof v === 'object') {
      if (!v.min && !v.max) return null;
      const prefix = filter.prefix || '';
      return `${prefix}${v.min || '0'} – ${prefix}${v.max || '∞'}`;
    }

    if (Array.isArray(v)) return v.join(', ');

    return String(v);
  };

  /** Check if a filter has an active value */
  const hasValue = (filter) => {
    const v = filter.appliedValue;
    if (!v) return false;
    if (typeof v === 'object' && !Array.isArray(v)) {
      return Object.values(v).some(Boolean);
    }
    if (Array.isArray(v)) return v.length > 0;
    return Boolean(v);
  };

  return (
    <div className="bg-white border-b border-gray-100 sticky top-0 z-20 shadow-sm w-full rounded-2xl overflow-visible">
      <div className="px-6 py-3 flex items-center justify-between gap-4">
        <div className="flex items-center gap-4 flex-1 overflow-x-auto no-scrollbar py-1">
          <button
            onClick={() => setIsOpen(!isOpen)}
            className={`flex-shrink-0 flex items-center gap-2 px-3 py-1.5 rounded-xl text-sm font-semibold transition-all
              ${isOpen ? 'bg-primary-500 text-white shadow-lg shadow-primary-500/20' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}
            `}
          >
            <Filter size={16} />
            Filters
            {activeFiltersCount > 0 && (
              <span className={`w-5 h-5 flex items-center justify-center rounded-full text-[10px] 
                ${isOpen ? 'bg-white text-primary-600' : 'bg-primary-500 text-white'}
              `}>
                {activeFiltersCount}
              </span>
            )}
          </button>

          <div className="h-6 w-px bg-gray-200 mx-1 flex-shrink-0" />

          <div className="flex items-center gap-2">
            {filters?.map((filter, idx) => {
              if (!hasValue(filter)) return null;
              return (
                <div
                  key={idx}
                  className="flex items-center gap-1.5 bg-primary-50 text-primary-700 border border-primary-100 px-3 py-1 rounded-full text-xs font-medium animate-fade-in group"
                >
                  <span className="text-primary-500/60">{filter.label}:</span>
                  <span>{formatAppliedValue(filter)}</span>
                  <button
                    onClick={() => onFilterChange(filter.key, null)}
                    className="hover:bg-primary-100 rounded-full p-0.5 transition-colors"
                  >
                    <X size={12} />
                  </button>
                </div>
              );
            })}
            {activeFiltersCount > 0 && (
              <button
                onClick={onReset}
                className="text-xs font-bold text-gray-400 hover:text-red-500 transition-colors ml-2 uppercase tracking-wider"
              >
                Reset All
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Expanded Filter Panel - Inline (Relative) instead of Absolute */}
      {isOpen && (
        <div className="bg-gray-50/70 border-t border-gray-100 p-6 animate-fade-in-scale grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 rounded-b-2xl">
          {filters?.map((filter) => (
            <div key={filter.key} className={`space-y-2 ${['dateRange', 'numberRange'].includes(filter.type) ? 'md:col-span-2' : ''}`}>
              <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">{filter.label}</label>

              {/* ── SELECT ── */}
              {filter.type === 'select' ? (
                <div className="relative group">
                  <select
                    className="w-full appearance-none bg-white border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all cursor-pointer"
                    value={filter.appliedValue || ''}
                    onChange={(e) => onFilterChange(filter.key, e.target.value)}
                  >
                    <option value="">{filter.placeholder || `All ${filter.label}`}</option>
                    {filter.options?.map(opt => (
                      <option key={opt.value} value={opt.value}>{opt.label}</option>
                    ))}
                  </select>
                  <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none group-hover:text-gray-600 transition-colors" size={16} />
                </div>

                /* ── SEARCH ── */
              ) : filter.type === 'search' ? (
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={16} />
                  <input
                    type="text"
                    placeholder={filter.placeholder ? `${filter.placeholder}...` : `Search ${filter.label}...`}
                    className="w-full bg-white border border-gray-200 rounded-xl pl-10 pr-4 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                    value={filter.appliedValue || ''}
                    onChange={(e) => onFilterChange(filter.key, e.target.value)}
                  />
                </div>

                /* ── CHECKBOX ── */
              ) : filter.type === 'checkbox' ? (
                <div className="flex flex-wrap gap-2 pt-1">
                  {filter.options?.map(opt => {
                    const isSelected = Array.isArray(filter.appliedValue) && filter.appliedValue.includes(opt.value);
                    return (
                      <button
                        key={opt.value}
                        onClick={() => {
                          const current = Array.isArray(filter.appliedValue) ? filter.appliedValue : [];
                          const next = isSelected
                            ? current.filter(v => v !== opt.value)
                            : [...current, opt.value];
                          onFilterChange(filter.key, next.length > 0 ? next : null);
                        }}
                        className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition-all border
                            ${isSelected
                            ? 'bg-primary-50 border-primary-200 text-primary-700 shadow-sm'
                            : 'bg-white border-gray-200 text-gray-500 hover:border-gray-300'}
                          `}
                      >
                        {opt.label}
                      </button>
                    );
                  })}
                </div>

                /* ── DATE RANGE ── */
              ) : filter.type === 'dateRange' ? (
                <div className="flex items-center gap-2">
                  <div className="relative flex-1 min-w-0">
                    <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" size={14} />
                    <input
                      type="date"
                      className="w-full bg-white border border-gray-200 rounded-xl pl-9 pr-3 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                      value={filter.appliedValue?.from || ''}
                      onChange={(e) => {
                        const current = filter.appliedValue || {};
                        const next = { ...current, from: e.target.value || undefined };
                        onFilterChange(filter.key, (next.from || next.to) ? next : null);
                      }}
                    />
                  </div>
                  <span className="text-gray-400 text-xs font-bold">to</span>
                  <div className="relative flex-1 min-w-0">
                    <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" size={14} />
                    <input
                      type="date"
                      className="w-full bg-white border border-gray-200 rounded-xl pl-9 pr-3 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                      value={filter.appliedValue?.to || ''}
                      onChange={(e) => {
                        const current = filter.appliedValue || {};
                        const next = { ...current, to: e.target.value || undefined };
                        onFilterChange(filter.key, (next.from || next.to) ? next : null);
                      }}
                    />
                  </div>
                </div>

                /* ── SEARCHABLE SELECT ── */
              ) : filter.type === 'searchableSelect' ? (
                <SearchableSelect
                  options={filter.options || []}
                  value={filter.appliedValue || ''}
                  placeholder={filter.placeholder || `Search ${filter.label}...`}
                  loading={filter.loading}
                  onChange={(val) => onFilterChange(filter.key, val || null)}
                />

                /* ── NUMBER RANGE ── */
              ) : filter.type === 'numberRange' ? (
                <div className="flex items-center gap-2">
                  <div className="relative flex-1 min-w-0">
                    <input
                      type="number"
                      placeholder={filter.minPlaceholder || 'Min'}
                      className="w-full bg-white border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                      value={filter.appliedValue?.min ?? ''}
                      onChange={(e) => {
                        const current = filter.appliedValue || {};
                        const val = e.target.value;
                        const next = { ...current, min: val !== '' ? Number(val) : undefined };
                        onFilterChange(filter.key, (next.min !== undefined || next.max !== undefined) ? next : null);
                      }}
                    />
                  </div>
                  <span className="text-gray-400 text-xs font-bold">to</span>
                  <div className="relative flex-1 min-w-0">
                    <input
                      type="number"
                      placeholder={filter.maxPlaceholder || 'Max'}
                      className="w-full bg-white border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                      value={filter.appliedValue?.max ?? ''}
                      onChange={(e) => {
                        const current = filter.appliedValue || {};
                        const val = e.target.value;
                        const next = { ...current, max: val !== '' ? Number(val) : undefined };
                        onFilterChange(filter.key, (next.min !== undefined || next.max !== undefined) ? next : null);
                      }}
                    />
                  </div>
                </div>

              ) : filter.type === 'date' ? (
                <div className="relative">
                  <input
                    type="date"
                    className="w-full bg-white border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-750 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all cursor-pointer"
                    value={filter.appliedValue || ''}
                    onChange={(e) => onFilterChange(filter.key, e.target.value || null)}
                  />
                </div>
              ) : null}
            </div>
          ))}
          <div className="col-span-full flex justify-end pt-4 border-t border-gray-200 gap-4">
            <button
              onClick={() => setIsOpen(false)}
              className="px-6 py-2 bg-gray-900 text-white rounded-xl text-sm font-bold shadow-lg shadow-gray-900/20 hover:scale-[1.02] active:scale-[0.98] transition-all"
            >
              Apply Filters
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

/* ─── Searchable Select Sub-Component ─────────────────────────────────────── */
const SearchableSelect = ({ options = [], value, placeholder, loading, onChange }) => {
  const [query, setQuery] = useState('');
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const wrapperRef = useRef(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (wrapperRef.current && !wrapperRef.current.contains(e.target)) {
        setIsDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const filtered = options.filter(opt =>
    opt.label.toLowerCase().includes(query.toLowerCase())
  );

  const selectedLabel = options.find(o => o.value === value)?.label || '';

  return (
    <div className="relative" ref={wrapperRef}>
      <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none z-10" size={14} />
      <input
        type="text"
        placeholder={value ? selectedLabel : placeholder}
        className={`w-full bg-white border border-gray-200 rounded-xl pl-9 pr-8 py-2 text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all ${value ? 'text-primary-700' : 'text-gray-700'}`}
        value={isDropdownOpen ? query : (value ? selectedLabel : '')}
        onFocus={() => { setIsDropdownOpen(true); setQuery(''); }}
        onChange={(e) => setQuery(e.target.value)}
      />
      {value && (
        <button
          onClick={(e) => { e.stopPropagation(); onChange(''); setQuery(''); }}
          className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-red-500 transition-colors z-10"
        >
          <X size={14} />
        </button>
      )}

      {isDropdownOpen && (
        <div className="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-200 rounded-xl shadow-xl max-h-48 overflow-y-auto z-50 animate-fade-in">
          {loading ? (
            <div className="px-4 py-3 text-sm text-gray-400 text-center">Loading…</div>
          ) : filtered.length === 0 ? (
            <div className="px-4 py-3 text-sm text-gray-400 text-center">No results found</div>
          ) : (
            filtered.map(opt => (
              <button
                key={opt.value}
                onClick={() => {
                  onChange(opt.value);
                  setQuery('');
                  setIsDropdownOpen(false);
                }}
                className={`w-full text-left px-4 py-2.5 text-sm font-medium transition-colors hover:bg-primary-50 hover:text-primary-700 ${opt.value === value ? 'bg-primary-50 text-primary-700' : 'text-gray-700'}`}
              >
                {opt.label}
              </button>
            ))
          )}
        </div>
      )}
    </div>
  );
};

export default FilterBar;