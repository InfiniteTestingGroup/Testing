import * as React from "react"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { motion } from "framer-motion"
import { ArrowLeft, Send, Upload, X, FileText, CheckCircle2, Loader2 } from "lucide-react"
import { useNavigate } from "react-router-dom"
import toast, { Toaster } from "react-hot-toast"

import { createTicket } from "../../services/tickets"

const ticketSchema = z.object({
  subject: z.string().min(5, "Subject must be at least 5 characters"),
  category: z.enum(["Technical Issue", "Payment Issue", "Ad Issue", "Other"]),
  description: z.string().min(10, "Description must be at least 10 characters"),
})

type TicketFormData = z.infer<typeof ticketSchema>

export default function CreateTicket() {
  const navigate = useNavigate()
  const [isSubmitting, setIsSubmitting] = React.useState(false)
  const [attachments, setAttachments] = React.useState<File[]>([])

  const { register, handleSubmit, formState: { errors } } = useForm<TicketFormData>({
    resolver: zodResolver(ticketSchema),
    defaultValues: {
      category: "Technical Issue"
    }
  })

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const files = Array.from(e.target.files)
      setAttachments(prev => [...prev, ...files])
    }
  }

  const removeFile = (index: number) => {
    setAttachments(prev => prev.filter((_, i) => i !== index))
  }

  const onSubmit = async (data: TicketFormData) => {
    setIsSubmitting(true)
    try {
      await createTicket(data)
      toast.success("Support ticket raised successfully")
      setTimeout(() => navigate("/admin/tickets"), 1500)
    } catch (err) {
      toast.error("Failed to create ticket")
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-[#0E1117] py-12 px-6">
      <Toaster position="top-right" />
      
      <div className="max-w-3xl mx-auto">
        <button 
          onClick={() => navigate("/admin/tickets")}
          className="flex items-center gap-2 text-sm font-bold text-gray-500 hover:text-gray-900 dark:hover:text-white mb-8 transition-colors group"
        >
          <ArrowLeft className="w-4 h-4 transition-transform group-hover:-translate-x-1" />
          Back to Tickets
        </button>

        <header className="mb-10 text-center">
           <h1 className="text-4xl font-black text-gray-900 dark:text-white tracking-tighter uppercase mb-2">Raise Support Ticket</h1>
           <p className="text-gray-500 font-medium">Detailed information helps us resolve issues faster.</p>
        </header>

        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="bg-white dark:bg-[#1A1D24] p-10 rounded-[2.5rem] border border-gray-100 dark:border-gray-800 shadow-2xl transition-colors"
        >
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
            {/* Subject */}
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase tracking-widest text-gray-400">Subject</label>
              <input 
                {...register("subject")}
                placeholder="Brief summary of the issue"
                className={`w-full px-6 py-4 bg-gray-50 dark:bg-[#0E1117] border rounded-2xl text-sm font-bold transition-all focus:ring-4 ${
                  errors.subject ? "border-red-500 focus:ring-red-500/10" : "border-gray-100 dark:border-gray-800 focus:border-blue-500 focus:ring-blue-500/10"
                } dark:text-white`}
              />
              {errors.subject && <p className="text-xs font-bold text-red-500">{errors.subject.message}</p>}
            </div>

            {/* Category */}
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase tracking-widest text-gray-400">Category</label>
              <select 
                {...register("category")}
                className="w-full px-6 py-4 bg-gray-50 dark:bg-[#0E1117] border border-gray-100 dark:border-gray-800 rounded-2xl text-sm font-bold transition-all focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 dark:text-white appearance-none cursor-pointer"
              >
                <option value="Technical Issue">Technical Issue</option>
                <option value="Payment Issue">Payment Issue</option>
                <option value="Ad Issue">Ad Issue</option>
                <option value="Other">Other Category</option>
              </select>
            </div>

            {/* Description */}
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase tracking-widest text-gray-400">Full Description</label>
              <textarea 
                {...register("description")}
                rows={6}
                placeholder="Please describe your issue in detail. Include any transaction IDs or ad titles if relevant."
                className={`w-full px-6 py-4 bg-gray-50 dark:bg-[#0E1117] border rounded-2xl text-sm font-bold resize-none transition-all focus:ring-4 ${
                  errors.description ? "border-red-500 focus:ring-red-500/10" : "border-gray-100 dark:border-gray-800 focus:border-blue-500 focus:ring-blue-500/10"
                } dark:text-white`}
              />
              {errors.description && <p className="text-xs font-bold text-red-500">{errors.description.message}</p>}
            </div>

            {/* Attachments */}
            <div className="space-y-4">
              <label className="text-[10px] font-black uppercase tracking-widest text-gray-400 block">Attachments (Optional)</label>
              
              <div className="flex flex-wrap gap-4">
                {attachments.map((file, i) => (
                  <div key={i} className="flex items-center gap-3 bg-blue-50 dark:bg-blue-500/10 p-3 rounded-xl border border-blue-100 dark:border-blue-500/20 group">
                    <FileText className="w-4 h-4 text-blue-600" />
                    <span className="text-xs font-bold text-blue-900 dark:text-blue-300 truncate max-w-[150px]">{file.name}</span>
                    <button type="button" onClick={() => removeFile(i)} className="text-blue-400 hover:text-red-500 transition-colors">
                      <X className="w-3 h-3" />
                    </button>
                  </div>
                ))}
                
                <label className="flex items-center gap-2 px-6 py-3 border-2 border-dashed border-gray-200 dark:border-gray-800 rounded-2xl cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all text-gray-400 hover:text-blue-600 hover:border-blue-500/50 group">
                  <Upload className="w-4 h-4" />
                  <span className="text-xs font-bold uppercase tracking-wider">Add File</span>
                  <input type="file" className="hidden" multiple onChange={handleFileChange} accept="image/*,.pdf" />
                </label>
              </div>
              <p className="text-[10px] text-gray-400 italic">Max size: 5MB per file (PNG, JPG, PDF supported)</p>
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full flex items-center justify-center gap-3 py-5 bg-blue-600 text-white rounded-3xl font-black text-sm uppercase tracking-widest hover:bg-blue-700 transition-all active:scale-[0.98] shadow-2xl shadow-blue-600/20 disabled:opacity-50 disabled:active:scale-100"
            >
              {isSubmitting ? (
                 <>
                   <Loader2 className="w-5 h-5 animate-spin" />
                   Raising Ticket...
                 </>
              ) : (
                <>
                  <Send className="w-5 h-5" />
                  Submit Support Request
                </>
              )}
            </button>
          </form>
        </motion.div>

        {/* Security Trust */}
        <div className="mt-8 flex items-center justify-center gap-2 text-gray-400">
           <CheckCircle2 className="w-4 h-4" />
           <p className="text-[11px] font-bold uppercase tracking-widest">Securely Encrypted Support Request</p>
        </div>
      </div>
    </div>
  )
}
