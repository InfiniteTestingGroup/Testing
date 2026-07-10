
import React from 'react';

interface Message {
  id: string;
  sender: string;
  text: string;
  timestamp: string;
  isMe: boolean;
}

interface TicketThreadProps {
  messages: Message[];
}

const TicketThread: React.FC<TicketThreadProps> = ({ messages }) => {
  return (
    <div className="space-y-6 pb-4">
      {messages.map((message) => (
        <div 
          key={message.id} 
          className={`flex flex-col ${message.isMe ? 'items-end' : 'items-start animate-slide-in-left'}`}
        >
          {/* Sender & Time */}
          <div className="flex items-center gap-2 mb-1.5 px-1">
             {!message.isMe && <span className="text-[10px] font-black text-gray-900 uppercase tracking-widest">{message.sender}</span>}
             <span className="text-[10px] font-bold text-gray-400">{message.timestamp}</span>
             {message.isMe && <span className="text-[10px] font-black text-primary-600 uppercase tracking-widest">You</span>}
          </div>

          {/* Message Bubble */}
          <div 
            className={`max-w-[85%] px-5 py-3 rounded-[1.5rem] text-sm font-medium shadow-sm leading-relaxed
              ${message.isMe 
                ? 'bg-primary-600 text-white rounded-tr-none shadow-primary-200' 
                : 'bg-white text-gray-800 border border-gray-100 rounded-tl-none'
              }`}
          >
            {message.text}
          </div>
        </div>
      ))}
      
      {/* Scroll Anchor */}
      <div id="thread-bottom" />
    </div>
  );
};

export default TicketThread;
