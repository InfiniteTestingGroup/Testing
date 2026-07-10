import * as React from "react"
import { motion } from "framer-motion"
import { User, ShieldCheck, FileText, ExternalLink } from "lucide-react"
import { cn } from "../../lib/utils"
import type { Message } from "../../types/ticket"

interface MessageBubbleProps {
  message: Message
}

export function MessageBubble({ message }: MessageBubbleProps) {
  const isSupport = message.sender === "Super Admin"

  return (
    <motion.div
      initial={{ opacity: 0, y: 10, x: isSupport ? -10 : 10 }}
      animate={{ opacity: 1, y: 0, x: 0 }}
      className={cn(
        "flex w-full mb-6 gap-3",
        isSupport ? "justify-start" : "justify-end"
      )}
    >
      {/* Avatar (Support only) */}
      {isSupport && (
        <div className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white flex-shrink-0 shadow-lg shadow-blue-500/20">
           <ShieldCheck className="w-5 h-5" />
        </div>
      )}

      <div className={cn(
        "max-w-[75%] space-y-2",
        isSupport ? "items-start text-left" : "items-end text-right"
      )}>
        {/* Author & Time */}
        <div className="flex items-center gap-2 group">
           {!isSupport && <span className="text-[10px] text-gray-400 font-bold">{new Date(message.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>}
           <span className="text-xs font-black uppercase tracking-widest text-gray-500">{message.sender}</span>
           {isSupport && <span className="text-[10px] text-gray-400 font-bold">{new Date(message.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>}
        </div>

        {/* Bubble */}
        <div className={cn(
          "px-6 py-4 rounded-[2rem] text-sm font-medium leading-relaxed shadow-sm transition-all",
          isSupport 
            ? "bg-white dark:bg-[#1A1D24] border border-gray-100 dark:border-gray-800 text-gray-900 dark:text-gray-100 rounded-tl-none" 
            : "bg-blue-600 text-white rounded-tr-none shadow-blue-600/10"
        )}>
          {message.content}
        </div>

        {/* Attachments */}
        {message.attachments && message.attachments.length > 0 && (
          <div className={cn("flex flex-wrap gap-2 mt-2", isSupport ? "justify-start" : "justify-end")}>
            {message.attachments.map((file, i) => (
              <div key={i} className="flex items-center gap-2 px-3 py-2 bg-gray-50 dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 hover:border-blue-500/30 transition-all cursor-pointer group">
                <FileText className="w-4 h-4 text-blue-500" />
                <span className="text-[10px] font-bold text-gray-700 dark:text-gray-300 truncate max-w-[120px]">{file.name}</span>
                <ExternalLink className="w-3 h-3 text-gray-400 group-hover:text-blue-500" />
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Avatar (Admin only) */}
      {!isSupport && (
        <div className="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-800 flex items-center justify-center text-gray-600 dark:text-gray-300 flex-shrink-0">
           <User className="w-5 h-5" />
        </div>
      )}
    </motion.div>
  )
}
