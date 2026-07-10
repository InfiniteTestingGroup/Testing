import * as React from "react"
import { motion } from "framer-motion"
import {
  TrendingUp,
  Wallet,
  Calendar,
  ChevronLeft,
  ChevronRight,
  CreditCard,
  AlertCircle
} from "lucide-react"
import toast, { Toaster } from "react-hot-toast"
import { fetchPayments } from "../../services/payment"
import type { PaymentTransaction } from "../../types/payment"
import { PaymentTable } from "../../components/payment/PaymentTable"
import { PaymentFilters } from "../../components/payment/PaymentFilters"
// Helper for CSV Export
const exportToCSV = (data: PaymentTransaction[]) => {
  const headers = ["Transaction ID", "Ad Name", "Amount", "Status", "Method", "Date"]
  const rows = data.map(t => [t.transactionId, t.adName, t.amount, t.status, t.method, t.date])

  const content = [headers, ...rows].map(e => e.join(",")).join("\n")
  const blob = new Blob([content], { type: "text/csv;charset=utf-8;" })
  const link = document.createElement("a")
  link.href = URL.createObjectURL(blob)
  link.download = `transactions_${new Date().toLocaleDateString()}.csv`
  link.click()
}
export default function PaymentHistory() {
  const [data, setData] = React.useState<PaymentTransaction[]>([])
  const [stats, setStats] = React.useState({ totalRevenue: 0, successRate: 0, recentSettlements: 0 })
  const [loading, setLoading] = React.useState(true)

  // States for query
  const [search, setSearch] = React.useState("")
  const [status, setStatus] = React.useState("All")
  const [page, setPage] = React.useState(1)
  const [totalPages, setTotalPages] = React.useState(1)
  const limit = 10
  const loadData = React.useCallback(async () => {
    setLoading(true)
    try {
      const res = await fetchPayments({ page, limit, search, status })
      setData(res.data)
      setStats(res.stats)
      setTotalPages(res.totalPages)
    } catch (err) {
      toast.error("Failed to fetch payment records")
    } finally {
      setLoading(false)
    }
  }, [page, search, status])
  React.useEffect(() => {
    loadData()
  }, [loadData])
  const handleReset = () => {
    setSearch("")
    setStatus("All")
    setPage(1)
  }
  const handleExport = () => {
    if (data.length === 0) return toast.error("No data to export")
    exportToCSV(data)
    toast.success("CSV file generated!")
  }
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] p-6 lg:p-8 transition-colors duration-200">
      <Toaster position="top-right" />

      {/* Header */}
      <header className="mb-8">
        <div>
          <h1 className="text-2xl font-black text-gray-900 dark:text-white uppercase tracking-tight">Payment History</h1>
          <p className="text-gray-500 text-sm mt-1">Track and manage all ad-related financial transactions</p>
        </div>
      </header>
      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        {[
          { label: "Total Platform Spent", value: `₹${stats.totalRevenue.toLocaleString()}`, icon: Wallet, color: "text-brand-500", bg: "bg-brand-50 dark:bg-brand-500/10" },
          { label: "Success Rate", value: `${stats.successRate}%`, icon: TrendingUp, color: "text-green-500", bg: "bg-green-50 dark:bg-green-500/10" }
        ].map((stat, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1 }}
            className="bg-white dark:bg-[#1A1D24] p-6 rounded-3xl border border-gray-200 dark:border-gray-800 shadow-sm"
          >
            <div className="flex items-center justify-between mb-4">
              <div className={`p-3 rounded-2xl ${stat.bg} ${stat.color}`}>
                <stat.icon className="w-5 h-5" />
              </div>
              <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Active Stats</span>
            </div>
            <p className="text-sm font-bold text-gray-500 uppercase tracking-tighter mb-1">{stat.label}</p>
            <h3 className="text-3xl font-black text-gray-900 dark:text-white">{stat.value}</h3>
          </motion.div>
        ))}
      </div>
      {/* Controls & Table */}
      <div className="space-y-6">
        <PaymentFilters
          search={search}
          onSearchChange={setSearch}
          status={status}
          onStatusChange={setStatus}
          onReset={handleReset}
          onExport={handleExport}
        />
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          <PaymentTable data={data} isLoading={loading} />
        </motion.div>
        {/* Pagination */}
        {!loading && data.length > 0 && (
          <div className="flex items-center justify-between px-2">
            <p className="text-xs text-gray-500 font-medium tracking-wide font-mono uppercase">
              Showing page <span className="text-brand-500 font-black">{page}</span> of {totalPages}
            </p>
            <div className="flex gap-2">
              <button
                disabled={page === 1}
                onClick={() => setPage(p => p - 1)}
                className="p-2 border border-gray-200 dark:border-gray-800 rounded-xl text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
              >
                <ChevronLeft className="w-5 h-5" />
              </button>
              <button
                disabled={page === totalPages}
                onClick={() => setPage(p => p + 1)}
                className="p-2 border border-gray-200 dark:border-gray-800 rounded-xl text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
              >
                <ChevronRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        )}
      </div>
      {/* Trust Footer */}
      <div className="mt-12 flex flex-col items-center justify-center gap-4 py-8 border-t border-gray-100 dark:border-gray-800">
        <div className="flex items-center gap-2 text-gray-400">
          <AlertCircle className="w-4 h-4" />
          <span className="text-xs font-bold uppercase tracking-widest italic">All transactions are settled via Razorpay Secure Node</span>
        </div>
      </div>
    </div>
  )
}
