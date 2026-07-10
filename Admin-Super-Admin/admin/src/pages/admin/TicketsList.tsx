import * as React from "react"
import { Plus, HelpCircle, LifeBuoy, Clock, CheckCircle } from "lucide-react"
import { useNavigate } from "react-router-dom"
import toast, { Toaster } from "react-hot-toast"

import { fetchTickets, reopenTicket } from "../../services/tickets"
import type { Ticket } from "../../types/ticket"
import { TicketFilters } from "../../components/tickets/TicketFilters"
import { TicketTable } from "../../components/tickets/TicketTable"

export default function TicketsList() {
  const navigate = useNavigate()
  const [tickets, setTickets] = React.useState<Ticket[]>([])
  const [loading, setLoading] = React.useState(true)
  const [filters, setFilters] = React.useState({ query: "", status: "All", category: "All", priority: "All" })
  const [ticketTab, setTicketTab] = React.useState<'active' | 'closed'>('active')

  const visibleTickets = React.useMemo(() => {
    return tickets.filter((ticket) => {
      const isClosed = ticket.status === 'Resolved' || ticket.status === 'Closed';
      if (ticketTab === 'active' && isClosed) return false;
      if (ticketTab === 'closed' && !isClosed) return false;

      // Status Filter
      if (filters.status && filters.status !== "All" && ticket.status !== filters.status) return false;

      // Category Filter
      if (filters.category && filters.category !== "All" && ticket.category !== filters.category) return false;

      // Priority Filter
      if (filters.priority && filters.priority !== "All" && ticket.priority !== filters.priority) return false;

      // Search Query
      if (filters.query) {
        const q = filters.query.toLowerCase();
        const matchesSubject = (ticket.subject || "").toLowerCase().includes(q);
        const matchesId = (ticket.id || "").toLowerCase().includes(q);
        if (!matchesSubject && !matchesId) return false;
      }

      return true;
    });
  }, [tickets, ticketTab, filters]);

  const loadTickets = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchTickets()
      setTickets(data)
    } catch (err) {
      toast.error("Failed to sync support requests")
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => {
    loadTickets()
  }, [loadTickets])

  const handleReopen = async (id: string) => {
    try {
      await reopenTicket(id)
      toast.success("Ticket re-opened")
      loadTickets()
    } catch (err) {
      toast.error("Failed to re-open ticket")
    }
  }

  return (
    <div className="min-h-screen bg-[#F8F9FB] dark:bg-[#0E1117] p-8 transition-colors duration-200">
      <Toaster position="top-right" />

      {/* Header */}
      <header className="mb-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div className="flex items-center gap-4">
          <div className="w-14 h-14 bg-brand-500 rounded-2xl flex items-center justify-center text-white shadow-2xl shadow-brand-500/20">
            <LifeBuoy className="w-7 h-7" />
          </div>
          <div>
            <h1 className="text-3xl font-black text-gray-900 dark:text-white uppercase tracking-tighter">Support Hub</h1>
            <p className="text-gray-500 text-sm font-medium">Expert assistance for all your campaign needs</p>
          </div>
        </div>

        <button
          onClick={() => navigate("/admin/tickets/new")}
          className="flex items-center gap-2 px-6 py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest transition-all active:scale-95 shadow-xl shadow-brand-500/20"
        >
          <Plus className="w-5 h-5" />
          Create New Ticket
        </button>
      </header>

      {/* Main UI */}
      <main className="animate-in fade-in slide-in-from-bottom-4 duration-700">
        <div className="flex items-center gap-1 bg-gray-200/50 dark:bg-gray-800/50 p-1 rounded-2xl w-fit mb-6">
          <button
            onClick={() => setTicketTab('active')}
            className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all ${
              ticketTab === 'active' 
                ? "bg-white dark:bg-[#1A1D24] text-brand-600 dark:text-brand-400 shadow-sm" 
                : "text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
            }`}
          >
            <Clock className="w-4 h-4" />
            Active Tickets
          </button>
          <button
            onClick={() => setTicketTab('closed')}
            className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all ${
              ticketTab === 'closed' 
                ? "bg-white dark:bg-[#1A1D24] text-brand-600 dark:text-brand-400 shadow-sm" 
                : "text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
            }`}
          >
            <CheckCircle className="w-4 h-4" />
            Closed Tickets
          </button>
        </div>

        <TicketFilters onFilterChange={setFilters} ticketTab={ticketTab} />

        <TicketTable
          data={visibleTickets}
          isLoading={loading}
          onReopen={handleReopen}
        />

        {/* Help Banner */}
        <div className="mt-12 p-8 bg-gray-900 rounded-[2.5rem] relative overflow-hidden group">
          <HelpCircle className="absolute right-[-2.5rem] top-[-2.5rem] w-64 h-64 text-white/5 group-hover:rotate-12 transition-transform duration-1000" />
          <div className="relative z-10 flex flex-col md:flex-row items-center justify-between gap-8">
            <div>
              <h3 className="text-xl font-black text-white tracking-tight mb-2">Need immediate technical help?</h3>
              <p className="text-gray-400 text-sm font-medium max-w-lg">Our technical specialists are available 24/7 for urgent ad-delivery issues. High priority tickets are usually resolved within 2 hours.</p>
            </div>
            <button className="px-8 py-3.5 bg-white text-gray-900 rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-gray-100 transition-all active:scale-95">
              Contact Hotline
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}
