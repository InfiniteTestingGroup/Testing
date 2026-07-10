import * as React from "react"
import { Send, Paperclip, Loader2, RefreshCw } from "lucide-react"

interface ReplySectionProps {
  onReply: (content: string) => Promise<void>
  disabled: boolean
}

export function ReplySection({ onReply, disabled }: ReplySectionProps) {
  const [content, setContent] = React.useState("")
  const [isSending, setIsSending] = React.useState(false)

  const handleSend = async () => {
    if (!content.trim() || isSending) return
    setIsSending(true)
    try {
      await onReply(content.trim())
      setContent("")
    } finally {
      setIsSending(false)
    }
  }

  return (
    <div className="bg-white dark:bg-[#1A1D24] p-6 border-t border-gray-100 dark:border-gray-800 transition-colors">
      <div className="max-w-4xl mx-auto flex items-end gap-4">
        {/* Attachment Button */}
        <button 
          disabled={disabled}
          className="p-3.5 bg-gray-50 dark:bg-[#0E1117] text-gray-400 hover:text-blue-600 rounded-2xl border border-gray-100 dark:border-gray-700 transition-all active:scale-95 disabled:opacity-50"
        >
          <Paperclip className="w-5 h-5" />
        </button>

        {/* Text Area */}
        <div className="flex-1 relative">
           <textarea
             disabled={disabled || isSending}
             rows={1}
             value={content}
             onChange={(e) => setContent(e.target.value)}
             onKeyDown={(e) => {
               if (e.key === "Enter" && !e.shiftKey) {
                 e.preventDefault()
                 handleSend()
               }
             }}
             placeholder={disabled ? "Ticket is resolved. Re-open to reply." : "Type your message here..."}
             className="w-full px-6 py-4 bg-gray-50 dark:bg-[#0E1117] border border-gray-100 dark:border-gray-700 rounded-[2rem] text-sm font-medium focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 outline-none transition-all placeholder:text-gray-400 dark:text-white resize-none max-h-32 disabled:bg-gray-100 dark:disabled:bg-gray-900/50"
           />
        </div>

        {/* Send Button */}
        <button
          onClick={handleSend}
          disabled={disabled || !content.trim() || isSending}
          className="p-4 bg-blue-600 text-white rounded-[2rem] shadow-xl shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-95 disabled:opacity-50 disabled:scale-100"
        >
          {isSending ? <Loader2 className="w-5 h-5 animate-spin" /> : <Send className="w-5 h-5" />}
        </button>
      </div>
      
      {!disabled && (
        <div className="max-w-4xl mx-auto flex items-center justify-center gap-4 mt-4 opacity-40">
           <div className="h-px bg-gray-200 dark:bg-gray-800 flex-1" />
           <p className="text-[9px] font-black uppercase tracking-[0.2em] text-gray-500">Press ENTER to send message</p>
           <div className="h-px bg-gray-200 dark:bg-gray-800 flex-1" />
        </div>
      )}
    </div>
  )
}
