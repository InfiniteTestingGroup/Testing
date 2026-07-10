import { useEffect, useState } from 'react'
import {
  ArrowDownRight, ArrowUpRight, CheckCircle2, Clock, XCircle,
  FileText, Lock
} from 'lucide-react'
import { Link } from 'react-router-dom'
import toast from 'react-hot-toast'
import DataTable from '../components/shared/DataTable'
import FilterBar from '../components/shared/FilterBar'
import { fetchAllTransactions, type TransactionRecord } from '../lib/transactions'

export default function Transactions() {
  const [allTransactions, setAllTransactions] = useState<TransactionRecord[]>([])
  const [loading, setLoading] = useState(true)

  // Filters state
  const [activeFilters, setActiveFilters] = useState<{
    search: string
    status: string | null
    sort: string | null
    dateRange: { from?: string; to?: string } | null
    amountRange: { min?: number; max?: number } | null
    txnType: string | null
  }>({
    search: '',
    status: null,
    sort: null,
    dateRange: null,
    amountRange: null,
    txnType: null,
  })

  useEffect(() => {
    async function load() {
      setLoading(true)
      try {
        const data = await fetchAllTransactions()
        setAllTransactions(data)
      } catch (err) {
        console.error("Failed to load transactions", err)
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [])

  // Filter definitions consumed by the shared FilterBar component
  const filters = [
    {
      key: 'search',
      label: 'Search',
      type: 'search',
      placeholder: 'Search TXN or Admin',
      appliedValue: activeFilters.search,
    },
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      placeholder: 'All Status',
      appliedValue: activeFilters.status,
      options: [
        { value: 'Completed', label: 'Completed' },
        { value: 'Pending', label: 'Pending' },
        { value: 'Failed', label: 'Failed' },
      ],
    },
    {
      key: 'dateRange',
      label: 'Date Range',
      type: 'dateRange',
      appliedValue: activeFilters.dateRange,
    },
    {
      key: 'amountRange',
      label: 'Amount Range',
      type: 'numberRange',
      prefix: '₹',
      appliedValue: activeFilters.amountRange,
    },
    {
      key: 'txnType',
      label: 'Transaction Type',
      type: 'select',
      placeholder: 'All Types',
      appliedValue: activeFilters.txnType,
      options: [
        { value: 'Payment', label: 'Payment' },
        { value: 'Payout', label: 'Payout' },
      ],
    },
    {
      key: 'sort',
      label: 'Sort By',
      type: 'select',
      placeholder: 'Latest First',
      appliedValue: activeFilters.sort,
      options: [
        { value: 'Latest First', label: 'Latest First' },
        { value: 'Oldest First', label: 'Oldest First' },
        { value: 'Highest Amount', label: 'Highest Amount' },
        { value: 'Lowest Amount', label: 'Lowest Amount' },
      ],
    },
  ]

  const activeFiltersCount =
    (activeFilters.search ? 1 : 0) +
    (activeFilters.status ? 1 : 0) +
    (activeFilters.dateRange ? 1 : 0) +
    (activeFilters.amountRange ? 1 : 0) +
    (activeFilters.txnType ? 1 : 0) +
    (activeFilters.sort && activeFilters.sort !== 'Latest First' ? 1 : 0)

  const handleFilterChange = (key: string, value: any) => {
    setActiveFilters(prev => ({ ...prev, [key]: value }))
  }

  const handleReset = () => {
    setActiveFilters({
      search: '',
      status: null,
      sort: null,
      dateRange: null,
      amountRange: null,
      txnType: null,
    })
  }

  // Filtering & Sorting
  const filteredTx = allTransactions
    .filter(tx => {
      if (activeFilters.search) {
        const term = activeFilters.search.toLowerCase()
        const matchSearch =
          tx.transactionId.toLowerCase().includes(term) ||
          tx.admin.toLowerCase().includes(term)
        if (!matchSearch) return false
      }

      if (activeFilters.status && tx.status !== activeFilters.status) return false

      if (activeFilters.dateRange) {
        const txDate = tx.date && tx.date !== 'N/A' ? new Date(tx.date.replace(' at ', ' ')).getTime() : null;
        if (txDate) {
          if (activeFilters.dateRange.from) {
            const from = new Date(activeFilters.dateRange.from + 'T00:00:00').getTime();
            if (txDate < from) return false;
          }
          if (activeFilters.dateRange.to) {
            const to = new Date(activeFilters.dateRange.to + 'T23:59:59').getTime();
            if (txDate > to) return false;
          }
        } else if (activeFilters.dateRange.from || activeFilters.dateRange.to) {
          return false;
        }
      }

      if (activeFilters.amountRange) {
        const amountNum = Number(tx.amount.replace(/[^\d.-]/g, ''));
        if (activeFilters.amountRange.min !== undefined) {
          if (amountNum < activeFilters.amountRange.min) return false;
        }
        if (activeFilters.amountRange.max !== undefined) {
          if (amountNum > activeFilters.amountRange.max) return false;
        }
      }

      if (activeFilters.txnType) {
        if (activeFilters.txnType === 'Payment' && !tx.incoming) return false;
        if (activeFilters.txnType === 'Payout' && tx.incoming) return false;
      }

      return true
    })
    .sort((a, b) => {
      const order = activeFilters.sort || 'Latest First'
      if (order === 'Highest Amount') {
        return Number(b.amount.replace(/[^\d.-]/g, '')) -
          Number(a.amount.replace(/[^\d.-]/g, ''))
      }

      if (order === 'Lowest Amount') {
        return Number(a.amount.replace(/[^\d.-]/g, '')) -
          Number(b.amount.replace(/[^\d.-]/g, ''))
      }

      const parseDate = (dateStr: string) => {
        return new Date(dateStr.replace(' at ', ' ')).getTime()
      }

      const dateA = parseDate(a.date)
      const dateB = parseDate(b.date)

      return order === 'Latest First'
        ? dateB - dateA
        : dateA - dateB
    })

  const columns = [
    {
      key: 'id',
      label: 'Transaction',
      render: (_: any, row: TransactionRecord) => (
        <div className="flex items-center gap-3">
          <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0
            ${row.incoming ? 'bg-green-50 text-green-500' : 'bg-red-50 text-red-500'}`}>
            {row.incoming ? <ArrowDownRight size={14} /> : <ArrowUpRight size={14} />}
          </div>
          <div>
            <p className="font-semibold text-gray-900 leading-none">{row.id}</p>
            <p className="text-[10px] uppercase font-mono text-gray-400 mt-1">{row.transactionId}</p>
          </div>
        </div>
      )
    },
    { key: 'date', label: 'Date', className: 'text-gray-500 text-xs' },
    { key: 'admin', label: 'Admin', className: 'text-gray-700 font-medium' },
    { key: 'type', label: 'Reference', className: 'text-gray-500 text-sm' },
    {
      key: 'amount',
      label: 'Amount',
      className: 'text-right',
      render: (val: string, row: any) => (
        <span className="font-bold text-gray-900">
          {row.incoming ? '+' : '-'}{val}
        </span>
      )
    },
    {
      key: 'status',
      label: 'Status',
      className: 'text-center',
      render: (val: string) => {
        if (val === 'Completed') return (
          <span className="inline-flex items-center gap-1.5 bg-green-50 text-green-600 px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-wide">
            <CheckCircle2 size={12} /> Completed
          </span>
        )
        if (val === 'Pending') return (
          <span className="inline-flex items-center gap-1.5 bg-yellow-50 text-yellow-600 px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-wide">
            <Clock size={12} /> Pending
          </span>
        )
        return (
          <span className="inline-flex items-center gap-1.5 bg-red-50 text-red-600 px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-wide">
            <XCircle size={12} /> Failed
          </span>
        )
      }
    },
    {
      key: 'actions',
      label: 'Invoice',
      className: 'text-center',
      render: (_: any, row: TransactionRecord) => {
        if (row.status === 'Completed') {
          return (
            <div className="flex justify-center">
              <Link
                to={`/invoice/${row.transactionId}`}
                className="flex items-center gap-1.5 text-primary-600 hover:text-primary-700 font-bold text-[11px] uppercase tracking-wide bg-primary-50 px-3 py-1.5 rounded-lg transition-colors group"
              >
                <FileText size={14} className="group-hover:scale-110 transition-transform" />
                View
              </Link>
            </div>
          )
        }

        return (
          <div className="flex justify-center uppercase tracking-wide">
            <button
              onClick={(e) => {
                e.stopPropagation()
                toast.error('Invoice Unavailable: Payment Not Completed', {
                  icon: <Lock className="text-red-500" size={18} />,
                  style: {
                    borderRadius: '12px',
                    background: '#fff',
                    color: '#991b1b',
                    fontWeight: 'bold',
                    fontSize: '12px',
                    border: '1px solid #fee2e2',
                    boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)'
                  }
                })
              }}
              className="flex items-center gap-1.5 text-gray-400 hover:text-gray-500 font-bold text-[11px] bg-gray-50 px-3 py-1.5 rounded-lg transition-colors cursor-pointer"
            >
              <FileText size={14} />
              View
            </button>
          </div>
        )
      }
    }
  ]

  return (
    <div className="space-y-6 pb-6 max-w-[1400px] mx-auto">
      {/* ── Page Header ── */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pt-1 scroll-animate delay-75">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight">Financial Transactions</h1>
          <p className="text-sm text-gray-500 mt-0.5">
            Full history of platform payments and payouts fetched from Razorpay logs
          </p>
        </div>
      </div>

      {/* ── Filter Bar ── */}
      <div className="relative z-20 scroll-animate delay-150">
        <FilterBar
          filters={filters}
          onFilterChange={handleFilterChange}
          onReset={handleReset}
          activeFiltersCount={activeFiltersCount}
        />
      </div>

      <DataTable
        columns={columns}
        data={filteredTx}
        isLoading={loading}
        onRowClick={() => { }}
        exportFileName="transactions_history"
        className="scroll-animate delay-300"
      />
    </div>
  )
}