import * as React from "react"
import { useParams, useNavigate } from "react-router-dom"
import { motion, AnimatePresence } from "framer-motion"
import { 
  ArrowLeft, 
  Loader2, 
  CheckCircle2, 
  History
} from "lucide-react"
import toast, { Toaster } from "react-hot-toast"

import { getTicketById, replyToTicket } from "../../services/tickets"
import type { Ticket } from "../../types/ticket"
import { MessageBubble } from "../../components/tickets/MessageBubble"
import { ReplySection } from "../../components/tickets/ReplySection"
import { Badge } from "../../components/ui/Badge"

export default function TicketDetails() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [ticket, setTicket] = React.useState<Ticket | null>(null)
  const [loading, setLoading] = React.useState(true)
  
  const scrollRef = React.useRef<HTMLDivElement>(null)

  const loadTicket = React.useCallback(async () => {
    if (!id) return
    try {
      const data = await getTicketById(id)
      if (!data) {
        toast.error("Ticket not found")
        navigate("/admin/tickets")
        return
      }
      setTicket(data)
    } finally {
      setLoading(false)
    }
  }, [id, navigate])

  React.useEffect(() => {
    loadTicket()
  }, [loadTicket])

  // Scroll to bottom on new message
  React.useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight
    }
  }, [ticket?.messages])

  const handleReply = async (content: string) => {
    if (!id) return
    try {
      await replyToTicket(id, content)
      loadTicket() // Refresh the thread
      toast.success("Response sent")
    } catch (err) {
      toast.error("Failed to send reply")
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <Loader2 className="w-10 h-10 text-brand-500 animate-spin" />
      </div>
    )
  }

  if (!ticket) return null

  const isResolved = ticket.status === "Resolved"

  return (
    <div className="h-screen bg-[#F8F9FB] dark:bg-[#0E1117] flex flex-col transition-colors duration-200">
      <Toaster position="top-right" />
      
      {/* Top Navigation & Status */}
      <header className="bg-white dark:bg-[#1A1D24] border-b border-gray-100 dark:border-gray-800 px-8 py-4 shadow-sm z-30 flex items-center justify-between">
        <div className="flex items-center gap-6">
          <button 
            onClick={() => navigate("/admin/tickets")}
            className="p-2 text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          
          <div className="h-10 w-px bg-gray-100 dark:bg-gray-800" />
          
          <div>
            <div className="flex items-center gap-3">
              <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">{ticket.id}</span>
              <h1 className="text-lg font-black text-gray-900 dark:text-white tracking-tight">{ticket.subject}</h1>
              <Badge variant={ticket.status === "Open" ? "info" : ticket.status === "In Progress" ? "warning" : "success" as any} className="uppercase text-[9px] font-black tracking-widest px-3">
                {ticket.status}
              </Badge>
            </div>
            <div className="flex items-center gap-4 mt-1">
               <span className="text-xs font-bold text-blue-600 bg-blue-50 dark:bg-blue-500/10 px-2 py-0.5 rounded-md">{ticket.category}</span>
               <Badge variant={ticket.priority === "Urgent" ? "danger" : ticket.priority === "High" ? "warning" : ticket.priority === "Medium" ? "info" : "success" as any} className="uppercase text-[9px] font-black tracking-widest px-3">
                 {ticket.priority} Priority
               </Badge>
               <span className="text-[10px] text-gray-400 font-medium">Last updated {new Date(ticket.updatedAt).toLocaleString()}</span>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2 px-6 py-3 bg-gray-50 dark:bg-[#0E1117] rounded-2xl border border-gray-100 dark:border-gray-800 text-gray-500">
           <History className="w-4 h-4" />
           <span className="text-xs font-bold uppercase tracking-wider">Activity Feed</span>
        </div>
      </header>

      {/* Conversation Area */}
      <main 
        ref={scrollRef}
        className="flex-1 overflow-y-auto px-8 py-10 scroll-smooth"
      >
        <div className="max-w-4xl mx-auto">
          {/* Initial Request Indicator */}
          <div className="flex items-center gap-4 mb-12 opacity-40">
             <div className="h-px bg-gray-200 dark:bg-gray-800 flex-1" />
             <p className="text-[10px] font-black uppercase tracking-[0.3em] text-gray-500">Conversation Started</p>
             <div className="h-px bg-gray-200 dark:bg-gray-800 flex-1" />
          </div>

          <AnimatePresence>
            {ticket.messages.map((msg) => (
              <MessageBubble key={msg.id} message={msg} />
            ))}
          </AnimatePresence>

          {isResolved && (
            <motion.div 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="mt-12 p-8 bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-100 dark:border-emerald-500/20 rounded-[2.5rem] text-center max-w-2xl mx-auto"
            >
               <div className="w-16 h-16 bg-emerald-500 rounded-full flex items-center justify-center text-white mx-auto mb-6 shadow-xl shadow-emerald-500/20">
                  <CheckCircle2 className="w-8 h-8" />
               </div>
               <h3 className="text-xl font-black text-emerald-900 dark:text-emerald-100 tracking-tight mb-2">Issue Resolved</h3>
               <p className="text-emerald-700 dark:text-emerald-400 font-medium text-sm leading-relaxed">This ticket has been marked as resolved. If you still need help, simply send a message below to re-open the conversation.</p>
            </motion.div>
          )}

          {/* Spacer to prevent content overlap with reply box */}
          <div className="h-20" />
        </div>
      </main>

      {/* Reply Footer */}
      <ReplySection onReply={handleReply} disabled={false} />
    </div>
  )
}
